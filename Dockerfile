# Ubuntu Docker file for Julia JuWebv1
# Version:v0.4.7

FROM ubuntu:16.04

MAINTAINER Luciano Melo <lucdms@gmail.com>

RUN apt-get update \
    && apt-get upgrade -y -o Dpkg::Options::="--force-confdef" -o DPkg::Options::="--force-confold" \
    && apt-get install -y \
    git \
    man-db \
    libc6 \
    libc6-dev \
    build-essential \
    wget \
    curl \
    file \
    vim \
    screen \
    tmux \
    unzip \
    pkg-config \
    cmake \
    gfortran \
    gettext \
    libreadline-dev \
    libncurses-dev \
    libpcre3-dev \
    #libgnutls28 \
    libzmq3-dev \
    #libzmq3 \
    python \
    python-yaml \
    python-m2crypto \
    python-crypto \
    msgpack-python \
    python-dev \
    python-setuptools \
    supervisor \
    python-jinja2 \
    python-requests \
    python-isodate \
    python-git \
    python-pip \
    && apt-get clean

RUN pip install --upgrade pyzmq PyDrive google-api-python-client jsonpointer jsonschema tornado sphinx pygments nose readline mistune invoke

#RUN pip install 'notebook==4.2'

# Install julia 0.4
RUN mkdir -p /opt/julia-0.4.7 && \
    curl -s -L https://julialang.s3.amazonaws.com/bin/linux/x64/0.4/julia-0.4.7-linux-x86_64.tar.gz | tar -C /opt/julia-0.4.7 -x -z --strip-components=1 -f -
RUN ln -fs /opt/julia-0.4.7 /opt/julia-0.4

# Make v0.4.7 default julia
RUN ln -fs /opt/julia-0.4.7 /opt/julia

RUN echo "PATH=\"/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/opt/julia/bin\"" > /etc/environment && \
    echo "export PATH" >> /etc/environment && \
    echo "source /etc/environment" >> /root/.bashrc

RUN /opt/julia/bin/julia -e 'Pkg.add("HttpServer")'
RUN /opt/julia/bin/julia -e 'Pkg.add("Mustache")'
RUN /opt/julia/bin/julia -e 'Pkg.add("Requests")'
RUN /opt/julia/bin/julia -e 'Pkg.add("SQLite")'
RUN /opt/julia/bin/julia -e 'Pkg.add("JSON")'
RUN /opt/julia/bin/julia -e 'Pkg.add("ImageView")'
RUN /opt/julia/bin/julia -e 'Pkg.add("QuartzImageIO")'
RUN /opt/julia/bin/julia -e 'Pkg.add("ImageMagick")'
RUN /opt/julia/bin/julia -e 'Pkg.clone("https://github.com/lucdms/JuWeb.jl.git")'

#RUN /opt/julia/bin/julia -e 'push!(LOAD_PATH, Base.LOAD_CACHE_PATH[1])'
#RUN /opt/julia/bin/julia -e 'using JuWeb'

ENTRYPOINT /opt/julia/bin/julia -e 'push!(LOAD_PATH, Base.LOAD_CACHE_PATH[1])'  #/bin/bash




