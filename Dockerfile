FROM gw000/debian-cuda
MAINTAINER bosr <romain.bossart@fastmail.com>

RUN apt-get update -qq \
  && apt-get upgrade -y \
  && apt-get install -y python3-pip python3-tk \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

RUN /usr/bin/pip3 install http://download.pytorch.org/whl/cu80/torch-0.2.0.post3-cp35-cp35m-manylinux1_x86_64.whl \
  && /usr/bin/pip3 install torchvision \
  && /usr/bin/pip3 install matplotlib ipython \
  && /usr/bin/pip3 install plotnine plydata \
  && /usr/bin/pip3 install notebook yapf

EXPOSE 8888

WORKDIR "/code"

CMD ["/usr/bin/jupyter", "notebook", "--ip", "0.0.0.0", "--no-browser", "--allow-root"]
