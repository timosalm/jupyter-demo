FROM bitnami/jupyterhub:latest

USER root
RUN pip install jupyterlab-git
USER 1001