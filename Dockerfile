FROM pytorch/pytorch:1.8.0-cuda11.1-cudnn8-runtime

LABEL maintainer="Andrey Kuehlkamp <akuehlka@nd.edu>"
LABEL description="🐳 Docker environment for PyTorch-Geometric GPU Accelerated Machine Learning"
LABEL url="https://github.com/akuehlka/docker-pytorch"

RUN apt-get update -qq \
  && apt-get install -y apt-utils \
  && apt-get upgrade -y \
  && apt-get install -y sudo curl git 

RUN /opt/conda/bin/conda run -n base \
  pip install torch-scatter \
    torch-sparse \
    torch-cluster \
    torch-spline-conv \
    torch-geometric \
    -f https://data.pyg.org/whl/torch-1.8.0+cu111.html

WORKDIR /code

CMD ["/bin/bash"]
