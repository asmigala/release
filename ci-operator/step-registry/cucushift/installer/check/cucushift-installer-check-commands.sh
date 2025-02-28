#!/bin/bash

set -o nounset
set -o errexit
set -o pipefail

function run_command() {
    local CMD="$1"
    echo "Running command: ${CMD}"
    eval "${CMD}"
}

if [ -f "${SHARED_DIR}/kubeconfig" ] ; then
    export KUBECONFIG=${SHARED_DIR}/kubeconfig
fi

if [ -f "${SHARED_DIR}/proxy-conf.sh" ] ; then
    source "${SHARED_DIR}/proxy-conf.sh"
fi

set +e
run_command "oc get infrastructures.config.openshift.io cluster -oyaml"
run_command "oc get clusterversion/version"
run_command "oc get nodes -owide"
run_command "oc get clusteroperators"
run_command "oc get networks.config.openshift.io cluster -oyaml"
run_command "oc get networks.operator.openshift.io cluster -oyaml"
run_command "oc -n openshift-ingress-operator get ingresscontroller -oyaml"
set -e
