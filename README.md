# Demo for a Jupyter Hub Kubernetes enviornment

https://bitnami.com/stack/jupyterhub/helm 
https://jupyterhub.readthedocs.io/en/latest/tutorial/sharing.html

helm install my-release oci://registry-1.docker.io/bitnamicharts/jupyterhub -f jupyter-values.yaml

export SERVICE_IP=$(kubectl get svc --namespace default my-release-jupyterhub-proxy-public --template "{{ range (in dex «status.loadBalancer.ingress e) }lff • I}ff end }}")
echo "JupyterHub URL: http://$SERVICE_IP/"

echo Admin user: user
echo Password: $(kubectl get secret --namespace default my-release-jupyterhub-hub -o jsonpath="{-data['values \-yaml
'1}" | base64 -d | awk -F: '/password/ {gsub(/[\t]+/, "*
', $2);print $2}')

WARNING: There are "resources" sections in the chart not set. Using "resourcesPreset" is not recommended for producti on. For production installations, please set the following values according to your workload needs:
- hub.resources
- imagePul.er. resources
- proxy.resources
- singleuser.resources