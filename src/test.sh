#!/bin/bash
set -x
echo "hi"

 if [ "$BUILDKITE_RETRY_COUNT" -ne 1 ]; then
          echo "Then there is a retrial"
        fi
