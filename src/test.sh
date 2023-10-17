#!/bin/bash

(
  set -x

  env | sort

  uname -a
)

echo "hi"
buildkite-agent meta-data set "con-group" "deploy"
