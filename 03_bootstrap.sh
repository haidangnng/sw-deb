#!/bin/bash

# Check if IP address is provided
if [ -z "$1" ]; then
    echo "Usage: ./bootstrap.sh <CONTROL_PLANE_IP>"
    exit 1
fi

# Assign the first argument to CONTROL_PLANE_IP
CONTROL_PLANE_IP=$1

echo "Setting TALOSCONFIG environment variable..."
export TALOSCONFIG="_out/talosconfig"

echo "Configuring Talos endpoint and node for control plane..."
talosctl config endpoint $CONTROL_PLANE_IP
if [ $? -ne 0 ]; then
    echo "Failed to configure Talos endpoint. Exiting."
    exit 1
fi

talosctl config node $CONTROL_PLANE_IP
if [ $? -ne 0 ]; then
    echo "Failed to configure Talos node. Exiting."
    exit 1
fi

echo "Configuring Talos with specified TALOSCONFIG..."
talosctl --talosconfig $TALOSCONFIG config endpoint $CONTROL_PLANE_IP
if [ $? -ne 0 ]; then
    echo "Failed to configure Talos endpoint with TALOSCONFIG. Exiting."
    exit 1
fi

talosctl --talosconfig $TALOSCONFIG config node $CONTROL_PLANE_IP
if [ $? -ne 0 ]; then
    echo "Failed to configure Talos node with TALOSCONFIG. Exiting."
    exit 1
fi

echo "Bootstrapping the Talos cluster..."
talosctl --talosconfig $TALOSCONFIG bootstrap
if [ $? -ne 0 ]; then
    echo "Failed to bootstrap the Talos cluster. Exiting."
    exit 1
fi

echo "Generating kubeconfig..."
talosctl --talosconfig $TALOSCONFIG kubeconfig .
if [ $? -ne 0 ]; then
    echo "Failed to generate kubeconfig. Exiting."
    exit 1
fi

echo "Bootstrap process complete."
