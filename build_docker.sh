#!/bin/bash

# 构建镜像
docker build -t bft .

# 保存为tar文件
docker save -o bft.tar bft

# 运行容器（交互式进入）
docker run -it --name bft-container bft
