FROM bitnami/jupyter-base-notebook

USER root
RUN pip install jupyterlab-git
USER 1001