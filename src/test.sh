#!/bin/bash

(
  set -x


)

#!/bin/bash

DEPLOYMENT_ENV="stage"

buildkite-agent pipeline upload <<YAML
steps:
  - label: "start gate"
    command: echo "---> starting concurrency gate"
    concurrency_group: "gate/${DEPLOYMENT_ENV}"
YAML

exit -1
