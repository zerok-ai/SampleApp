#!/bin/bash

REPLICA_COUNT=1
SERVICE_NAME=service1
TARGETS_VALUE=''
LATENCY_MIN_VALUE=0
LATENCY_MAX_VALUE=1
NAMESPACE=default

echo ""
while getopts "h:r:t:n:k:l:s:" arg; do
  case $arg in
    h)
      echo "usage" 
      echo "h - This help"
      echo "r - replica count"
      echo "t - Targets"
      echo "s - Service Name"
      echo "k - min latency"
      echo "l - max latenct"
      echo "n - namespace"
      ;;
    s)
      SERVICE_NAME=$OPTARG
      if [ -z "$SERVICE_NAME" ]
      then
        echo "Service Name can not be empty"
        exit 1
      fi
      echo "Name : $SERVICE_NAME"
      ;;
    k)
      LATENCY_MIN_VALUE="${OPTARG:-$LATENCY_MIN_VALUE}"
      echo "Min Latency : $LATENCY_MIN_VALUE"
      ;;
    l)
      LATENCY_MAX_VALUE="${OPTARG:-$LATENCY_MAX_VALUE}"
      echo "Max Latency : $LATENCY_MAX_VALUE"
      ;;
    t)
      TARGETS_VALUE="${OPTARG:-$TARGETS_VALUE}"
      echo "Target : $TARGETS_VALUE"
      ;;
    r)
      REPLICA_COUNT="${OPTARG:-$REPLICA_COUNT}"
      echo "Replicas : $REPLICA_COUNT"
      ;;
    n)
      NAMESPACE="${OPTARG:-$NAMESPACE}"
      echo "Namespace : $NAMESPACE"
      ;;
  esac
done

function createPatch {
    patchItem=$1

    cp $patchItem-patch-template.yaml $patchItem-patch.yaml

    sed -i "" "s/REPLICA_COUNT/$REPLICA_COUNT/g" $patchItem-patch.yaml
    sed -i "" "s/SERVICE_NAME/$SERVICE_NAME/g" $patchItem-patch.yaml
    sed -i "" "s/TARGETS_VALUE/$TARGETS_VALUE/g" $patchItem-patch.yaml
    sed -i "" "s/LATENCY_MIN_VALUE/$LATENCY_MIN_VALUE/g" $patchItem-patch.yaml
    sed -i "" "s/LATENCY_MAX_VALUE/$LATENCY_MAX_VALUE/g" $patchItem-patch.yaml
    sed -i "" "s/NAMESPACE/$NAMESPACE/g" $patchItem-patch.yaml
}

createPatch deployment
createPatch service

kubectl apply -k ./
