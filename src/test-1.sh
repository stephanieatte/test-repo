#!/bin/bash
      set -euo pipefail
      
      # Your org and suite slugs
      ORG_SLUG="atte-test-org-1"
      SUITE_SLUG="my-rspec-example-test-suite"  # Find this in Test Engine URL
      
      # Query runs for this build
      RUNS=$(curl -s -H "Authorization: Bearer $$BUILDKITE_API_TOKEN" \
        "https://api.buildkite.com/v2/analytics/organizations/$$ORG_SLUG/suites/$$SUITE_SLUG/runs?build_id=$$BUILDKITE_BUILD_ID")
      
      # Parse results
      TOTAL_RUNS=$(echo "$RUNS" | jq 'length')
      PASSED=$(echo "$RUNS" | jq '[.[] | select(.result == "passed")] | length')
      FAILED=$(echo "$RUNS" | jq '[.[] | select(.result == "failed")] | length')
      
      # Create markdown annotation
      cat << EOF > test-summary.md
      ## 🧪 Test Results Summary
      
      **Build:** $BUILDKITE_BUILD_NUMBER
      **Total Test Runs:** $TOTAL_RUNS
      **Passed:** ✅ $PASSED
      **Failed:** ❌ $FAILED
      
      ### Test Suite Links
      EOF
      
      # Add links to each run
      echo "$RUNS" | jq -r '.[] | "- [\(.result | ascii_upcase)] [\(.branch)@\(.commit_sha[0:7])](\(.web_url))"' >> test-summary.md
      
      # Post annotation
      buildkite-agent annotate --context "test-summary" --style "info" < test-summary.md
