#!/bin/bash
set -e

# Define your metadata as key=value pairs in an array
metadata=(
  "KEY1=value1"
  "KEY2=value2"
  "KEY3=value3"
)

# Loop through and set each one
for kv in "${metadata[@]}"; do
  key="${kv%%=*}"       # extract key
  value="${kv#*=}"      # extract value
  echo "Setting metadata: $key=$value"
  buildkite-agent meta-data set "$key" "$value"
done
