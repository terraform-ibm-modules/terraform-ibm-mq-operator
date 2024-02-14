#!/bin/bash

## Needed to delete resources (CSVs and installPlans) created by the OLM outside of the Terraform scope

operator_names=( "ibm-mq" )

echo "Fetching and deleting CSVs and installPlans for IBM MQ Operator"

for i in "${operator_names[@]}"
do
    CSV=$(kubectl get subscription "$i" -o jsonpath="{$.status.installedCSV}" -n "$1")

    if [ -n "$CSV" ]
    then
        echo "Deleting CSV ${CSV}"
        kubectl delete csv "$CSV" -n "$1"
    fi

    IP=$(kubectl get installPlan -n "$1" | grep "${i}" | awk '{print $1}')

    if [ -n "$IP" ]
    then
        echo "Deleting installPlan ${IP}"
        kubectl delete installPlan "$IP" -n "$1"
    fi
done
