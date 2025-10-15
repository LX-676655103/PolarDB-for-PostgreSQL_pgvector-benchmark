FROM registry.cn-hangzhou.aliyuncs.com/polardb_pg/polardb_pg_devel:ubuntu24.04

# ==================== 配置参数 ====================

ARG POLAR_REPO="https://github.com/ApsaraDB/PolarDB-for-PostgreSQL.git"
ARG POLAR_BRANCH="POLARDB_15_STABLE"

# 控制是否显示编译日志, 如果设置为任意非空值, 则输出日志到 stdout, 否则隐藏日志
ENV SHOW_BUILD_LOG=

# 注意：不能同时配置 HNSW 索引和 IVF 索引

# HNSW 索引参数配置, 如果其中一个参数为空, 则不构建 HNSW 索引
ENV HNSW_M=16
ENV HNSW_EF_CONSTRUCTION=64
# HNSW 查询参数
ENV ef_search_values="10 20 30 50 80 100 120 140 160 180 200"

# IVF 索引参数配置, 如果参数为空, 则不构建 IVF 索引
ENV IVF_LISTS=
# IVF 查询参数
ENV probes_values="1 2 5 10 15 20 30 40 50 64 100"

# ==================== 镜像构建 ====================

RUN sudo apt-get update
RUN sudo apt-get install -y python3-pip python3-requests python3-venv

# 复制代码到镜像仓库
COPY --chown=postgres:postgres run.sh /app/run.sh

# 指定工作目录
WORKDIR /app

ARG POLAR_DIR="/app/PolarDB-for-PostgreSQL"
RUN mkdir -p ${POLAR_DIR} && cd ${POLAR_DIR} && git clone -b ${POLAR_BRANCH} --single-branch --depth 1 ${POLAR_REPO} .
RUN cd ${POLAR_DIR} && rm -rf .git

# 创建Python虚拟环境并安装依赖
RUN python3 -m venv /app/pg-venv && \
    /app/pg-venv/bin/pip3 config set global.index-url https://mirrors.aliyun.com/pypi/simple/ && \
    /app/pg-venv/bin/pip3 install --upgrade pip && \
    /app/pg-venv/bin/pip3 install psycopg2 numpy h5py

# 容器启动运行命令
CMD ["bash", "/tcdata/run.sh"]