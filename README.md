# Demo for a Jupyter Hub Kubernetes enviornment

https://bitnami.com/stack/jupyterhub/helm 
https://jupyterhub.readthedocs.io/en/latest/tutorial/sharing.html

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
helm upgrade --install jupyter  oci://registry-1.docker.io/bitnamicharts/jupyterhub -f jupyter-values.yaml --set hub.password=$(kubectl get secret --namespace jupyter jupyter-jupyterhub-hub -o jsonpath="{.data['values\.yaml']}" | base64 -d | awk -F: '/password/ {gsub(/[ \t]+/, "", $2);print $2}') --set global.security.allowInsecureImages=true -n jupyter
```