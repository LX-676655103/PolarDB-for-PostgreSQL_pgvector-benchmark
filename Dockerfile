FROM registry.cn-hangzhou.aliyuncs.com/polardb_pg/polardb_pg_devel:ubuntu24.04

ARG POLAR_REPO="https://github.com/ApsaraDB/PolarDB-for-PostgreSQL.git"
ARG POLAR_BRANCH="POLARDB_15_STABLE"
ARG POLAR_DIR="/app/PolarDB-for-PostgreSQL"

RUN sudo apt-get update
RUN sudo apt-get install -y python3-pip python3-requests python3-venv

# 复制代码到镜像仓库
COPY --chown=postgres:postgres run.sh /app/run.sh

# 指定工作目录
WORKDIR /app

RUN mkdir -p ${POLAR_DIR} && cd ${POLAR_DIR} && git clone -b ${POLAR_BRANCH} --single-branch --depth 1 ${POLAR_REPO} .
RUN cd ${POLAR_DIR} && rm -rf .git

# 创建Python虚拟环境并安装依赖
RUN python3 -m venv /app/pg-venv && \
    /app/pg-venv/bin/pip3 config set global.index-url https://mirrors.aliyun.com/pypi/simple/ && \
    /app/pg-venv/bin/pip3 install --upgrade pip && \
    /app/pg-venv/bin/pip3 install psycopg2 numpy h5py

# 容器启动运行命令
CMD ["bash", "run.sh"]