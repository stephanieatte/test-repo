#!/bin/bash
set -x

export RETRY=$BUILDKITE_RETRY_COUNT
echo "hi $RETRY"

 if [ "$BUILDKITE_RETRY_COUNT" -eq 0 ]; then
          echo "Then there is a retrial"
          buildkite-agent pipeline upload .buildkite/pipeline.yml
        fi
