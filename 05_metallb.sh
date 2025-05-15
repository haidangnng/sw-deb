#!/bin/bash

# Check if kubeconfig file exists
if [ ! -f "./kubeconfig" ]; then
    echo "Error: kubeconfig file not found in the current directory."
    exit 1
fi

echo "Starting MetalLB deployment on Talos Kubernetes cluster..."

# Step 1: Apply MetalLB configuration
echo "Applying MetalLB configuration..."
kubectl --kubeconfig='./kubeconfig' apply -f deployment/metallb.yaml
if [ $? -ne 0 ]; then
    echo "Error: Failed to apply MetalLB configuration."
    exit 1
fi

echo "MetalLB deployment completed successfully on Talos Kubernetes cluster."
