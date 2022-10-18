#!/bin/bash

# Enabling istio on default namespace
kubectl label namespace default "istio-injection=enabled" --overwrite

# performing setup of services
cd kustomize
./deploy.sh -n service4 -r 1
./deploy.sh -n service3 -r 1 -t service4.default.svc.cluster.local
./deploy.sh -n service2 -r 1 -k 0 -l 10
./deploy.sh -n service1 -r 1 -t service2.default.svc.cluster.local,service3.default.svc.cluster.local

# setting up load test deployment to hit service1
kubectl create namespace external
kubectl apply -f loadrun-deployment.yaml
