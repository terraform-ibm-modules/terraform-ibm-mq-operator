#!/bin/bash

set -e

namespace=$1
fail=false

# This script is designed to verify that IBM MQ operator is fully deployed through its deployment resource wlo-controller-manager

IBM_MQ_DEPLOYMENT_NAME="ibm-mq-operator"

# sleep 60 seconds initially to provide time for each deployment to get created
sleep 60

# Get list of deployments in control plane namespace
DEPLOYMENTS=()
while IFS='' read -r line; do DEPLOYMENTS+=("$line"); done < <(kubectl get deployment "${IBM_MQ_DEPLOYMENT_NAME}" -n "${namespace}" --no-headers | cut -f1 -d ' ')

# Wait for all deployments to come up - timeout after 5 mins
for dep in "${DEPLOYMENTS[@]}"; do
  if ! kubectl rollout status deployment "$dep" -n "${namespace}" --timeout 5m; then
    fail=true
  fi
done

# Fail with some debug prints if issues detected
if [ ${fail} == true ]; then
  echo "Problem detected. Printing some debug info.."
  set +e
  echo "Describe output of ibm-mq Subscription in ${namespace} namespace"
  kubectl describe Subscription ibm-mq -n "${namespace}"
  echo
  echo "List of ${IBM_MQ_DEPLOYMENT_NAME} deployments in ${namespace} namespace"
  kubectl get deployment "${IBM_MQ_DEPLOYMENT_NAME}" -n "${namespace}" -o wide
  echo
  echo "List of pods for ${IBM_MQ_DEPLOYMENT_NAME} deployment in ${namespace} namespace"
  kubectl get pods -n "${namespace}" -o wide
  IBMQPODS=$(kubectl get pods -n "${namespace}" --no-headers | cut -f1 -d ' ' | grep  "${IBM_MQ_DEPLOYMENT_NAME}")
  echo
  echo "Describe output of ${IBM_MQ_DEPLOYMENT_NAME} deployment pods in ${namespace} namespace"
  for pod in "${IBMQPODS[@]}"; do
    kubectl describe pod "${pod}" -n "${namespace}"
  done
  exit 1
fi
