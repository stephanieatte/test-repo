#!/bin/bash

(
  set -x

  env | sort

  uname -a
)

echo "hi"
echo $BUILDKITE_RETRY_COUNT
//if [ "${pipeline_length} -ne 0 ]
