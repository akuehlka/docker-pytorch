# {PyTorch 1.6.0 & friends} + CUDA 10.2 + cuDNN 7.6.2

## Purpose

Get a Jupyterlab up and running in seconds for interactive exploration (hence the data wrangling and visualization packages).


## Included packages

Included packages (see `Dockerfile` for the full list):

  - miniconda3 w/ python 3.7
  - PyTorch 1.6.0
  - torchvision, torchtext, torchaudio
  - # gpytorch, botorch, ax-platform
  - allennlp, transformers
  - torch-geometric
  - syft (temporarily removed)
  - fastai
  - tf 1.14, tensorboard

and the usual suspects:

  - pandas, scipy
  - scikit-learn, scikit-image
  - xgboost,
  - jupyterlab
  - ...


## Usage

If you do not have `nvidia-docker` installed:

    docker run --rm \
        $(ls /dev/nvidia* | xargs -I{} echo '--device={}') \
        $(ls /usr/lib/x86_64-linux-gnu/{libcuda,libnvidia}* | xargs -I{} echo '-v {}:{}:ro') \
        -e CUDA_VISIBLE_DEVICES=0 \
        --ipc=host \
        -v code:/code
        bosr/pytorch

or using `nvidia-docker`

    nvidia-docker run --rm --ipc=host \
        -v ${PWD}/code:/code \
        -p 8888:8888 \
        bosr/pytorch
            /usr/local/bin/jupyter lab --no-browser --ip 0.0.0.0 --allow-root

Note: on debian, installing `nvidia-docker` is currently painful, so what I recommend is defining an executable script in `/usr/local/bin/nvidia-docker`:

    #! /usr/bin/env bash

    /usr/bin/docker $1 \
        $(ls /dev/nvidia* | xargs -I{} echo '--device={}') \
        $(ls /usr/lib/x86_64-linux-gnu/{libcuda,libnvidia}* | xargs -I{} echo '-v {}:{}:ro') \
        -e CUDA_VISIBLE_DEVICES=0 \
        ${@:2}

and run it as shown above.


## Details

Miniconda3 is installed in `/usr/local/miniconda`. When the container is started, a Jupyterlab is launched and exposed on the standard port 8888.

As a personal preference, I save the model coefficients and dump the logs in `/output`.

The reason for the `--ipc=host` option is given [here](https://github.com/pytorch/pytorch/issues/1158#issuecomment-290771026).
