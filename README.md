# Prerequisite
- Virtualization Programs (VMWare, VirtualBox) 
- [Talosctl](https://www.talos.dev/v1.10/introduction/quickstart/)
- [Kubectl](https://kubernetes.io/docs/reference/kubectl/)
- [Helm](https://helm.sh/docs/intro/install/)
# Talos Cluster Configuration 

1. Create a Virtual Machine for controller node base on [Talos Docs](https://www.talos.dev/v1.10/talos-guides/install/local-platforms/virtualbox/)
2. Run `01_controller-setup.sh` script with the controller node IP:
```bash
./01_controller-setup.sh <CONTROL_PLANE_IP>
```
# Add Worker nodes
1. Create a Virtual Machine for worker node base on [Talos Docs](https://www.talos.dev/v1.10/talos-guides/install/local-platforms/virtualbox/)
2. Run `02_worker-setup.sh` script with worker node IP:
```bash
./02_worker-setup.sh <WORKER_NODE_IP>
```
3. Repeat for 3 more worker nodes (in total of 4)

# Bootstrapping the cluster
Run `03_bootstrap.sh` script with worker node IP:
```bash
./03_bootstrap.sh <CONTROLLER_PLANE_IP>
```
# Installing K8s Dashboard and Add Admin user
1. Run `04_dashboard-admin.sh` script with worker node IP:
```bash
./04_dashboard-admin.sh <CONTROLLER_PLANE_IP>
```
2. Access the dashboard using:
```bash
./kubectl --kubeconfig='./kubeconfig' -n kubernetes-dashboard create token admin-user
./kubectl --kubeconfig='./kubeconfig' -n kubernetes-dashboard port-forward svc/kubernetes-dashboard-kong-proxy 8443:443 --address 0.0.0.0
```
# Deploy containers

## Create namespace
```bash
kubectl --kubeconfig='./kubeconfig' create namespace questionlair-db
kubectl --kubeconfig='./kubeconfig' create namespace questionlair-fe
kubectl --kubeconfig='./kubeconfig' create namespace questionlair-be
kubectl --kubeconfig='./kubeconfig' create namespace questionlair-llm
```

You can change the namespace to anything, but you have to change them in the deployment files accordingly.

Update the namespace and the node you want to deploy to in the deployment files.

## Metallb (Load Balancer)
Run `05_metallb.sh`

## Database (Postgresql, Minio)
1. Update the `db_config.yaml` file to your postgres and minio secret
2. Run `06_db-deploy.sh`

## Backend
1. Update the `api_config.yaml` file to your postgres connection and minio secret
2. Run `07_api-deploy.sh`

## Web
Run `08_web-deploy.sh`

## LLM 
1. Update `llm_config.yaml` to your `OPEN_API_KEY`
2. Run `09_llm-deploy.sh`
