#!/bin/bash

# ==================== 配置参数 ====================

# POLAR_REPO="https://github.com/ApsaraDB/PolarDB-for-PostgreSQL.git"
# POLAR_BRANCH="POLARDB_15_STABLE"

# HNSW 索引参数配置, 如果其中一个参数为空, 则不构建 HNSW 索引
HNSW_M=16
HNSW_EF_CONSTRUCTION=64
# HNSW 查询参数
ef_search_values=(10 20 30 50 80 100 120 140 160 180 200)

# IVF 索引参数配置, 如果参数为空, 则不构建 IVF 索引
# IVF_LISTS=2000
IVF_LISTS=
# IVF 查询参数
probes_values=(1 2 5 10 15 20 30 40 50 64 100)

source /tcdata/run.sh