#!/bin/bash
set -euo pipefail

# Wait 1 minute before starting
echo "⏳ Waiting 60 seconds for tests to complete..."
sleep 60

# Your org and suite slugs
ORG_SLUG="atte-test-org-1"
SUITE_SLUG="my-rspec-example-test-suite"

echo "Fetching test runs for build ${BUILDKITE_BUILD_ID}..."

# Fetch runs
RUNS=$(curl -s -H "Authorization: Bearer ${BUILDKITE_API_TOKEN}" \
  "https://api.buildkite.com/v2/analytics/organizations/${ORG_SLUG}/suites/${SUITE_SLUG}/runs?build_id=${BUILDKITE_BUILD_ID}")

# Debug output
echo "Raw API response:"
echo "$RUNS"

# Count totals
TOTAL=$(echo "$RUNS" | jq 'length')
PASSED=$(echo "$RUNS" | jq '[.[] | select(.result == "passed")] | length')
FAILED=$(echo "$RUNS" | jq '[.[] | select(.result == "failed")] | length')

echo "Total: $TOTAL, Passed: $PASSED, Failed: $FAILED"

# Create annotation
buildkite-agent annotate --context "test-summary" --style "info" << EOF
## 🧪 Test Results

**Total Runs:** $TOTAL
**Passed:** ✅ $PASSED
**Failed:** ❌ $FAILED

$(if [ "$PASSED" -gt 0 ]; then
  echo "### ✅ Passed Runs"
  echo ""
  echo "| ID | Branch | Commit | State | Result | Link |"
  echo "|---|---|---|---|---|---|"
  echo "$RUNS" | jq -r '.[] | select(.result == "passed") | "| `\(.id[0:8])` | `\(.branch)` | `\(.commit_sha[0:7])` | \(.state) | \(.result) | [View](\(.web_url)) |"'
  echo ""
fi)

$(if [ "$FAILED" -gt 0 ]; then
  echo "### ❌ Failed Runs"
  echo ""
  echo "| ID | Branch | Commit | State | Result | Link |"
  echo "|---|---|---|---|---|---|"
  echo "$RUNS" | jq -r '.[] | select(.result == "failed") | "| `\(.id[0:8])` | `\(.branch)` | `\(.commit_sha[0:7])` | \(.state) | \(.result) | [View](\(.web_url)) |"'
  echo ""
fi)
EOF
