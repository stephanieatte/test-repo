#!/bin/bash
set -euo pipefail

NAME=("cat" "dog" "mouse" "frog")
IFS=', ' read -r -a array <<< "$NAME"
echo "${array[0]}"
