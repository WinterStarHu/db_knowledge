# 行存压缩系统函数

- compress\_buffer\_stat\_info\(\)

描述：查看pca buffer统计信息。

返回值类型：record

**表 1**  compress\_buffer\_stat\_info参数说明

参数类型 参数名 输出参数 ctrl_cnt bigint pca_page_ctrl_t结构体。
输出参数 main_cnt bigint 各个分区所有的main lru链的总数。
输出参数 free_cnt bigint 各分区上free lru链的总数。
输出参数 recycle_times bigint buffer进行lru的淘汰次数。

- compress\_ratio\_info\(file\_path text\)

描述：查看文件压缩率信息。

返回值类型：record

**表 2**  compress\_ratio\_info参数说明

参数类型 参数名 输入参数 file_path text 相对文件路径。
输出参数 path text 文件相对路径。
输出参数 is_compress boolean 是否为压缩文件。
输出参数 file_count bigint 包含段文件个数。
输出参数 logic_size bigint 逻辑大小，单位是byte。
输出参数 physic_size bigint 实际物理大小，单位byte。
输出参数 compress_ratio text 文件的压缩率。

- compress\_statistic\_info\(file\_path text，step smallint\)

描述：统计文件压缩后的离散度信息。

返回值类型：record

**表 3**  compress\_statistic\_info参数说明

参数类型 参数名 输入参数 file_path text 文件相对路径。
输入参数 step smallint 采样统计步长。
输出参数 path text 文件相对路径。
输出参数 extent_count bigint extent的数量。
输出参数 dispersion_count bigint 含有离散chunk的页面个数。
输出参数 void_count bigint 还有chunk空洞的页面个数。

- compress\_address\_header\(oid regclass, seg\_id bigint\)

描述：查看文件压缩页面的管理信息。

返回值类型：record

**表 4**  compress\_address\_header参数说明

参数类型 参数名 输入参数 oid regclass 文件所属表的reloid。
输入参数 seg_id bigint segment文件的序号。
输出参数 extent bigint extent的编号。
输出参数 nblocks bigint extent里的page个数。
输出参数 alocated_chunks integer ext中分配了配多少个chunk。
输出参数 chunk_size integer chunksize大小，单位是byte。
输出参数 algorithm bigint 使用的压缩算法。

- compress\_address\_details\(oid regclass, seg\_id bigint\)

描述：页面chunk使用的详细信息。

返回值类型：record

**表 5**  compress\_address\_details参数说明

参数类型 参数名 输入参数 oid regclass 文件所属表的reloid。
输入参数 seg_id bigint segment文件的序号。
输出参数 extent bigint extent的编号。
输出参数 extent_block_number bigint 该extent内的页面编号，0~127。
输出参数 block_number bigint 整体页面编号。
输出参数 alocated_chunks integer 该页面用了多少个chunk。
输出参数 nchunks integer 该页面实际用了多少个chunk，不大于alocated_chunks。
输出参数 chunknos integer 用的chunks的编号，从1开始。
