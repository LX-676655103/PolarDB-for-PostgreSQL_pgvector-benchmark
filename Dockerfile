FROM registry.cn-hangzhou.aliyuncs.com/polardb_pg/polardb_pg_devel:ubuntu24.04

ARG POLAR_REPO="https://github.com/ApsaraDB/PolarDB-for-PostgreSQL.git"
ARG POLAR_BRANCH="POLARDB_15_STABLE"

RUN sudo apt-get update
RUN sudo apt-get install -y python3-pip python3-requests python3-venv

# 复制代码到镜像仓库
COPY --chown=postgres:postgres run.sh /app/run.sh

# 指定工作目录
WORKDIR /app

RUN cd /app && git clone -b ${POLAR_BRANCH} --single-branch ${POLAR_REPO}
RUN cd /app/PolarDB-for-PostgreSQL && rm -rf .git

# 容器启动运行命令
CMD ["bash", "run.sh"]