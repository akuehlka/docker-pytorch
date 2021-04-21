#!/usr/bin/env bash
set -euo pipefail

jupyter serverextension enable --py jupyterlab --sys-prefix \
  && jupyter nbextension enable --py widgetsnbextension --sys-prefix \
  && jupyter contrib nbextension install --sys-prefix \
  && jupyter labextension install @jupyter-widgets/jupyterlab-manager \
  && jupyter labextension install @oriolmirosa/jupyterlab_materialdarker \
  && jupyter labextension install @ryantam626/jupyterlab_code_formatter \
  && jupyter labextension install @aquirdturtle/collapsible_headings

jupyter serverextension enable --py jupyterlab_code_formatter --sys-prefix
