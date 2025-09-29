FROM registry.cn-hangzhou.aliyuncs.com/polardb_pg/polardb_pg_devel:ubuntu24.04

RUN sudo apt-get update
RUN sudo apt-get install -y python3-pip python3-requests python3-venv

# 复制代码到镜像仓库
COPY run.sh /app/run.sh

# 指定工作目录
WORKDIR /app

# 容器启动运行命令
CMD ["bash", "run.sh"]