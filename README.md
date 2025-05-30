# Demo for a Jupyter Hub Kubernetes enviornment

https://bitnami.com/stack/jupyterhub/helm 


```
kubectl create ns jupyter
helm install jupyter oci://registry-1.docker.io/bitnamicharts/jupyterhub -f jupyter-values.yaml --set global.security.allowInsecureImages=true -n jupyter
```

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

Writeable user dir is at: /opt/bitnami/jupyterhub-singleuser

NVIDIA NGC Setup
https://techdocs.broadcom.com/us/en/vmware-cis/private-ai/foundation-with-nvidia/5-2/private-ai-foundation-5-2/deploying-private-ai-foundation-with-nvidia/enable-a-private-harbor-registry-in-paif.html

Sharing access to your Jupyter server
https://jupyterhub.readthedocs.io/en/latest/tutorial/sharing.html