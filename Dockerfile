
# Base
FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive

# Ubuntu packages + Numpy
RUN apt-get update \
     && apt-get install -y --no-install-recommends \
        apt-utils \
        build-essential \
        g++  \
        git  \
        curl  \
        cmake \
        zlib1g-dev \
        libjpeg-dev \
        xvfb \
        libav-tools \
        xorg-dev \
        libboost-all-dev \
        libsdl2-dev \
        swig \
        python3  \
        python3-dev  \
        python3-future  \
        python3-pip  \
        python3-setuptools  \
        python3-wheel  \
        python3-tk \
        libopenblas-base  \
        libatlas-dev  \
        cython3  \
     && apt-get clean \
     && rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN python3 -m pip install --upgrade pip

# Install Python packages - Step 1
COPY requirements_1.txt /tmp/
RUN python3 -m pip install -r /tmp/requirements_1.txt

# Install Python packages - Step 2 (OpenAI Gym)
COPY requirements_2.txt /tmp/
RUN python3 -m pip install -r /tmp/requirements_2.txt

# Add directory
RUN mkdir /ds 

# Enable jupyter widgets
RUN jupyter nbextension enable --py --sys-prefix widgetsnbextension

ENV DEBIAN_FRONTEND teletype

# Jupyter notebook with virtual frame buffer for rendering
CMD cd /ds \
    && xvfb-run -s "-screen 0 1400x900x24" \
    /usr/local/bin/jupyter notebook \
    --port=8888 --ip=0.0.0.0 --allow-root 


