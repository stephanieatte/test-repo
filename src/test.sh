#!/bin/bash
set -x
echo "hi"

 if [ "$BUILDKITE_RETRY_COUNT" -eq 0 ]; then
          echo "Then there is a retrial"
          buildkite-agent pipeline upload .buildkite/pipeline.yml
        fi
