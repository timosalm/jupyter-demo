# Demo for a Jupyter Hub Kubernetes enviornment

Demo to demonstrate GPU access from JupyterHub within Kubernetes clusters to provide software development environments for machine learning researchers.

## Prerequisities
- Kubernetes cluster with GPU access ([docs for VKS](https://techdocs.broadcom.com/us/en/vmware-cis/private-ai/foundation-with-nvidia/5-2/private-ai-foundation-5-2.html))

## Basic Setup
Based on online OSS Bitnami catalog, change container image to relocated TAC artifact if available.

Installation
```
kubectl create ns jupyter
helm install jupyter oci://registry-1.docker.io/bitnamicharts/jupyterhub -f jupyter-basic-values.yaml --set global.security.allowInsecureImages=true -n jupyter
```
Get url and user credentials to open Jupyter Hub in the browser
```
SERVICE_IP=$(kubectl get svc --namespace jupyter jupyter-jupyterhub-proxy-public --template "{{ range (index .status.loadBalancer.ingress 0) }}{{ . }}{{ end }}")
echo "JupyterHub URL: http://$SERVICE_IP/"

echo Admin user: user
echo Password: $(kubectl get secret --namespace jupyter jupyter-jupyterhub-hub -o jsonpath="{.data['values\.yaml']}" | base64 -d | awk -F: '/password/ {gsub(/[ \t]+/, "", $2);print $2}')
```

Upgrades
```
helm uninstall jupyter -n jupyter
kubectl delete pvc data-jupyter-postgresql-0
helm install jupyter oci://registry-1.docker.io/bitnamicharts/jupyterhub -f jupyter-values.yaml --set global.security.allowInsecureImages=true -n jupyter
```

**The writeable user dir in JupyterHub is at: /opt/bitnami/jupyterhub-singleuser**

##



NVIDIA NGC Setup
https://techdocs.broadcom.com/us/en/vmware-cis/private-ai/foundation-with-nvidia/5-2/private-ai-foundation-5-2/deploying-private-ai-foundation-with-nvidia/enable-a-private-harbor-registry-in-paif.html

Sharing access to your Jupyter server
https://jupyterhub.readthedocs.io/en/latest/tutorial/sharing.html