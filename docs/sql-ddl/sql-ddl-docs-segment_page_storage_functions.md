# 段页式存储函数

- local\_segment\_space\_info\(tablespacename TEXT, databasename TEXT\)

描述：输出为该表空间下所有ExtentGroup的使用信息。

返回值类型：

node_name 节点名称。
extent_size 该ExtentGroup的extent规格，单位是block数。
forknum Fork号。
total_blocks 物理文件总extent数目。
meta_data_blocks 表空间管理的metadata占用的block数，只包括space header、map page等，不包括segment head。
used_data_blocks 存数据占用的extent数目。包括segment head。
utilization 使用的block数占总block数的百分比。即(used_data_blocks+meta_data_block)/total_blocks。
high_water_mark 高水位线，被分配出去的extent，最大的物理页号。超过高水位线的block都没有被使用，可以被直接回收。

例如：

    ```
    select * from local_segment_space_info('pg_default', 'postgres');
         node_name     | extent_size | forknum | total_blocks | meta_data_blocks | used_data_blocks | utilization | high_water_mark
    -------------------+-------------+---------+--------------+------------------+------------------+-------------+-----------------
     dn_6001_6002_6003 |           1 |       0 |        16384 |             4157 |                1 |     .253784 |            4158
     dn_6001_6002_6003 |           8 |       0 |        16384 |             4157 |                8 |     .254211 |            4165
    (2 rows)
    ```

-  pg\_stat\_segment\_extent\_usage\(int4 tablespace oid, int4 database oid, int4 extent\_type, int4 forknum\)

描述：每次返回一个ExtentGroup中，每个被分配出去的extent的使用情况。extent\_type表示ExtentGroup的类型，合理取值为\[1,5\]的int值。在此范围外的会报error。forknum 表示fork号，合法取值为\[0,4\]的int值，目前只有三种值有效，数据文件为0，FSM文件为1，visibility map文件为2。

返回值类型：

start_block Extent的起始物理页号。
extent_size Extent的大小。
usage_type Extent的使用类型，比如segment head、data extent等。
ower_location 有指针指向该extent的对象的位置。比如data extent的owner就是它所属的segment的head位置。
special_data 该extent在它owner中的位置。该字段的数据跟使用类型有关。比如data extent的special data就是它在所属segment中的extent id。

其中，usage\_type为枚举类型，每一项的含义为：

  -   Non-bucket table segment head  ：非hashbucket表的数据段头。
  -   Non-bucket table fork head：非段页式表的fork段头。
  -   Data extent：数据块。

例如：

    ```
    select * from pg_stat_segment_extent_usage((select oid::int4 from pg_tablespace where spcname='pg_default'), (select oid::int4 from pg_database where datname='postgres'), 1, 0);
    start_block | extent_size |       usage_type       | ower_location | special_data
    -------------+-------------+------------------------+---------------+--------------
    4157 |           1 | Data extent |    4294967295 |            0
    4158 |           1 | Data extent |          4157 |            0
    ```

-  local\_space\_shrink\(tablespacename TEXT, databasename TEXT\)

描述：当前节点上对指定段页式空间做物理空间收缩。注意，目前只支持对当前连接的database做shrink。

返回值：空

- gs\_space\_shrink\(int4 tablespace, int4 database, int4 extent\_type, int4 forknum\)

描述：效果跟local\_space\_shrink类似，对指定段页式空间做物理空间收缩,但参数不同，传入的是tablespace和database的oid，extent\_type为\[1,5\]的int值。注意：extent\_type = 1表示段页式元数据，当前版本不支持对元数据所在的物理文件做收缩。该函数仅限工具使用，不建议用户直接使用。

返回值：空

- pg\_stat\_remain\_segment\_info\(\)

描述：展示在当前节点上，因为故障等原因而残留的extent。残留extent主要分为两类：分配而未被利用的segment和分配出去而未被利用的extent。两者主要区别在于segment会包含多个extent，回收时，要将segment上的extent一并全部回收。

返回值类型：

space_id 表空间ID db_id 数据库ID block_id Extent的ID type Extent的类型，当前有三种：ALLOC_SEGMENT、DROP_SEGMENT、SHRINK_EXTENT

其中type的三种类型分别表示：

  - ALLOC\_SEGMENT:用户创建一张段页式表，当segment刚被分配，但是建表语句所在事务仍未提交时，节点故障，导致该segment被分配后，没有被使用。
  - DROP\_SEGMENT:用户删除段页式表，当该事务成功提交，但是此表的segment页面对应的bit位未被重置，就发生掉电等故障，造成该segment未被使用，也未被释放。
  - SHRINK\_EXTENT:用户对段页式表执行shrink操作，在未对空置出的extent进行释放时，发生掉电等故障，造成该extent残留，无法被重新利用。

例如：

        ```
        select * from pg_stat_remain_segment_info();
        space_id | db_id | block_id | type
        ----------+-------+----------+------
        1663       |   16385|        4156| ALLOC_SEGMENT
        ```

- pg\_free\_remain\_segment\(int4 spaceId, int4 dbId, int4 segmentId\)

描述：释放指定的残留extent。参数取值必须为从函数pg\_stat\_remain\_segment\_info中查询获取。函数会对传入值校验，如果指定extent不在记录的残留extent中，将返回错误信息。指定的extent如果为单个extent，则只将其独自释放；如果为一个segment，则会将此segment以及此segment上记录的所有extent释放。

返回值：空

-   gs\_table\_shrink\(tablename TEXT, tablespacename TEXT, databasename TEXT\)

描述：对指定段页式表执行空间回收操作。该函数会回收表尾部空闲的 extent，并将其归还文件以供其他对象使用。同时，它也会尽可能利用表前部的空闲空间，将尾部有效数据向前移动，实现表空间的紧凑整理。当前仅支持对当前连接数据库中的段页式表执行 shrink 操作，对于不支持的场景会在函数执行前进行校验并返回错误。

返回值：返回该表本次 shrink 操作中成功回收的 extent 数量
>[!TIP]须知
>本函数执行过程中可能会移动数据位置，导致索引失效，请谨慎使用。

-   gs\_space\_shrink\_compact\(tablespacename TEXT, databasename TEXT\)

描述：对指定段页式表空间执行物理空间压缩回收操作。该函数尝试将表空间中的 extent 移动并紧凑排列，刷新高水位线，以释放尾部未使用的空间。物理文件大小将按 128MB 对齐。当前仅支持对当前连接数据库中的段页式空间执行 shrink 操作，不支持的场景在函数执行前会进行校验并返回错误。

返回值：空
