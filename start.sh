#!/bin/sh

# This project using:
#   Minikube v1.13.0
#   Kubernetes/KubeCtl v1.16.6
#   Helm v3.3.1

minikube start --cpus 2 --memory 4096 --disk-size 30g

helm repo add stable https://kubernetes-charts.storage.googleapis.com/ 

helm repo update

minikube status
echo "$(minikube version) is now ready"