#!/bin/bash
set -e

declare -A metadata=(
  ["key1"]="value1"
  ["key2"]="value2"
  ["key3"]="value3"
)

for key in "${!metadata[@]}"; do
  buildkite-agent meta-data set "$key" "${metadata[$key]}"
done
