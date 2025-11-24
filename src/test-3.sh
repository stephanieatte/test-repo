#!/bin/bash
set -euo pipefail

# Your org and suite slugs
ORG_SLUG="atte-test-org-1"
SUITE_SLUG="my-rspec-example-test-suite"

# Retry configuration
MAX_RETRIES=5
RETRY_DELAY=60
ATTEMPT=0

echo "⏳ Waiting for test results to be uploaded..."

# Retry loop
while [ $ATTEMPT -lt $MAX_RETRIES ]; do
  ATTEMPT=$((ATTEMPT + 1))
  echo "Attempt $ATTEMPT/$MAX_RETRIES: Fetching test runs for build ${BUILDKITE_BUILD_ID}..."
  
  RUNS=$(curl -s -H "Authorization: Bearer ${BUILDKITE_API_TOKEN}" \
    "https://api.buildkite.com/v2/analytics/organizations/${ORG_SLUG}/suites/${SUITE_SLUG}/runs?build_id=${BUILDKITE_BUILD_ID}")
  
  # Check if we got valid JSON array
  if echo "$RUNS" | jq -e 'type == "array"' > /dev/null 2>&1; then
    TOTAL_RUNS=$(echo "$RUNS" | jq 'length')
    
    # If we found runs, break out of retry loop
    if [ "$TOTAL_RUNS" -gt 0 ]; then
      echo "✅ Found $TOTAL_RUNS test run(s)!"
      break
    fi
  fi
  
  # If this isn't the last attempt, wait before retrying
  if [ $ATTEMPT -lt $MAX_RETRIES ]; then
    echo "No results yet, waiting ${RETRY_DELAY} seconds before retry..."
    sleep $RETRY_DELAY
  fi
done

# Check if we got valid JSON array after all retries
if ! echo "$RUNS" | jq -e 'type == "array"' > /dev/null 2>&1; then
  echo "❌ Error: API did not return an array. Response:"
  echo "$RUNS"
  
  # Create error annotation
  buildkite-agent annotate --context "test-summary" --style "error" << EOF
## ⚠️ Test Summary Unavailable

Could not fetch test results from Buildkite Test Analytics after $MAX_RETRIES attempts.

**Possible issues:**
- Test suite slug might be incorrect
- Tests failed to upload
- API token lacks required permissions

**API Response:** 
\`\`\`
$RUNS
\`\`\`
EOF
  exit 1
fi

# Check if array is still empty after all retries
TOTAL_RUNS=$(echo "$RUNS" | jq 'length')
if [ "$TOTAL_RUNS" -eq 0 ]; then
  buildkite-agent annotate --context "test-summary" --style "warning" << EOF
## 📭 No Test Results Yet

No test runs found for build #${BUILDKITE_BUILD_NUMBER} after waiting $(($MAX_RETRIES * $RETRY_DELAY)) seconds.

Tests may not have uploaded or the suite slug may be incorrect.
EOF
  exit 0
fi

# Parse results
PASSED=$(echo "$RUNS" | jq '[.[] | select(.result == "passed")] | length')
FAILED=$(echo "$RUNS" | jq '[.[] | select(.result == "failed")] | length')

# Create markdown annotation
cat << EOF > test-summary.md
## 🧪 Test Results Summary

**Build:** $BUILDKITE_BUILD_NUMBER
**Passed:** ✅ $PASSED/$TOTAL_RUNS
**Failed:** ❌ $FAILED/$TOTAL_RUNS

EOF

# Add passed runs if any
if [ "$PASSED" -gt 0 ]; then
  echo "**✅ Passed Runs:**" >> test-summary.md
  echo "$RUNS" | jq -r '.[] | select(.result == "passed") | "- [\(.branch)@\(.commit_sha[0:7])](\(.web_url))"' >> test-summary.md
  echo "" >> test-summary.md
fi

# Add failed runs if any
if [ "$FAILED" -gt 0 ]; then
  echo "**❌ Failed Runs:**" >> test-summary.md
  echo "$RUNS" | jq -r '.[] | select(.result == "failed") | "- [\(.branch)@\(.commit_sha[0:7])](\(.web_url))"' >> test-summary.md
  echo "" >> test-summary.md
fi

# Post annotation
buildkite-agent annotate --context "test-summary" --style "info" < test-summary.md
