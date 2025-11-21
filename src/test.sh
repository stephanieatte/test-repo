#!/bin/bash
set -euo pipefail

# Define your metadata as key=value pairs in an array
metadata=(
  "KEY1=value1"
  "KEY2=value2"
  "KEY3=value3"
)

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo "Starting metadata upload..."

# Track success/failure
success_count=0
fail_count=0

# Loop through and set each one
for kv in "${metadata[@]}"; do
  # Validate format
  if [[ "$kv" != *=* ]]; then
    echo -e "${YELLOW}Warning: Skipping invalid entry (missing '='): $kv${NC}" >&2
    ((fail_count++))
    continue
  fi
  
  # Extract key and value
  key="${kv%%=*}"
  value="${kv#*=}"
  
  # Validate key is not empty
  if [[ -z "$key" ]]; then
    echo -e "${YELLOW}Warning: Skipping entry with empty key${NC}" >&2
    ((fail_count++))
    continue
  fi
  
  # Set metadata with error handling
  echo "Setting metadata: $key=$value"
  if buildkite-agent meta-data set "$key" "$value"; then
    echo -e "${GREEN}✓ Successfully set: $key${NC}"
    ((success_count++))
  else
    echo -e "${RED}✗ Failed to set: $key${NC}" >&2
    ((fail_count++))
  fi
done

# Summary
echo ""
echo "================================"
echo "Summary: $success_count succeeded, $fail_count failed"
echo "================================"

# Exit with error if any failed
if [[ $fail_count -gt 0 ]]; then
  exit 1
fi

echo "All metadata set successfully!"
