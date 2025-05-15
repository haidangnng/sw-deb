#!/bin/bash

# Check if kubeconfig file exists
if [ ! -f "./kubeconfig" ]; then
    echo "Error: kubeconfig file not found in the current directory."
    exit 1
fi

echo "Starting web application deployment on Talos Kubernetes cluster..."

# Step 1: Deploy the web application
echo "Deploying web application..."
kubectl --kubeconfig='./kubeconfig' apply -f deployment/web/web_deployment.yaml
if [ $? -ne 0 ]; then
    echo "Error: Failed to deploy web application."
    exit 1
fi

# Step 2: Create the web service
echo "Creating web service..."
kubectl --kubeconfig='./kubeconfig' apply -f deployment/web/web_service.yaml
if [ $? -ne 0 ]; then
    echo "Error: Failed to create web service."
    exit 1
fi

echo "Web application deployment completed successfully on Talos Kubernetes cluster."
