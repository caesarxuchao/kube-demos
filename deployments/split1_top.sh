#!/bin/bash

. $(dirname ${BASH_SOURCE})/../util.sh

desc "Update the deployment"
# First command in a window is running without user's confirm, so adding a padding.
run ""
run "cat $(relative deployment.yaml) | sed 's/ v1/ v2/g' | kubectl --namespace=demos apply -f- --validate=false"
run "kubectl --namespace=demos rollout undo deployment deployment-demo"
