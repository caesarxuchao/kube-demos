#!/bin/bash

. $(dirname ${BASH_SOURCE})/../util.sh

desc "Create a service that fronts any version of this demo"
run "cat $(relative svc.yaml)"
run "kubectl --namespace=demos create -f $(relative svc.yaml)"

desc "Deploy v1 of our app"
run "cat $(relative deployment.yaml)"
run "kubectl --namespace=demos create -f $(relative deployment.yaml)"

# The output of describe is too wide, uncomment the following lines if a describe is definitely needed. 
# desc "Check it"
# run "kubectl --namespace=demos describe deployment deployment-demo"

tmux new -d -s my-session \
    "sleep 10; $(dirname $BASH_SOURCE)/split1_top.sh" \; \
    split-window -v -p 66 "$(dirname ${BASH_SOURCE})/split1_middle.sh" \; \
    split-window -v "$(dirname ${BASH_SOURCE})/split1_bottom.sh v1" \; \
    split-window -h -d "$(dirname ${BASH_SOURCE})/split1_bottom.sh v2" \; \
    select-pane -t 0 \; \
    attach \;
