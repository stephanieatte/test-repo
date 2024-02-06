#!/bin/bash
set -euo pipefail

# Export environment variables
export fruit="apple"
export flower="rose"


entrypointd:
  01-install-pre-exit-hook: |
    #!/bin/bash
    set -euo pipefail
    echo "#!/bin/bash\nset -euo pipefail\ndocker images" > /var/buildkite/hooks/pre-exit
    chmod +x /var/buildkite/hooks/pre-exit
