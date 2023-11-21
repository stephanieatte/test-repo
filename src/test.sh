#!/bin/bash

   set -euo pipefail

   # Set up a variable to hold the meta-data from your block step
   RELEASE_PIPELINE_NAME="$(buildkite-agent meta-data get "trigger-name")"

   # Create a pipeline with your trigger step
   PIPELINE="steps:
     - trigger: \"$RELEASE_PIPELINE_NAME\"
       label: \"Trigger deploy\"
   "

   # Upload the new pipeline and add it to the current build
   echo "$PIPELINE" | buildkite-agent pipeline upload


DOCKERPW ="heyyaaa"
