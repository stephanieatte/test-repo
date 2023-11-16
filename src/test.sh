#!/bin/bash

   set -euo pipefail

   # Set up a variable to hold the meta-data from your block step
   RELEASE_NAME="$(buildkite-agent meta-data get "release-name")"

   # Create a pipeline with your trigger step
   PIPELINE="steps:
     - trigger: \"deploy-pipeline\"
       label: \"Trigger deploy\"
       build:
         meta_data:
           release-name: $RELEASE_NAME
   "

   # Upload the new pipeline and add it to the current build
   echo "$PIPELINE" | buildkite-agent pipeline upload
