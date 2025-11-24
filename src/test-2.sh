#!/bin/bash
set -euo pipefail

# Delay before starting to allow tests to upload
echo "⏳ Waiting 30 seconds for test results to be uploaded..."
sleep 30 

# Your org and suite slugs
ORG_SLUG="atte-test-org-1"
SUITE_SLUG="my-rspec-example-test-suite"

# Query runs for this build
echo "Fetching test runs for build ${BUILDKITE_BUILD_ID}..."
RUNS=$(curl -s -H "Authorization: Bearer ${BUILDKITE_API_TOKEN}" \
  "https://api.buildkite.com/v2/analytics/organizations/${ORG_SLUG}/suites/${SUITE_SLUG}/runs?build_id=${BUILDKITE_BUILD_ID}")

# Debug: Show what we got
echo "API Response:"
echo "$RUNS" | jq '.' || echo "Failed to parse JSON. Raw response: $RUNS"

# Check if we got valid JSON array
if ! echo "$RUNS" | jq -e 'type == "array"' > /dev/null 2>&1; then
  echo "❌ Error: API did not return an array. Response:"
  echo "$RUNS"
  
  # Create error annotation
  buildkite-agent annotate --context "test-summary" --style "error" << EOF
## ⚠️ Test Summary Unavailable

Could not fetch test results from Buildkite Test Analytics.

**Possible issues:**
- Test suite slug might be incorrect
- No tests have been uploaded for this build yet
- API token lacks required permissions

**API Response:** 
\`\`\`
$RUNS
\`\`\`
EOF
  exit 1
fi

# Check if array is empty
TOTAL_RUNS=$(echo "$RUNS" | jq 'length')
if [ "$TOTAL_RUNS" -eq 0 ]; then
  buildkite-agent annotate --context "test-summary" --style "warning" << EOF
## 📭 No Test Results Yet

No test runs found for build #${BUILDKITE_BUILD_NUMBER}.

Tests may still be uploading or haven't started yet.
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
