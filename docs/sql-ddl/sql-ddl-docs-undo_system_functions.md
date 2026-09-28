# Undo系统函数

- gs\_undo\_meta\(type, zoneId, location\)

描述：Undo各模块元信息。

参数说明：

  - type\(元信息类型\)

0表示Undo Zone\(Record\) 对应的元信息。

1表示Undo Zone\(Transaction Slot\) 对应的元信息。

2表示Undo Space\(Record\) 对应的元信息。

3表示Undo Space\(Transaction Slot\) 对应的元信息。

  - zoneId\(undo zone编号\)

-1表示所有undo zone的元信息。

0-1024\*1024表示对应zoneid的元信息。

  - location\(读取位置）

0表示从当前内存中读取。

1表示从物理文件中读取。

返回值类型：record

示例：

    ```sql
    openGauss=# select * from gs_undo_meta(0, -1, 0);
     zoneId | persistType |      insert      |     discard      |       end        |       used       |       lsn        |    pid
    --------+-------------+------------------+------------------+------------------+------------------+------------------+------------
    ```

**表 1**  gs\_undo\_meta参数说明

参数类型 参数名 输入参数 type int 元信息类型。
输入参数 zoneId int Undo zone 编号 输入参数 location int 读取位置。
输出参数 zoneId oid Undo zone 编号。
输出参数 persistType oid 持久化级别。
输出参数 insert text 下一条插入的 undo 记录位置。
输出参数 discard text 普通回收到的 undo 记录位置。
输出参数 end text 结束插入 undo 记录位置。
输出参数 used text 已使用的 Undo Zone 信息。
输出参数 lsn text 修改zone的lsn。
输出参数 pid oid 进程ID。

- gs\_undo\_translot\(location, zoneId\)

描述：Undo事务槽信息。

参数说明：

  - location\(读取位置\)

0表示从当前内存中读取。

1表示从物理文件中读取。

  - zoneId\(undo zone编号\)

-1表示所有undo zone的元信息。

0-1024\*1024表示对应zoneId的元信息。

返回值类型：record

示例：

    ```sql
    openGauss=# select * from gs_undo_translot(0, -1);
     groupId | xactId | startUndoPtr | endUndoPtr | lsn | slot_states
    ---------+--------+--------------+------------+-----+-------------
    ```

**表 2**  gs\_undo\_translot参数说明

参数类型 参数名 输入参数 location int 读取位置。
输入参数 zoneId int Undo zone 编号 输出参数 groupId oid 持久化级别。
输出参数 xactId text 事物 id 。
输出参数 startUndoPtr text slot 对应事物起始插入 undo 记录位置。
输出参数 endUndoPtr text slot 对应事物结束插入 undo 记录位置。
输出参数 lsn text 修改 slot 的 lsn 。
输出参数 slot_states int 事物状态。

- gs\_stat\_undo\(\)

描述：Undo统计信息。

返回值类型：record

示例：

    ```sql
    openGauss=# select * from gs_stat_undo();
     curr_used_zone_count |   top_used_zones    | curr_used_undo_size | undo_threshold | global_recycle_xid | oldest_xmin | total_undo_chain_len | max_undo_chain_len | create_undo_file_count | discard_undo_file_count
    ----------------------+---------------------+---------------------+----------------+--------------------+-------------+----------------------+--------------------+------------------------+-------------------------
    ```

**表 3**  gs\_stat\_undo参数说明

参数类型 参数名 输出参数 curr_used_zone_count uint32 当前使用的Undo zone数量。
输出参数 top_used_zones text 前三个使用量最大的Undo zone信息，格式输出为： (zoneId1:使用大小，zoneId2:使用大小，zoneId3:使用大小)。
输出参数 curr_used_undo_size uint32 当前使用的Undo总空间大小，单位为MB。
输出参数 undo_threshold uint32 为guc参数undo_space_limit_size * 80%计算的结果,单位为MB。
输出参数 oldest_xid_in_undo uint64 当前Undo空间回收到的事务xid(小于该xid事务产生的Undo记录都已经被回收)。
输出参数 oldest_xmin uint64 最老的活跃事务。
输出参数 total_undo_chain_len int64 所有访问过的Undo链总长度。
输出参数 max_undo_chain_len int64 最大访问过的Undo链长度。
输出参数 create_undo_file_count uint32 创建的Undo文件数量统计。
输出参数 discard_undo_file_count uint32 删除的Undo文件数量统计。

- gs\_undo\_record\(undoptr\)

描述：Undo记录解析。

参数说明：

  - undoptr\(undo记录指针\)

返回值类型：record

示例：

    ```sql
    openGauss=# select * from gs_undo_record(4698);
     undoptr | xid |       cid        |      reloid      |   relfilenode    |      utype       |     blkprev      |     blockno      |      uoffset     |     prevurp      |    payloadlen
    ---------+-----+------------------+------------------+------------------+------------------+------------------+------------------+------------------+------------------+------------------
    ```

+ gs\_undo\_dump\_parsepage\_mv\(relpath text, blkno bigint, reltype text, rmem boolean\)

描述：解析Ustore数据表磁盘页面的页头信息，每个元组的头部信息，标识位信息以及所有可以查询到undo历史版本信息。

返回值类型：text

备注：必须是系统管理员或者运维管理人员才能执行此函数。

  >[!NOTE]说明
  >该接口当前仅支持Ustore数据表。

示例：

  ```sql
  openGauss=# select * from gs_undo_dump_parsepage_mv('base/16384/16391', -1, 'uheap', false);
                  output
    -------------------------------------------
  ```

**表 4**  gs\_undo\_dump\_parsepage\_mv参数说明

参数类型 参数名 输入参数 relpath text Ustore表数据文件相对路径，相对路径格式为：tablespace name/database oid/relfilenode，例如base/16603/16384, 表对应数据文件的相对路径查找可以通过pg_relation_filepath('tablename')查询。
输入参数 blkno bigint -1 解析所有block页面。0-MaxBlocNumber 解析指定的block页面。
输入参数 reltype text 表类型，目前仅支持Ustore数据表，取值为uheap。
输入参数 rmem boolean falsetrue 目前仅支持false，从磁盘文件上解析对应的页面。
输出参数 output text 解析结果文件的绝对路径。

​

+ gs\_undo\_meta\_dump\_zone\(zone\_id int, read\_memory boolean\)

描述：解析Undo模块中zone的元信息。

返回值类型：record

示例：

  ```sql
  openGauss=# select * from gs_undo_meta_dump_zone(-1, true);
   zone_id | persist_type | insert | discard | forcediscard |   lsn
  ---------+--------------+--------+---------+--------------+----------
  ```

**表 5**  gs\_undo\_meta\_dump\_zone参数说明

参数类型 参数名 输入参数 zone_id int 输入参数 read_memory boolean true：从当前内存中读取。false：从物理文件中读取。
输出参数 zone_id int Undo zone编号。
输出参数 persist_type int 输出参数 insert text 下一条插入的undo记录位置。
输出参数 discard text 普通回收到的undo记录位置。
输出参数 forcediscard text 强制回收掉undo记录位置，小于它的undo记录已经被回收。
输出参数 lsn text 修改zone的lsn。

+ gs\_undo\_meta\_dump\_spaces\(zone\_id int, read\_memory boolean\)

描述：解析Undo模块中undo记录空间，undo slot空间的元信息。

返回值类型：record

示例：

  ```sql
  openGauss=# select * from gs_undo_meta_dump_spaces(-1, true);
   zone_id | undorecord_space_tail | undorecord_space_head | undorecord_space_lsn | undoslot_space_tail | undoslot_space_head | undoreslot_space_lsn
  ---------+-----------------------+-----------------------+----------------------+---------------------+---------------------+----------------------
  ```

**表 6**  gs\_undo\_meta\_dump\_spaces参数说明

参数类型 参数名 输入参数 zone_id int 输入参数 read_memory boolean true：从当前内存中读取。false：从物理文件中读取。
输出参数 zone_id int Undo zone编号。
输出参数 undorecord_space_tail text Undo record空间的结尾位置。
输出参数 undorecord_space_head text Undo record空间的起始位置。
输出参数 undorecord_space_lsn text 修改Undo record空间lsn。
输出参数 undoslot_space_tail text Undo slot空间的结尾位置。
输出参数 undoslot_space_head text Undo slot空间的起始位置。
输出参数 undoreslot_space_lsn text 修改Undo slot空间lsn。

​

+ gs\_undo\_meta\_dump\_slot\(zone\_id int, read\_memory boolean\)

描述：解析Undo模块中slot元信息。

返回值类型：record

示例：

  ```sql
  openGauss=# select * from gs_undo_meta_dump_slot(-1, true);
   zone_id | allocate | recycle | frozen_xid | global_frozen_xid | recycle_xid | global_recycle_xid
  ---------+----------+---------+------------+-------------------+-------------+--------------------
  ```

**表 7**  gs\_undo\_meta\_dump\_slot参数说明

参数类型 参数名 输入参数 zone_id int 输入参数 read_memory boolean true：从当前内存中读取。false：从物理文件中读取。
输出参数 zone_id int Undo zone编号。
输出参数 allocate text Undo transaction slot分配位置。
输出参数 recycle text Undo transaction slot回收位置。
输出参数 frozen_xid text frozen xid，用于可见性判断。
输出参数 global_frozen_xid text 全局最小的frozen xid，小于该xid的事务可见。
输出参数 recycle_xid text 回收到的xid，小于该xid的事务被回收。
输出参数 global_recycle_xid text 全局最小的recycle xid，小于该xid的事务被回收。

​

- gs\_undo\_translot\_dump\_slot\(zone\_id int, read\_memory boolean\)

描述：解析zone中的slot。

返回值类型：record

示例：

  ```sql
  openGauss=# select * from gs_undo_translot_dump_slot(-1, true);
   zone_id | slot_xid | start_undoptr | end_undoptr | slot_ptr | slot_states
  ---------+----------+---------------+-------------+----------+-------------
  ```

**表 8**  gs\_undo\_translot\_dump\_slot参数说明

参数类型 参数名 输入参数 zone_id oid 输入参数 read_memory boolean true：从当前内存中读取。false：从物理文件中读取。
输出参数 zone_id text Undo zone编号。
输出参数 slot_xid text 事务id。
输出参数 start_undoptr text slot对应事务起始插入undo记录位置。
输出参数 end_undoptr text slot对应事务结束插入undo记录位置。
输出参数 lsn text 修改slot的lsn。
输出参数 slot_states oid

- gs\_undo\_translot\_dump\_xid\(slot\_xid xid, read\_memory boolean\)

描述：根据xid，解析zone中对应的slot。

返回值类型：record

示例：

  ```sql
  openGauss=# select * from gs_undo_translot_dump_xid('14249', true);
   zone_id | slot_xid | start_undoptr | end_undoptr | slot_ptr | slot_states
  ---------+----------+---------------+-------------+----------+-------------
  ```

**表 9**  gs\_undo\_translot\_dump\_xid参数说明

参数类型 参数名 输入参数 slot_xid xid 需要查询的事务id。
输入参数 read_memory boolean true：从当前内存中读取。false：从物理文件中读取。
输出参数 zone_id text Undo zone编号。
输出参数 slot_xid text 事务id。
输出参数 start_undoptr text slot对应事务起始插入undo记录位置。
输出参数 end_undoptr text slot对应事务结束插入undo记录位置。
输出参数 lsn text 修改slot的lsn。
输出参数 slot_states oid

- gs\_undo\_dump\_record\(undoptr bigint\)

描述：解析undo记录。

返回值类型：record

示例：

  ```sql
  openGauss=# select * from gs_undo_dump_record(4698);
   undoptr | xactid |       cid        |      reloid      |   relfilenode    |      utype       |     blkprev      |     blockno      |     uoffset      |     prevurp      |    payloadlen    |    oldxactid     |   partitionoid   |    tablespace    | alreadyread_bytes | prev_undorec_len | td_id | reserved | flag | flag2 | t_hoff
  ---------+--------+------------------+------------------+------------------+------------------+------------------+------------------+------------------+------------------+------------------+------------------+------------------+------------------+-------------------+------------------+-------+----------+------+-------+--------
  ```

**表 10**  gs\_undo\_dump\_record参数说明

参数类型 参数名 输入参数 undoptr bigint 需要解析的undo记录起始位置 输出参数 undoptr bigint 需要解析的undo记录起始位置 输出参数 xactid text 事务id 输出参数 cid text command id 输出参数 reloid text relation oid 输出参数 relfilenode text 文件的relfinode 输出参数 utype text undo记录类型 输出参数 blkprev text 同一个块前一条undo记录的位置 输出参数 blockno text 输出参数 uoffset text undo记录偏移 输出参数 prevurp text 前一条undo记录位置 输出参数 payloadlen text undo记录数据部分长度 输出参数 oldxactid text 前一个事务id 输出参数 partitionoid text 分区oid 输出参数 tablespace text 表空间 输出参数 alreadyread_bytes text 读取到的undo记录长度 输出参数 prev_undorec_len text 前一条undo记录长度 输出参数 td_id text Transaction Directory的id 输出参数 reserved text 是否保存 输出参数 flag text 标识1 输出参数 flag2 text 标识2 输出参数 t_hoff text Undo记录数据头的长度

- gs\_undo\_dump\_xid\(undo\_xid xid\)

描述：根据xid解析undo记录

返回值类型：record

示例：

  ```sql
  openGauss=# select * from gs_undo_dump_xid('14249');
   undoptr | xactid | cid | reloid | relfilenode | utype | blkprev | blockno | uoffset | prevurp | payloadlen | oldxactid | partitionoid | tablespace | alreadyread_bytes | prev_undorec_len | td_id | reserved | flag | flag2 | t_hoff
  ---------+--------+-----+--------+-------------+-------+---------+---------+---------+---------+------------+-----------+--------------+------------+-------------------+------------------+-------+----------+------+-------+--------
  ```

**表 11**  gs\_undo\_dump\_xid参数说明

参数类型 参数名 输入参数 undo_xid xid 事务xid 输出参数 undoptr xid 需要解析的undo记录起始位置 输出参数 xactid text 事务id 输出参数 cid text command id 输出参数 reloid text relation oid 输出参数 relfilenode text 文件的relfinode 输出参数 utype text undo记录类型 输出参数 blkprev text 同一个块前一条undo记录的位置 输出参数 blockno text 输出参数 uoffset text undo记录偏移 输出参数 prevurp text 前一条undo记录位置 输出参数 payloadlen text undo记录数据部分长度 输出参数 oldxactid text 前一个事务id 输出参数 partitionoid text 分区oid 输出参数 tablespace text 表空间 输出参数 alreadyread_bytes text 读取到的undo记录长度 输出参数 prev_undorec_len text 前一条undo记录长度 输出参数 td_id text Transaction Directory的id 输出参数 reserved text 是否保留 输出参数 flag text 标识1 输出参数 flag2 text 标识2 输出参数 t_hoff text Undo记录数据头的长度
