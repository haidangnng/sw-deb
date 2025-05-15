#!/bin/bash

# Check if kubeconfig file exists
if [ ! -f "./kubeconfig" ]; then
    echo "Error: kubeconfig file not found in the current directory."
    exit 1
fi

echo "Starting database deployment on Talos Kubernetes cluster..."

# Step 1: Apply database configuration
echo "Applying database configuration..."
kubectl --kubeconfig='./kubeconfig' apply -f deployment/db/db_config.yaml
if [ $? -ne 0 ]; then
    echo "Error: Failed to apply database configuration."
    exit 1
fi

# Step 2: Apply persistent volume
echo "Applying persistent volume..."
kubectl --kubeconfig='./kubeconfig' apply -f deployment/db/db_persistant_volumne.yaml
if [ $? -ne 0 ]; then
    echo "Error: Failed to apply persistent volume."
    exit 1
fi

# Step 3: Apply persistent volume claim
echo "Applying persistent volume claim..."
kubectl --kubeconfig='./kubeconfig' apply -f deployment/db/db_persistant_volumne_claim.yaml
if [ $? -ne 0 ]; then
    echo "Error: Failed to apply persistent volume claim."
    exit 1
fi

# Step 4: Apply database deployment
echo "Deploying database..."
kubectl --kubeconfig='./kubeconfig' apply -f deployment/db/db_deployment.yaml
if [ $? -ne 0 ]; then
    echo "Error: Failed to deploy database."
    exit 1
fi

# Step 5: Apply database service
echo "Creating database service..."
kubectl --kubeconfig='./kubeconfig' apply -f deployment/db/db_service.yaml
if [ $? -ne 0 ]; then
    echo "Error: Failed to create database service."
    exit 1
fi

echo "Database deployment completed successfully on Talos Kubernetes cluster."
