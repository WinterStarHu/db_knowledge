# Cache IO Stats

Cache IO Stats包含User table和User index两张表，列名称及描述如下所示。

## User table IO activity ordered by heap blks hit ratio

**表 1**  User table IO activity ordered by heap blks hit ratio报表主要内容

列名称 DB Name Database名称。
Schema Name Schema名称。
Table Name Table名称。
%Heap Blks Hit Ratio 此表的Buffer Pool命中率。
Heap Blks Read 该表中读取的磁盘块数。
Heap Blks Hit 此表缓存命中数。
Idx Blks Read 表中所有索引读取的磁盘块数。
Idx Blks Hit 表中所有索引命中缓存数。
Toast Blks Read 此表的TOAST表读取的磁盘块数（如果存在）。
Toast Blks Hit 此表的TOAST表命中缓冲区数（如果存在）。
Tidx Blks Read 此表的TOAST表索引读取的磁盘块数（如果存在）。
Tidx Blks Hit 此表的TOAST表索引命中缓冲区数（如果存在）。

## User index IO activity ordered by idx blks hit ratio

**表 2**  User index IO activity ordered by idx blks hit ratio报表主要内容

列名称 DB Name Database名称。
Schema Name Schema名称。
Table Name Table名称。
Index Name Index名称。
%Idx Blks Hit Ratio Index的命中率。
Idx Blks Read 所有索引读取的磁盘块数。
Idx Blks Hit 所有索引命中缓存数。
