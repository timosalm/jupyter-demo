FROM bitnami/jupyter-base-notebook:5.3.0

USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends git && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

RUN conda install -y -c conda-forge \
        jupyterlab=4.4.2 \
        jupyter_server=2.16.0 \
        jupyterlab-git \
        jupyterlab-pullrequests \
    && conda install -y -c pytorch -c nvidia \
        pytorch=2.4.0 \
        torchvision=0.19.0 \
        torchaudio=2.4.0 \
        pytorch-cuda=12.1 \
    && conda clean -ya

USER 1001
