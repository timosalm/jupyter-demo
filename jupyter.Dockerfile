FROM bitnami/jupyter-base-notebook

USER root
RUN apt update
RUN apt install git -y
RUN pip install --upgrade "jupyter_server>=2.0"
RUN conda install --quiet --yes \
    'pytorch' && \
    conda clean --all -f -y
RUN conda install -c conda-forge jupyterlab-git
RUN conda install -c conda-forge jupyterlab-pullrequests
USER 1001