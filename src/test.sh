#!/bin/bash
set -euo pipefail

NAME=$(buildkite-agent meta-data get release-stream)

IFS=', ' read -r -a array <<< "$NAME"
echo "${array[0]}"
