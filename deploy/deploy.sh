#!/bin/bash

kubectl delete   deployment storefront-deployment

sleep 5
# Run the minikube docker environment setup
eval $(minikube docker-env)

# Remove the old Docker image
docker rmi storefront:latest

# Build the new Docker image
docker build -t storefront:latest ../

# Apply the Kubernetes deployment
kubectl apply -f deployment.yaml

echo "Deployment completed successfully."
