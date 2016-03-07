#!/bin/bash

. $(dirname ${BASH_SOURCE})/../util.sh

if kubectl --namespace=demos get rs hostnames >/dev/null 2>&1; then
    desc "Revisit our replica set"
    run "kubectl --namespace=demos get rs hostnames"
else
    desc "Run some pods under a replication set"
    run "cat $(relative ../replicasets/rs.yaml)"
    run "kubectl --namespace=demos create -f $(relative ../replicasets/rs.yaml)"
fi

desc "Create a service to front the replicaset"
    run "cat $(relative service.yaml)"
    run "kubectl --namespace=demos create -f $(relative service.yaml)"

desc "Have a look at the service"
run "kubectl --namespace=demos describe svc hostnames"

IP=$(kubectl --namespace=demos get svc hostnames \
    -o go-template='{{.spec.clusterIP}}')
desc "See what happens when you access the service's IP"
run "gcloud compute ssh --zone=us-central1-b $SSH_NODE --command '\\
    for i in \$(seq 1 10); do \\
        curl --connect-timeout 1 -s $IP && echo; \\
    done \\
    '"
run "gcloud compute ssh --zone=us-central1-b $SSH_NODE --command '\\
    for i in \$(seq 1 500); do \\
        curl --connect-timeout 1 -s $IP && echo; \\
    done | sort | uniq -c; \\
    '"

tmux new -d -s my-session \
    "$(dirname ${BASH_SOURCE})/split1_lhs.sh" \; \
    split-window -h -d "sleep 10; $(dirname $BASH_SOURCE)/split1_rhs.sh" \; \
    attach \;
