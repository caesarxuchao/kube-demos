#!/bin/bash

. $(dirname ${BASH_SOURCE})/../util.sh

target="$1"

notFound=true
rsName=""
while [ "${notFound}" = true ]; do
  for ((i=0;i<=1;i++)); do
    rs=$(kubectl --namespace=demos get rs -o go-template="{{(index .items $i).metadata.name}}" 2>/dev/null)
    contains=$(kubectl --namespace=demos get rs "${rs}" -o go-template='{{.spec.template.spec.containers}}' 2>/dev/null | grep "${target}")
    if [ ! -z "${contains}" ]; then
      notFound=false
      rsName="$rs"
    fi
  done
done

trap "exit" INT
while true; do
  kubectl --namespace=demos get rs "${rsName}" 2>/dev/null | awk -v var="$target" '{if (NR==2) {print "Desired replicas of "var" ReplicaSet: " $2 " Running: " $3}}'
done
