#!/bin/bash

REPLICA_COUNT=1
SERVICE_NAME=service1
TARGETS_VALUE=''
LATENCY_MIN_VALUE=0
LATENCY_MAX_VALUE=1
NAMESPACE=default

echo ""
while getopts "h:r:n:f:s:i:" arg; do
  case $arg in
    h)
      echo "usage" 
      echo "h - This help"
      echo "n - Namespace"
      echo "s - Service Name"
      echo "r - Replica count"
      echo "f - Configuration file"
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
    i)
      DOCKER_IMAGE=$OPTARG
      if [ -z "$DOCKER_IMAGE" ]
      then
        echo "Image can not be empty"
        exit 1
      fi
      echo "Image : $DOCKER_IMAGE"
      ;;
    r)
      REPLICA_COUNT="${OPTARG:-$REPLICA_COUNT}"
      echo "Replicas : $REPLICA_COUNT"
      ;;
    n)
      NAMESPACE="${OPTARG:-$NAMESPACE}"
      echo "Namespace : $NAMESPACE"
      ;;
    f)
      CONF_FILE=$OPTARG
      if [ -z "$CONF_FILE" ]
      then
        echo "Service config is required"
        exit 1
      fi
      echo "Configs : $CONF_FILE"
      ;;
  esac
done

function createPatch {
    patchItem=$1

    cp $patchItem-patch-template.yaml $patchItem-patch.yaml

    sed -i "" "s/REPLICA_COUNT/$REPLICA_COUNT/g" $patchItem-patch.yaml
    sed -i "" "s/SERVICE_NAME/$SERVICE_NAME/g" $patchItem-patch.yaml
    sed -i "" "s/NAMESPACE/$NAMESPACE/g" $patchItem-patch.yaml
    sed -i "" "s|DOCKER_IMAGE|$DOCKER_IMAGE|g" $patchItem-patch.yaml

}

# handle CONF_FILE.
kubectl delete configmap -n $NAMESPACE $SERVICE_NAME-config
kubectl create configmap -n $NAMESPACE $SERVICE_NAME-config --from-file=$CONF_FILE

createPatch deployment
createPatch service

kubectl apply -k ./
