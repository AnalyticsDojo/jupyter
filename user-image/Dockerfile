# Copyright (c) Jupyter Development Team.
# Distributed under the terms of the Modified BSD License.
# Updated from https://github.com/jupyter/docker-stacks/blob/master/datascience-notebook/Dockerfile

FROM jupyter/scipy-notebook:27ba57364579

MAINTAINER Jupyter Project <jupyter@googlegroups.com>

USER root

# R pre-requisites
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    fonts-dejavu \
    gfortran \
    nano \
    gcc && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

USER $NB_USER

#Jason Added
RUN conda install -c conda-forge --quiet --yes \
    'fastparquet=0.1*' \
    'nbpresent=3.0*' \
    'ipython_unittest=0.2*' \
    'ruamel.yaml=0.15*'
RUN conda install --quiet --yes  \
    'pandas-datareader=0.5*' \
    'beautifulsoup4=4.6*' \
    'shapely=1.5*'

# R packages including IRKernel which gets installed globally.
RUN conda config --system --add channels r && \
    conda install --quiet --yes \
    'rpy2=2.8*' \
    'r-base=3.3.2' \
    'r-irkernel=0.7*' \
    'r-plyr=1.8*' \
    'r-devtools=1.12*' \
    'r-tidyverse=1.0*' \
    'r-shiny=0.14*' \
    'r-rmarkdown=1.2*' \
    'r-forecast=7.3*' \
    'r-rsqlite=1.1*' \
    'r-reshape2=1.4*' \
    'r-nycflights13=0.2*' \
    'r-caret=6.0*' \
    'r-rcurl=1.95*' \
    'r-crayon=1.3*' \
    'r-randomforest=4.6*' && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR
#add twitter
RUN /opt/conda/bin/pip install twitter==1.17.1
RUN conda install -c conda-forge --quiet --yes \
    'plotly=2.0*'
ARG JUPYTERHUB_VERSION=0.7.2
RUN pip install --no-cache jupyterhub==$JUPYTERHUB_VERSION

USER root

# Spark dependencies
ENV APACHE_SPARK_VERSION 2.2.0
ENV HADOOP_VERSION 2.7

RUN apt-get -y update && \
    apt-get install --no-install-recommends -y openjdk-8-jre-headless ca-certificates-java && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*
RUN cd /tmp && \
        wget -q http://d3kbcqa49mib13.cloudfront.net/spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz && \
        echo "7a186a2a007b2dfd880571f7214a7d329c972510a460a8bdbef9f7f2a891019343c020f74b496a61e5aa42bc9e9a79cc99defe5cb3bf8b6f49c07e01b259bc6b *spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz" | sha512sum -c - && \
        tar xzf spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz -C /usr/local && \
        rm spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION}.tgz
RUN cd /usr/local && ln -s spark-${APACHE_SPARK_VERSION}-bin-hadoop${HADOOP_VERSION} spark

# Mesos dependencies
RUN . /etc/os-release && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv E56151BF && \
    DISTRO=$ID && \
    CODENAME=$VERSION_CODENAME && \
    echo "deb http://repos.mesosphere.io/${DISTRO} ${CODENAME} main" > /etc/apt/sources.list.d/mesosphere.list && \
    apt-get -y update && \
    apt-get --no-install-recommends -y --force-yes install mesos=1.2\* && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Spark and Mesos config
ENV SPARK_HOME /usr/local/spark
ENV PYTHONPATH $SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.4-src.zip
ENV MESOS_NATIVE_LIBRARY /usr/local/lib/libmesos.so
ENV SPARK_OPTS --driver-java-options=-Xms1024M --driver-java-options=-Xmx4096M --driver-java-options=-Dlog4j.logLevel=info

RUN conda install --quiet --yes \
    'tensorflow=1.3*' \
    'keras=2.0*' && \
    conda clean -tipsy && \
    fix-permissions $CONDA_DIR
RUN conda install --yes --quiet -c  damianavila82 rise
RUN conda install --yes --quiet -c anaconda nltk
RUN conda install --yes --quiet -c anaconda gensim
RUN conda install --yes --quiet -c conda-forge bazel

#Add tensorboard
RUN /opt/conda/bin/pip install --pre jupyter-tensorboard
#    cmake \
#    zlib1g-dev \
#RUN pip install gym[all]
# Get the faster VNC driver
#RUN pip install go-vncdriver>=0.4.0
RUN pip install git+https://github.com/data-8/gitautosync
RUN jupyter serverextension enable --py nbgitpuller --sys-prefix


USER $NB_USER
