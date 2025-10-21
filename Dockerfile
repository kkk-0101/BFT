# =====================================================
# Dumbo-2 / Bolt-Dumbo Transformer Docker 环境
# 基于 Ubuntu 20.04 LTS
# =====================================================

FROM ubuntu:20.04

LABEL maintainer="Your Name <your_email@example.com>"
LABEL description="PoC environment for Dumbo-2 / Bolt-Dumbo Transformer benchmark"

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Shanghai

# ========== 安装基础依赖 ==========
RUN apt-get update && apt-get install -y \
    wget make gcc g++ bison flex libgmp-dev libmpc-dev python3 python3-dev python3-pip libssl-dev tzdata \
    && ln -fs /usr/share/zoneinfo/$TZ /etc/localtime && dpkg-reconfigure -f noninteractive tzdata \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# ========== 安装 PBC ==========
WORKDIR /opt
RUN wget https://crypto.stanford.edu/pbc/files/pbc-0.5.14.tar.gz && \
    tar -xvf pbc-0.5.14.tar.gz && cd pbc-0.5.14 && \
    ./configure && make && make install && \
    ldconfig /usr/local/lib && \
    cd .. && rm -rf pbc-0.5.14 pbc-0.5.14.tar.gz

ENV LIBRARY_PATH=/usr/local/lib:$LIBRARY_PATH
ENV LD_LIBRARY_PATH=/usr/local/lib:$LD_LIBRARY_PATH

# ========== 复制 charm 源码并编译 ==========
WORKDIR /opt/charm
COPY charm /opt/charm
RUN ./configure.sh && make && make install

# ========== 安装 Python 包 ==========
RUN python3 -m pip install --upgrade pip -i https://pypi.tuna.tsinghua.edu.cn/simple && \
    pip3 install gevent setuptools numpy ecdsa pysocks gmpy2==2.1.2 zfec==1.5.7.4 gipc pycryptodome coincurve \
    -i https://pypi.tuna.tsinghua.edu.cn/simple
    
# ========== 复制 BFT 源码 ==========
WORKDIR /opt/BFT
COPY . /opt/BFT

