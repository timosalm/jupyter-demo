FROM bitnami/jupyter-base-notebook:5.3.0

USER root
RUN apt update
RUN apt install git -y
RUN pip install --upgrade pip \
    && pip install --no-cache-dir \
        jupyterlab \
        jupyter_server
RUN conda install pytorch==2.4.0 torchvision==0.19.0 torchaudio==2.4.0 pytorch-cuda=12.1 -c pytorch -c nvidia && \
    conda clean -ya && \
    conda install -c "nvidia/label/cuda-12.1.0" cuda-nvcc && conda clean -ya
RUN conda install -c conda-forge jupyterlab-git
RUN conda install -c conda-forge jupyterlab-pullrequests
USER 1001