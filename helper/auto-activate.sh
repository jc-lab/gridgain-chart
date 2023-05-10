#!/bin/bash

set -eu

IS_LAST_POD=$(hostname | grep -E ".-$((GRIDGAIN_REPLICAS - 1))$" >/dev/null && echo "y" || echo "n")
POD_IP=${POD_IP:-127.0.0.1}
GRIDGAIN_URL=${GRIDGAIN_URL:-http://${POD_IP}:8080}

echo "Hostname: $(hostname)"
echo "Is Last Pod: ${IS_LAST_POD}"
echo "Gridgain URL: ${GRIDGAIN_URL}"

_term() {
  echo "Caught exit signal!"
  exit 0
}

trap _term SIGTERM SIGINT

main_dummy() {
  while [ 1 ]; do
    sleep 1
  done
}

ignite_get_state() {
  set +e
  BODY=$(curl -sSLf ${GRIDGAIN_URL}/ignite?cmd=state)
  rc=$?
  [ $rc -eq 0 ] || (echo "NOT_READY" && return 0)
  echo "${BODY}" | jq -r '.response'
}

ignite_do_activate() {
  curl -sSLf ${GRIDGAIN_URL}/ignite?cmd=active
}

main_activator() {
  while [ 1 ]; do
    state=$(ignite_get_state)
    echo "Current State: ${state}"
    if [ "x${state}" == "xACTIVE" ]; then
      echo "Already activated"
      break
    elif [ "x${state}" == "xINACTIVE" ]; then
      echo "Inactive state. do activate!"
      ignite_do_activate
      break
    fi
    sleep 1
  done

  main_dummy
}

if [ "${IS_LAST_POD}" == "y" ]; then
  main_activator
else
  main_dummy
fi
