#!/bin/bash

# Define variables
ORG_NAME="atte-test-org-1"
PIPELINE_NAME="first"
API_TOKEN="bkua_63fa9fec9d119f650e8b00a2b5f0c5c20036cc65"

build_id="your_build_id"
cooldown_seconds=3600  # 1 hour cooldown

# Function to check the status of the build
check_build_status() {
    build_url="https://api.buildkite.com/v2/organizations/$ORG_NAME/pipelines/$PIPELINE_NAME/builds/$build_id"
    build_status=$(curl -s -H "Authorization: Bearer ${API_TOKEN}" "${build_url}" | jq -r '.state')
    echo "The state is $build_status"
}

build_status=$(check_build_status)
if [ "${build_status}" == "failed" ]; then
    echo "Build failed. Retrying after an hour..."
elif [ "${build_status}" == "passed" ]; then
    echo "Build succeeded!"
else
    echo "Build status: ${build_status}."
fi

