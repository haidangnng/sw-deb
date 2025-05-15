#!/bin/bash

# Check if IP address is provided
if [ -z "$1" ]; then
    echo "Usage: ./controller-setup.sh <IP>"
    exit 1
fi

# Assign the first argument to CONTROL_PLANE_IP
CONTROL_PLANE_IP=$1

echo "Creating output directory '_out'..."
mkdir -p _out
if [ $? -ne 0 ]; then
    echo "Failed to create directory '_out'. Exiting."
    exit 1
fi

echo "Exporting CONTROL_PLANE_IP as $CONTROL_PLANE_IP..."
export CONTROL_PLANE_IP

echo "Generating Talos config..."
talosctl gen config talos-vbox-cluster https://$CONTROL_PLANE_IP:6443 --output-dir _out
if [ $? -ne 0 ]; then
    echo "Failed to generate Talos config. Exiting."
    exit 1
fi

echo "Applying Talos config..."
talosctl apply-config --insecure --nodes $CONTROL_PLANE_IP --file _out/controlplane.yaml
if [ $? -ne 0 ]; then
    echo "Failed to apply Talos config. Exiting."
    exit 1
fi

echo "Controller setup complete."
