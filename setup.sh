#!/bin/bash

# Enabling istio on default namespace
kubectl label namespace default "istio-injection=enabled" --overwrite

# performing setup of services
cd kustomize
# ./deploy.sh -s service4 -r 1 -f ../service-configurations/service4-definition.yaml
./deploy.sh -s service1 -i "$1" -r 1 -f ../service-configurations/service1-definition.yaml
./deploy.sh -s service2 -i "$1" -r 1 -f ../service-configurations/service2-definition.yaml
./deploy.sh -s service3 -i "$1" -r 1 -f ../service-configurations/service3-definition.yaml

# setting up load test deployment to hit service1
# kubectl create namespace external
# kubectl apply -f loadrun-deployment.yaml

# kubectl rollout restart deploy

kubectl port-forward svc/service1 -n default 8080:80