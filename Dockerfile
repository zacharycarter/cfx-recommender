FROM ubuntu:16.04

RUN apt-get -y update
RUN apt-get install -y git libxml2 libxslt-dev libblas-dev liblapack-dev wget bzip2 gcc && rm -rf /var/lib/apt/lists/*

ENV PATH /opt/conda/bin:/opt/foxbots:$PATH

RUN echo 'export PATH=/opt/conda/bin:$PATH' > /etc/profile.d/conda.sh && \
    wget --quiet https://repo.continuum.io/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh

RUN pip install -U turicreate
RUN conda install -y jupyter requests lxml

ENV PYTHONUNBUFFERED=TRUE
ENV PYTHONDONTWRITEBYTECODE=TRUE

ADD . /opt/foxbots/
WORKDIR /opt

RUN git clone https://github.com/scottlittle/expand-cell-fullscreen
RUN cd expand-cell-fullscreen
RUN jupyter nbextension install expand-cell-fullscreen --sys-prefix --symlink
RUN jupyter nbextension enable expand-cell-fullscreen/main --sys-prefix

RUN cd foxbots