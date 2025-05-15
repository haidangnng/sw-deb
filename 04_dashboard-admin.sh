#!/bin/bash

# Check if kubeconfig file exists
if [ ! -f "./kubeconfig" ]; then
    echo "Error: kubeconfig file not found in the current directory."
    exit 1
fi

echo "Adding Kubernetes Dashboard Helm repository..."
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
if [ $? -ne 0 ]; then
    echo "Failed to add Helm repository. Exiting."
    exit 1
fi

echo "Updating Helm repositories..."
helm repo update
if [ $? -ne 0 ]; then
    echo "Failed to update Helm repositories. Exiting."
    exit 1
fi

echo "Installing or upgrading Kubernetes Dashboard..."
helm upgrade --install kubernetes-dashboard kubernetes-dashboard/kubernetes-dashboard \
  --create-namespace --namespace kubernetes-dashboard --kubeconfig='./kubeconfig'
if [ $? -ne 0 ]; then
    echo "Failed to install or upgrade Kubernetes Dashboard. Exiting."
    exit 1
fi

echo "Applying cluster account configuration..."
kubectl --kubeconfig='./kubeconfig' apply -f dashboard/cluster-account.yaml
if [ $? -ne 0 ]; then
    echo "Failed to apply cluster account configuration. Exiting."
    exit 1
fi

echo "Kubernetes Dashboard setup complete."
