#!/bin/bash

# Check if kubeconfig file exists
if [ ! -f "./kubeconfig" ]; then
    echo "Error: kubeconfig file not found in the current directory."
    exit 1
fi

echo "Starting API deployment on Talos Kubernetes cluster..."

# Step 1: Apply API configuration
echo "Applying API configuration..."
kubectl --kubeconfig='./kubeconfig' apply -f deployment/api/api_config.yaml
if [ $? -ne 0 ]; then
    echo "Error: Failed to apply API configuration."
    exit 1
fi

# Step 2: Deploy the API
echo "Deploying API..."
kubectl --kubeconfig='./kubeconfig' apply -f deployment/api/api_deployment.yaml
if [ $? -ne 0 ]; then
    echo "Error: Failed to deploy API."
    exit 1
fi

# Step 3: Create the API service
echo "Creating API service..."
kubectl --kubeconfig='./kubeconfig' apply -f deployment/api/api_service.yaml
if [ $? -ne 0 ]; then
    echo "Error: Failed to create API service."
    exit 1
fi

echo "API deployment completed successfully on Talos Kubernetes cluster."
