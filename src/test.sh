#!/bin/bash
set -x
echo "hi"

 if [ "$BUILDKITE_RETRY_COUNT" -ne 0 ]; then
          echo "Then there is a retrial"
          buidkite-agent pipeline upload .buildkite/pipeline.yml
        fi
