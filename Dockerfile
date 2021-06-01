FROM pytorch/pytorch:1.8.0-cuda11.1-cudnn8-runtime

LABEL maintainer="Andrey Kuehlkamp <akuehlka@nd.edu>"
LABEL description="🐳 Docker environment for PyTorch-Geometric GPU Accelerated Machine Learning"
LABEL url="https://github.com/akuehlka/docker-pytorch"

RUN apt-get update -qq \
  && apt-get install -y apt-utils \
  && apt-get upgrade -y \
  && apt-get install -y sudo curl git 

RUN /opt/conda/bin/conda run -n base \
  pip install --upgrade pip \
  && pip install \
  ipywidgets \
  black \
  jupyter_contrib_nbextensions \
  seaborn \
  jupyterlab

RUN /opt/conda/bin/conda run -n base \
  pip install \
  torch-scatter \
  torch-sparse \
  torch-cluster \
  torch-geometric \
  -f https://pytorch-geometric.com/whl/torch-1.8.0+cu111.html

COPY resources/setup-jupyter.sh /root/

RUN /bin/bash -c "/root/setup-jupyter.sh" \
  && echo '** cleaning caches...' \
  && rm -rf /root/.cache/pip \
  && conda clean -a \
  && echo '** cleaning caches done.' \
  && rm -f setup-jupyter.sh 

COPY resources/jupyter_notebook_config.py /root/.jupyter/

EXPOSE 8888

CMD ["/opt/conda/bin/jupyter", "lab", "--ip", "0.0.0.0", "--no-browser", "--allow-root", "--NotebookApp.token=''", "--NotebookApp.notebook_dir='/code'"]
