FROM bitnami/jupyter-base-notebook

USER root
RUN apt update
RUN apt install git -y
RUN conda install pytorch==2.4.0 torchvision==0.19.0 torchaudio==2.4.0 pytorch-cuda=12.1 -c pytorch -c nvidia && \
    conda clean -ya && \
    conda install -c "nvidia/label/cuda-12.1.0" cuda-nvcc && conda clean -ya
RUN conda install -c conda-forge jupyterlab-git
RUN conda install -c conda-forge jupyterlab-pullrequests
USER 1001

conda install pytorch torchvision torchaudio pytorch-cuda=12.1 -c pytorch -c nvidia