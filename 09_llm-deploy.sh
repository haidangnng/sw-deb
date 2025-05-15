#!/bin/bash

# Check if kubeconfig file exists
if [ ! -f "./kubeconfig" ]; then
    echo "Error: kubeconfig file not found in the current directory."
    exit 1
fi

echo "Starting LLM application deployment on Talos Kubernetes cluster..."

# Step 1: Apply LLM configuration
echo "Applying LLM configuration..."
kubectl --kubeconfig='./kubeconfig' apply -f deployment/llm/llm_config.yaml
if [ $? -ne 0 ]; then
    echo "Error: Failed to apply LLM configuration."
    exit 1
fi

# Step 2: Deploy the LLM application
echo "Deploying LLM application..."
kubectl --kubeconfig='./kubeconfig' apply -f deployment/llm/llm_deployment.yaml
if [ $? -ne 0 ]; then
    echo "Error: Failed to deploy LLM application."
    exit 1
fi

# Step 3: Create the LLM service
echo "Creating LLM service..."
kubectl --kubeconfig='./kubeconfig' apply -f deployment/llm/llm_service.yaml
if [ $? -ne 0 ]; then
    echo "Error: Failed to create LLM service."
    exit 1
fi

echo "LLM application deployment completed successfully on Talos Kubernetes cluster."
