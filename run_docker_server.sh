#!/bin/bash
# run-on-server.sh - 服务器运行脚本

# 加载镜像
docker load -i /tmp/bft.tar

# 运行容器
docker run -it --name bft-container bft