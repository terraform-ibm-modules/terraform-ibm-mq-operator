#!/usr/bin/env bash

set -eE

KUBECONFIG=""
DEBUGFILE="/tmp/get_mq_queue_manager_web_url.log"
if [[ -e "${DEBUGFILE}" ]]; then
    rm -f "${DEBUGFILE}"
fi

# jq reads from stdin
function parse_input() {
  eval "$(jq -r '@sh "export KUBECONFIG=\(.KUBECONFIG) MQQUEUEMANAGERNAME=\(.MQQUEUEMANAGERNAME) MQQUEUEMANAGERNAMESPACE=\(.MQQUEUEMANAGERNAMESPACE)"')"
}

parse_input

if [[ -z "${KUBECONFIG}" ]] || [[ -z "${MQQUEUEMANAGERNAME}" ]] || [[ -z "${MQQUEUEMANAGERNAMESPACE}" ]]; then
    echo "[ERROR] one or more input parameter is empty" >> "${DEBUGFILE}"
    echo "[ERROR] one or more input parameter is empty" >&2
    MQQUEUEMANAGERROUTE="ERROR"
else
    # shellcheck disable=SC2129
    echo "[INFO] using KUBECONFIG ${KUBECONFIG}" >> "${DEBUGFILE}"
    # shellcheck disable=SC2129
    echo "[INFO] using MQQUEUEMANAGERNAME ${MQQUEUEMANAGERNAME}" >> "${DEBUGFILE}"
    # shellcheck disable=SC2129
    echo "[INFO] using MQQUEUEMANAGERNAMESPACE ${MQQUEUEMANAGERNAMESPACE}" >> "${DEBUGFILE}"

    MQQUEUEMANAGERROUTE="$(oc get routes "${MQQUEUEMANAGERNAME}-ibm-mq-web" -n "${MQQUEUEMANAGERNAMESPACE}" --no-headers | awk '{print $2}')"

    if [[ -z "${MQQUEUEMANAGERROUTE}" ]]; then
        echo "[ERROR] Error retrieving sample app url from ${APPNAMESPACE}" >> "${DEBUGFILE}"
        MQQUEUEMANAGERROUTE="NOTFOUND"
    fi
fi

echo -n '{"mq_queue_manager_web_url":"'"${MQQUEUEMANAGERROUTE}"'"}'
