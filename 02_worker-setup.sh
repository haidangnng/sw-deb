#!/bin/bash

# Check if IP address is provided
if [ -z "$1" ]; then
    echo "Usage: ./worker-setup.sh <IP>"
    exit 1
fi

# Assign the first argument to WORKER_IP
WORKER_IP=$1

echo "Exporting WORKER_IP as $WORKER_IP..."
export WORKER_IP

echo "Applying Talos worker config..."
talosctl apply-config --insecure --nodes $WORKER_IP --file _out/worker.yaml
if [ $? -ne 0 ]; then
    echo "Failed to apply Talos worker config. Exiting."
    exit 1
fi

echo "Worker setup complete."
