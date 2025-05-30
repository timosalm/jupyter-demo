# Demo for a Jupyter Hub Kubernetes enviornment

Demo to demonstrate GPU access from JupyterHub within Kubernetes clusters to provide software development environments for machine learning researchers.

## Prerequisities
- Kubernetes cluster with GPU access ([docs for VKS](https://techdocs.broadcom.com/us/en/vmware-cis/private-ai/foundation-with-nvidia/5-2/private-ai-foundation-5-2.html))

## Basic Setup
Based on online OSS Bitnami catalog, change container image to relocated TAC artifact if available.

### Installation
```
kubectl create ns jupyter
helm install jupyter oci://registry-1.docker.io/bitnamicharts/jupyterhub -f jupyter-basic-values.yaml --set global.security.allowInsecureImages=true -n jupyter
```
### Get url and user credentials to open Jupyter Hub in the browser
```
SERVICE_IP=$(kubectl get svc --namespace jupyter jupyter-jupyterhub-proxy-public --template "{{ range (index .status.loadBalancer.ingress 0) }}{{ . }}{{ end }}")
echo "JupyterHub URL: http://$SERVICE_IP/"

echo Admin user: user
echo Password: $(kubectl get secret --namespace jupyter jupyter-jupyterhub-hub -o jsonpath="{.data['values\.yaml']}" | base64 -d | awk -F: '/password/ {gsub(/[ \t]+/, "", $2);print $2}')
```

### Validate that GPUs are available in a Python Notebook or Console
Navigate to the writeable user dir in JupyterHub `/opt/bitnami/jupyterhub-singleuser`
```
!pip install torch
import torch
torch.cuda.is_available()
```

### Upgrades
```
helm uninstall jupyter -n jupyter
kubectl delete pvc data-jupyter-postgresql-0
helm install jupyter oci://registry-1.docker.io/bitnamicharts/jupyterhub -f jupyter-values.yaml --set global.security.allowInsecureImages=true -n jupyter
```

## Custom "jupyter-base-notebook" image
Sample [GitHub Actions pipeline](pipeline.github/workflows/jupyter-custom-image-build.yml) that builds a custom "jupyter-base-notebook" image with additional libraries and JupyterHub extensions based on the [jupyter.Dockerfile](jupyter.Dockerfile).

After the custom image is build and pushed to a registry, it can be configured in the Helm Chart values file, see [jupyter-advanced-custom-image-values.yaml](jupyter-advanced-custom-image-values.yaml).

```
helm install jupyter oci://registry-1.docker.io/bitnamicharts/jupyterhub -f jupyter-advanced-custom-image-values.yaml --set global.security.allowInsecureImages=true -n jupyter
```

## Add SSO and Ingress
After configuring a client at a SSO provider, you can configure it for JupyterHub in the Helm Chart values file, see [jupyter-advanced-values.yaml](jupyter-advanced-sso-values.yaml).

Here is the relevant configuration for the SSO provider. The rest of the `hub.configuration` value is the default configuration which is unfortunately not customizable via Helm Chart values.
```
hub:
  adminUser: timo@example.com
  containerSecurityContext: ...
  extraEnvVarsSecret: jupyterhub-oauth-secret
  configuration: |
    Chart:
      Name: {{ .Chart.Name }}
      Version: {{ .Chart.Version }}
    Release:
      Name: {{ .Release.Name }}
      Namespace: {{ .Release.Namespace }}
      Service: {{ .Release.Service }}
    hub:
      config:
        Authenticator:
          admin_users:
          - {{ .Values.hub.adminUser }}
        GenericOAuthenticator:
          login_service: SSO
          authorize_url: https://authorization-server.main.emea.end2end.link/oauth2/authorize
          token_url: https://authorization-server.main.emea.end2end.link/oauth2/token
          userdata_method: GET
          userdata_params:
            state: state
          userdata_url: https://authorization-server.main.emea.end2end.link/userinfo
          username_key: email
          scope:
          - openid
          - email
          - profile
        JupyterHub:
          authenticator_class: oauthenticator.generic.GenericOAuthenticator
```

The relevant configuration for the Ingress is configured with the `proxy.ingress` configurations. Here are templatest for necessary secrets [kubernetes/jupyter-secret-template.yaml](kubernetes/jupyter-secret-template.yaml),[kubernetes/jupyter-tls-secret-template.yaml](kubernetes/jupyter-tls-secret-template.yaml).

```
helm install jupyter oci://registry-1.docker.io/bitnamicharts/jupyterhub -f jupyter-advanced-values.yaml --set global.security.allowInsecureImages=true -n jupyter
```
## Additional links
- Sharing access to your Jupyter server https://jupyterhub.readthedocs.io/en/latest/tutorial/sharing.html