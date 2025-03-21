
#!/bin/bash

set -euo pipefail

if [ "$BUILDKITE_RETRY_COUNT" -ne 0 ]; then
          cat <<- YAML | buildkite-agent pipeline upload 
            steps:
               - label: "Merge Step Retry"
                 command: "echo merge"
                 depends_on: "step-1"
                 allow_dependency_failure: true
          YAML
fi
