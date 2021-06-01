#!/usr/bin/env bash
set -euo pipefail

jupyter serverextension enable --py jupyterlab --sys-prefix \
  && jupyter nbextension enable --py widgetsnbextension --sys-prefix

# jupyter serverextension enable --py jupyterlab_code_formatter --sys-prefix
