#!/bin/bash

# Define variables
ORG_NAME="atte-test-org-1"
PIPELINE_NAME="first"
API_TOKEN="bkua_63fa9fec9d119f650e8b00a2b5f0c5c20036cc65"

build_id="9053"
#cooldown_seconds=36  # 1 hour cooldown

build_url="https://api.buildkite.com/v2/organizations/${ORG_NAME}/pipelines/${PIPELINE_NAME}/builds/${build_id}"
  
response=$(curl -H "Authorization: Bearer $API_TOKEN" "$build_url")
