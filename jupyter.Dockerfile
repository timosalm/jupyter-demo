FROM bitnami/jupyter-base-notebook

USER root
RUN apt update
RUN apt install git -y
RUN pip install torch
RUN conda install --quiet --yes \
    pytorch torchvision torchaudio pytorch-cuda=12.1 -c pytorch -c nvidia && \
    conda clean --all -f -y
RUN conda install -c conda-forge jupyterlab-git
RUN conda install -c conda-forge jupyterlab-pullrequests
USER 1001

conda install pytorch torchvision torchaudio pytorch-cuda=12.1 -c pytorch -c nvidia