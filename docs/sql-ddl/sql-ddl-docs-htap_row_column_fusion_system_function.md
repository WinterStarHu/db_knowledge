# HTAP行列融合系统函数

- query\_imcstore\_views\(\)

描述：查看HTAP行列融合表转换信息。

返回值类型：

reloid 表id。
relname 表名。
imcs_attrs 转换列对应行存的下标。
imcs_nattrs 转换列数。
imcs_status 转换状态。INITIAL：初始化。COMPLETE：完成行列转换。ERROR：行列转换失败。ONSTANDBY：主备场景下主节点显示转换在备节点执行。
is_partition 是否是分区。
parent_oid 父表id。
cu_size_in_mem 内存中存储的cu大小。
cu_num_in_mem 内存中存储的cu个数。
cu_size_in_disk 临时文件中存储的cu大小。
cu_num_in_disk 临时文件中存储的cu个数。
delta_in_mem 内存中存储delta page的大小

注：

由于列存数据无法直接更新（列存数据作为整块内存，即时更新会造成大面积的内存拷贝和性能下降，同时HTAP功能需要针对列存rowid和行存ctid映射，即时更新会破坏映射关系），数据修改无法直接应用至列存缓存。所以修改操作会优先存储在增量表中，等到满足条件后重新构建列存缓存。
针对数据修改，具体实现逻辑为：
  1. 修改操作会记录至delta增量表，具体记录数据为行存的行id和修改时的事务id。此处由于记录的是操作记录，所以增删改操作都会增加内存使用。
  2. 满足条件后触发vacuum，后台vacuum会根据frozenxid重新构建CU，并且删除增量表中小于frozenxid的记录。

表现为数据更新/插入/删除时delta占用内存增加，vacuum后delta内存占用减少并且CU更新。
此处由于vacuum是基于Frozenxid的重新构建，只会将小于frozenxid的操作更新，该操作存在一定延迟，且延迟不可控。延迟由frozenxid的推进时间为准。

例如：

    ```
    select * from query_imcstore_views();
    reloid | relname | imcs_attrs | imcs_nattrs | imcs_status | is_partition | parent_oid | cu_size_in_mem | cu_num_in_mem | cu_size_in_disk | cu_num_in_disk | delta_in_mem
    --------+---------+------------+-------------+-------------+--------------+------------+----------------+---------------+-----------------+----------------+-------------
    16384 | test    | 1 2 3      |           3 | COMPLETE    | f            |          0 |              0 |             0 |               0 |              0 |            0
    (1 row)
    ```
