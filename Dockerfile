# FROM ubuntu:18.04
FROM nvidia/cuda:10.2-cudnn7-devel-ubuntu18.04

LABEL maintainer="Andrey Kuehlkamp <akuehlka@nd.edu>"
LABEL description="🐳 Docker environment for PyTorch-Geometric GPU Accelerated Machine Learning"
LABEL url="https://github.com/akuehlka/docker-pytorch"

RUN apt-get update -qq \
  && apt-get install -y apt-utils \
  && apt-get upgrade -y \
  #
  # python
  # && apt-get install -y python3-pip python3-tk \
  && apt-get install -y sudo curl git \
      build-essential \
      clang libpython-dev libblocksruntime-dev \
      libpython3.6 libxml2 \
  #
  # cleanup
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

ENV LANG=C.UTF-8 \
    SHELL=/bin/bash \
    NB_USER=mluser \
    NB_UID=1000 \
    NB_GID=100 \
    HOME=/home/mluser 

ADD fix-permissions /usr/bin/fix-permissions

RUN \
  #
  # create user
  groupadd $NB_USER && useradd -d /home/$NB_USER -ms /bin/bash -g $NB_GID -G sudo,video -p $NB_USER $NB_USER \
  && chmod g+w /etc/passwd /etc/group \
  && chown -R $NB_USER:$NB_USER /usr/local \
  #
  # create data dirs
  && mkdir -p /data/tensorboard_logdir /data/input /data/output \
  && chown -R $NB_USER:$NB_USER /data

WORKDIR /home/$NB_USER

COPY resources/setup-jupyter.sh .
COPY resources/ptpython-config.py .

# Miniconda
RUN \
  curl -L https://repo.continuum.io/miniconda/Miniconda3-4.6.14-Linux-x86_64.sh -o miniconda.sh \
  && bash miniconda.sh -b -p /usr/local/miniconda \
  && rm -f miniconda.sh \
  && echo 'export PATH="/usr/local/miniconda/bin:$PATH"' >> $HOME/.bashrc 

RUN /bin/bash -c "\
  export PATH='/usr/local/miniconda/bin:$PATH' \
  && echo 'installing for $NB_USER ($NB_GID) $HOME' \
  #
  && conda update -n base conda \
  #
  "

RUN /bin/bash -c "\
  export PATH='/usr/local/miniconda/bin:$PATH' \
  && conda install -n base numpy==1.19.2 \
  && conda install -n base -c pytorch pytorch==1.7.1 cudatoolkit=10.2 torchvision\
  #
  "

RUN /bin/bash -c "\
  export PATH='/usr/local/miniconda/bin:$PATH' \
  && conda install -n base jupyterlab ipywidgets black \
  && conda install -n base -c conda-forge scipy pandas jupyter_contrib_nbextensions nbdime \
  && conda install -n base -c conda-forge scikit-learn scikit-image \
  && conda install -n base -c matplotlib seaborn \
  "

RUN /bin/bash -c "\
  export PATH='/usr/local/miniconda/bin:$PATH' \
  && conda install -n base pip \
  && conda run -n base /bin/bash -c ' \
    pip install \
    --find-links https://pytorch-geometric.com/whl/torch-1.7.0+cu102.html \
    torch-scatter \
    torch-sparse \
    torch-cluster \
    torch-spline-conv \
    torch-geometric \
  ' \
  && conda run -n base /bin/bash -c ' \
    pip install \
    jupyterlab_code_formatter \
  '"


# COPY resources/conda_environment.yml .
# COPY resources/pytorch-geometric-requirements.txt .

# # RUN /bin/bash -c "\
# #   export PATH='/usr/local/miniconda/bin:$PATH' \
# #   && conda env update -n base -f conda_environment.yml \
# #   "
  
RUN /bin/bash -c "\
  export PATH='/usr/local/miniconda/bin:$PATH' \
  && /bin/bash -c '${HOME}/setup-jupyter.sh' \
  && echo '** cleaning caches...' \
  && conda clean --all -y \
  && rm -rf /home/${NB_USER}/.cache/pip \
  && echo '** cleaning caches done.' \
  #
  && rm -f setup-jupyter.sh \
  && mkdir ${HOME}/.ptpython && mv ${HOME}/ptpython-config.py ${HOME}/.ptpython/config.py \
  #
  && chown -R $NB_USER:$NB_USER $HOME \
  && chown -R $NB_USER:$NB_USER /usr/local/miniconda \
  "

USER $NB_USER

COPY resources/jupyter_notebook_config.py ${HOME}/.jupyter/

EXPOSE 8888

CMD ["/usr/local/miniconda/bin/jupyter", "lab", "--ip", "0.0.0.0", "--no-browser", "--allow-root", "--NotebookApp.token=''", "--NotebookApp.notebook_dir='/code'"]
# CMD ["/bin/bash"]
