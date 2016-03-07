#!/bin/bash

. $(dirname ${BASH_SOURCE})/../util.sh

desc "Resize the RS and watch the service backends change"
run "kubectl --namespace=demos scale rs hostnames --replicas=1"
run "kubectl --namespace=demos scale rs hostnames --replicas=2"
