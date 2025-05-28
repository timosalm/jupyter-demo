FROM bitnami/jupyter-base-notebook

USER root
RUN sudo apt install git-all
RUN pip install jupyterlab-git
USER 1001