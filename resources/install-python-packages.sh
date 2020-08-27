#!/usr/bin/env bash
set -euo pipefail


# xgboost & tpot currently require py36
conda install -y -c conda-forge \
	nodejs \
	jupyterlab ipywidgets \
	\
	jupyter_contrib_nbextensions \
	nbdime black \
	\
	tensorboard \
	hyperopt \
	\
	# xgboost \
	# tpot \

jupyter serverextension enable --py jupyterlab --sys-prefix \
  && jupyter nbextension enable --py widgetsnbextension --sys-prefix \
  && jupyter contrib nbextension install --sys-prefix \
  && jupyter labextension install @jupyter-widgets/jupyterlab-manager \
  && jupyter labextension install @oriolmirosa/jupyterlab_materialdarker \
  && jupyter labextension install @ryantam626/jupyterlab_code_formatter \
  && jupyter labextension install @aquirdturtle/collapsible_headings

# conda install -y -c conda-forge jupyterlab_code_formatter
pip install jupyterlab_code_formatter
jupyter serverextension enable --py jupyterlab_code_formatter --sys-prefix



conda install -y \
	cython numpy scipy \
	pandas \
	scikit-learn scikit-image \
	nltk \
	\
	matplotlib seaborn \


python -c "import nltk; nltk.download('stopwords')"

# torch
conda install -y -c pytorch \
	pytorch==1.6.0 cudatoolkit=10.2 ignite \
	torchvision torchtext torchaudio \

conda install -y -c pytorch -c gpytorch botorch
pip install ax-platform

# SwiftAI
git clone https://github.com/google/swift-jupyter
cd swift-jupyter
python register.py --sys-prefix --swift-python-use-conda --use-conda-shared-libs --swift-toolchain $HOME/s4tf
cd ..

# git clone https://github.com/fastai/swiftai

# fastai
conda install -y -c fastai \
	fastai

#
pip install \
	git+https://github.com/huggingface/transformers \
	mosestokenizer \
	sacremoses \
	spacy \
	pyro-ppl \
	allennlp \
	# flair \
	# fairseq \
	# syft \
	# torch-scatter torch-sparse torch-cluster torch-spline-conv torch-geometric \

pip install plydata \
	tqdm \
	wandb \
	\
	python-language-server \
	faker babel

# git clone https://github.com/facebookresearch/ParlAI.git ${HOME}/ParlAI \
# 	&& cd ${HOME}/ParlAI && python setup.py develop \
# 	&& cd ${HOME}

