#!/bin/bash

helpFunction()
{
   echo ""
   echo "Usage: $0 [apply|delete]"
   exit 1 # Exit script after printing help
}

while getopts "h" opt
do
   case "$opt" in
      h ) helpFunction ;; # Print helpFunction in case parameter is non-existent
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

if [ -z "$1" ] || [ [ "$1" != "apply" ] && [ "$1" != "delete" ] ]
then
   helpFunction
   exit 1;
fi

if [ "$1" == "delete" ]
then
   kubectl delete namespace viggo
   kubectl delete namespace jonwick
   exit 1;
fi

# Enabling istio on default namespace
kubectl label namespace default "istio-injection=enabled" --overwrite

# performing setup of services
kubectl create namespace jonwick
cd kustomize
./deploy.sh -s service4 -n jonwick -r 1
./deploy.sh -s service3 -n jonwick -r 1 -t service4.default.svc.cluster.local
./deploy.sh -s service2 -n jonwick -r 1 -k 0 -l 10
./deploy.sh -s service1 -n jonwick -r 1 -t service2.default.svc.cluster.local,service3.default.svc.cluster.local

# setting up load test deployment to hit service1
kubectl create namespace viggo
kubectl apply -f loadrun-deployment.yaml -n viggo
