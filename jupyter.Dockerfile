FROM docker.io/bitnami/jupyter-base-notebook:5.3.0-debian-12-r4

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends git && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN conda install -y -c conda-forge jupyterlab-git \
    && conda clean -ya

USER 1001
