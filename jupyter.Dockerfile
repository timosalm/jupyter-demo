FROM bitnami/jupyter-base-notebook

USER root
RUN apt update
RUN apt install git -y
RUN pip install --upgrade jupyter-server
RUN conda install --quiet --yes \
    'matplotlib-base' \
    'scipy' \
    'pytorch' && \
    conda clean --all -f -y
RUN conda install -c conda-forge jupyterlab-git
RUN conda install -c conda-forge jupyterlab-pullrequests
USER 1001