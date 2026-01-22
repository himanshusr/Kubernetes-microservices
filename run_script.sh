#!/bin/bash
minikube start
kubectl apply -f redis-pvc.yml
kubectl apply -f redis-deployment.yml
kubectl apply -f redis-service.yml
kubectl create configmap mongo-config --from-file=./MongoDB/init-db.js
kubectl apply -f mongo-pvc.yml
kubectl apply -f mongo-deployment.yml
kubectl apply -f mongo-service.yml
eval $(minikube docker-env)
docker build -t quote ./QuoteService
kubectl apply -f quote-deployment.yml
kubectl apply -f quote-service.yml
docker build -t apigateway ./ApiGateway
kubectl apply -f apigateway-deployment.yml
kubectl apply -f apigateway-service.yml
docker build -t nginx-frontend ./FrontendApplication
kubectl create configmap nginx-config --from-file=nginx.conf=./FrontendApplication/vhost.conf
kubectl apply -f nginx-deployment.yml
kubectl apply -f nginx-service.yml
eval $(minikube docker-env --unset)
# minikube service nginx-service --url
