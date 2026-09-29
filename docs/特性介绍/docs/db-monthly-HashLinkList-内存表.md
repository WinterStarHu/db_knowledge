# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2017/05/08/
> 分类: 特性介绍

数据库内核月报
 -->
  

  

  

  

  

  

  

  

  

  
 -->
  
hljs.initHighlightingOnLoad();

  

  

  

  

  (function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
  (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
  m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
  })(window,document,'script','//www.google-analytics.com/analytics.js','ga');

  ga('create', 'UA-62056244-1', 'auto');
  ga('send', 'pageview');

 -->

  

  

  数据库内核月报
	

  

    
数据库内核月报 － 2017 / 05

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 引擎特性 · InnoDB Buffer Pool
                      

                    

                    

                  
                      

                        AliSQL · 特性介绍 · 动态加字段
                      

                    

                    

                  
                      

                        PgSQL · 特性分析 · 数据库崩溃恢复（上）
                      

                    

                    

                  
                      

                        MySQL · 答疑解惑 · MySQL 的那些网络超时错误
                      

                    

                    

                  
                      

                        HybridDB · 最佳实践 · HybridDB 数据合并的方法与原理
                      

                    

                    

                  
                      

                        MSSQL · 应用案例 · 构建死锁自动收集系统
                      

                    

                    

                  
                      

                        PostgreSQL · 实现分析 · PostgreSQL 10.0 并行查询和外部表的结合
                      

                    

                    

                  
                      

                        RocksDB · 特性介绍 · HashLinkList 内存表
                      

                    

                    

                  
                      

                        MySQL · myrocks · fast data load
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · "写入、共享、存储、计算" 最佳实践
                      

                    

 
        

    

  

    
 RocksDB · 特性介绍 · HashLinkList 内存表  

    
 Author: 田汉  

  

  

  

Table of Contents

1. RocksDB 内存表简介

2. HashLinkList 内存表

2.1. 应用示例

2.2. 实现代码

2.2.1. Put

2.2.2. Get

2.2.3. Delete

RocksDB 内存表简介

RocksDB 是一个基于 LSM 树（Log-Structured Merge-tree）结构的单机数据库引擎，内存表是它最重要的数据结构之一。除了默认的跳表（SkipList）之外，它还增加了各种其他的内存表，例如：HashSkipList、HashLinkList、Vector 等。HashSkipList 是在跳表外套了一层 Hash，每个桶对应了一个跳表。类似的，HashLinkList 是在链表外套了一层 Hash，每个桶对应了一个链表。这两种内存表都需要配置 prefix_extractor，以计算 hash 值。RocksDB 支持的内存表类型见下图：

为了方便使用，内存表有对应的工厂类 MemTableRepFactory。与内存表类型对应，完整的内存表工厂类的继承关系如下图：

从内存表的基类 MemTableRep 中可以看到，它支持的 API 有 Get、Insert 等，但是没有 Delete。这是因为 Delete 被上层转换成了一个 Insert，真正的删除是在数据合并过程中做的。

HashLinkList 内存表

应用示例

相比 HashSkipList 而言，HashLinkList 要更简洁/简单一些，也可以节约内存的占用。它的缺点是不支持并发的写入。为了测试各种内存表的表现，RocksDB 提供了一个简单的测试工具，参看：memtablerep_bench.cc。我们也可以在示例代码 examples/simple_example.cc 中修改一下来验证 HashLinkList 的使用。例如：

$ git diff examples/simple_example.cc
diff --git a/examples/simple_example.cc b/examples/simple_example.cc
index 57d1b25..7b67ff0 100644
--- a/examples/simple_example.cc
+++ b/examples/simple_example.cc
@@ -9,6 +9,7 @@
 #include "rocksdb/db.h"
 #include "rocksdb/slice.h"
 #include "rocksdb/options.h"
+#include "rocksdb/slice_transform.h"
 
 using namespace rocksdb;
 
@@ -17,6 +18,9 @@ std::string kDBPath = "/tmp/rocksdb_simple_example";
 int main() {
   DB* db;
   Options options;
+  options.memtable_factory.reset(NewHashLinkListRepFactory(4, 0, 1, true, 4));
+  options.prefix_extractor.reset(NewFixedPrefixTransform(1));
+  options.allow_concurrent_memtable_write = false;
   // Optimize RocksDB. This is the easiest way to get RocksDB to perform well
   options.IncreaseParallelism();
   options.OptimizeLevelStyleCompaction();

需要注意的几个地方：

  
options.memtable_factory.reset() 是将默认的 SkipList 替换为我们要测试的 HashLinkList。

  
options.prefix_extractor.reset() 是设置 Hash 需要的 prefix_extractor，如果不设置，默认用的还会是 SkipList。

  
options.allow_concurrent_memtable_write = false 是因为 HashLinkList 不支持并发写入，不设置运行时会报错。

  
数据存放在 /tmp/rocksdb_simple_example，如果数据目录已经存在，则会打开已经存在的数据库。

实现代码

HashLinkList 的代码存在以下两个文件中：memtable/hash_linklist_rep.h 以及 memtable/hash_linklist_rep.cc。可以看到它做了一些细节的优化，从简单的 Hash 链表逐步演化到 Hash 跳表。代码注释得非常清楚，参看下图：

由于存在上述的一些优化，Hash 表在不同时刻会存在不同的形式。

  
第一种情况最简单，也就是桶为空。不占用额外内存空间。

  
第二种情况下，桶里头只有一条记录，存在链表第一个节点中。Next 指针占用额外空间。Next 指针取值为 NULL。后续其他情况下 Next 指针都不是 NULL，可以依赖这一点来区分不同的场景。

  
第三种情况下，桶里头的记录多余一条，链表的第一个节点是个表头，记录链表中的记录数。记录数是为了判断链表是否应该转换为跳表而设的。额外空间包括这个表头节点以及每个节点中的 Next 指针。

  
第四种情况下，桶里头的记录数超过了设定的阈值（threshold_use_skiplist），链表被转换为一个跳表。链表的第一个节点的 Next 指针指向自己。Count 继续保留，可以用来做测试等。

如果 HashLinkList 要支持并发写，就需要对数据结构做适当的控制。不过当前它并不支持并发写，而是单写多读。它实现时采用了 C++ 11 的 Atomic 做一些特殊的处理避免加锁。另外需要注意的是，这个 Iterator 的实现 MemTableRep::Iterator* HashLinkListRep::GetIterator() 比较费资源，它会 new 一个 MemtableSkipList，把记录都遍历出来并插入进去。

采用修改后的 simple_example.cc，可以看到插入、查找、删除所对应的执行路径，用来理解代码的主要执行流程。

Put

(gdb) bt
#0  rocksdb::(anonymous namespace)::HashLinkListRep::Insert (this=0xcd2af0, handle=0xcf3250) at memtable/hash_linklist_rep.cc:580
#1  0x000000000044af7f in rocksdb::MemTable::Add (this=0xcf3000, s=1, type=rocksdb::kTypeValue, key=..., value=..., allow_concurrent=false, post_process_info=0x0) at db/memtable.cc:452
#2  0x00000000004a9850 in rocksdb::MemTableInserter::PutCF (this=0x7fffffffb550, column_family_id=0, key=..., value=...) at db/write_batch.cc:944
#3  0x00000000004a422e in rocksdb::WriteBatch::Iterate (this=0x7fffffffbb60, handler=0x7fffffffb550) at db/write_batch.cc:386
#4  0x00000000004a61f1 in rocksdb::WriteBatchInternal::InsertInto (writers=..., sequence=1, memtables=0xceb780, flush_scheduler=0xcf0780, ignore_missing_column_families=false, recovery_log_number=0, 
    db=0xcf0000, concurrent_memtable_writes=false) at db/write_batch.cc:1294
#5  0x0000000000609f2e in rocksdb::DBImpl::WriteImpl (this=0xcf0000, write_options=..., my_batch=0x7fffffffbb60, callback=0x0, log_used=0x0, log_ref=0, disable_memtable=false)
    at db/db_impl_write.cc:215
#6  0x00000000006093c2 in rocksdb::DBImpl::Write (this=0xcf0000, write_options=..., my_batch=0x7fffffffbb60) at db/db_impl_write.cc:48
#7  0x000000000060ca99 in rocksdb::DB::Put (this=0xcf0000, opt=..., column_family=0xcce9e0, key=..., value=...) at db/db_impl_write.cc:794
#8  0x0000000000609240 in rocksdb::DBImpl::Put (this=0xcf0000, o=..., column_family=0xcce9e0, key=..., val=...) at db/db_impl_write.cc:23
#9  0x00000000005f7ee7 in rocksdb::DB::Put (this=0xcf0000, options=..., key=..., value=...) at ./include/rocksdb/db.h:201
#10 0x00000000004082a0 in main () at simple_example.cc:40

Get

(gdb) bt
#0  rocksdb::(anonymous namespace)::HashLinkListRep::Get (this=0xcd2af0, k=..., callback_args=0x7fffffffb750, callback_func=0x44b82c <rocksdb::SaveValue(void*, char const*)>)
    at memtable/hash_linklist_rep.cc:727
#1  0x000000000044c1fc in rocksdb::MemTable::Get (this=0xcf3000, key=..., value=0x7fffffffc020, s=0x7fffffffc090, merge_context=0x7fffffffba60, range_del_agg=0x7fffffffb910, seq=0x7fffffffb898, 
    read_opts=...) at db/memtable.cc:678
#2  0x00000000005f9800 in rocksdb::MemTable::Get (this=0xcf3000, key=..., value=0x7fffffffc020, s=0x7fffffffc090, merge_context=0x7fffffffba60, range_del_agg=0x7fffffffb910, read_opts=...)
    at ./db/memtable.h:196
#3  0x00000000005e667a in rocksdb::DBImpl::GetImpl (this=0xcf0000, read_options=..., column_family=0xcce9e0, key=..., pinnable_val=0x7fffffffbba0, value_found=0x0) at db/db_impl.cc:959
#4  0x00000000005e6296 in rocksdb::DBImpl::Get (this=0xcf0000, read_options=..., column_family=0xcce9e0, key=..., value=0x7fffffffbba0) at db/db_impl.cc:905
#5  0x00000000005f811f in rocksdb::DB::Get (this=0xcf0000, options=..., column_family=0xcce9e0, key=..., value=0x7fffffffc020) at ./include/rocksdb/db.h:289
#6  0x00000000005f8233 in rocksdb::DB::Get (this=0xcf0000, options=..., key=..., value=0x7fffffffc020) at ./include/rocksdb/db.h:299
#7  0x0000000000408364 in main () at simple_example.cc:44

Delete

(gdb) bt
#0  rocksdb::(anonymous namespace)::HashLinkListRep::Insert (this=0xcd2af0, handle=0xcf3278) at memtable/hash_linklist_rep.cc:580
#1  0x000000000044af7f in rocksdb::MemTable::Add (this=0xcf3000, s=2, type=rocksdb::kTypeDeletion, key=..., value=..., allow_concurrent=false, post_process_info=0x0) at db/memtable.cc:452
#2  0x00000000004a9d9e in rocksdb::MemTableInserter::DeleteImpl (this=0x7fffffffb680, column_family_id=0, key=..., value=..., delete_type=rocksdb::kTypeDeletion) at db/write_batch.cc:999
#3  0x00000000004a9eb8 in rocksdb::MemTableInserter::DeleteCF (this=0x7fffffffb680, column_family_id=0, key=...) at db/write_batch.cc:1018
#4  0x00000000004a42db in rocksdb::WriteBatch::Iterate (this=0x7fffffffbc60, handler=0x7fffffffb680) at db/write_batch.cc:393
#5  0x00000000004a61f1 in rocksdb::WriteBatchInternal::InsertInto (writers=..., sequence=2, memtables=0xceb780, flush_scheduler=0xcf0780, ignore_missing_column_families=false, recovery_log_number=0, 
    db=0xcf0000, concurrent_memtable_writes=false) at db/write_batch.cc:1294
#6  0x0000000000609f2e in rocksdb::DBImpl::WriteImpl (this=0xcf0000, write_options=..., my_batch=0x7fffffffbc60, callback=0x0, log_used=0x0, log_ref=0, disable_memtable=false)
    at db/db_impl_write.cc:215
#7  0x00000000006093c2 in rocksdb::DBImpl::Write (this=0xcf0000, write_options=..., my_batch=0x7fffffffbc60) at db/db_impl_write.cc:48
#8  0x0000000000408480 in main () at simple_example.cc:53

  

    

		

 -->
  

  
阿里云PolarDB-数据库内核组
 -->
  
 -->
  
社招/校招 欢迎投递简历 直达招聘信息
 -->
  
 -->
  
直连月报小编
 -->
  
 -->
  
欢迎在github上star AliSQL
 -->
  

  阅读：
 - 

  

本作品采用
知识共享署名-非商业性使用-相同方式共享 3.0 未本地化版本许可协议
进行许可。

  jQuery(document).ready(function($){
    // browser window scroll (in pixels) after which the "back to top" link is shown
    var offset = 300,
      //browser window scroll (in pixels) after which the "back to top" link opacity is reduced
      offset_opacity = 1200,
      //duration of the top scrolling animation (in ms)
      scroll_top_duration = 700,
      //grab the "back to top" link
      $back_to_top = $('.cd-top');

    //hide or show the "back to top" link
    $(window).scroll(function(){
      ( $(this).scrollTop() > offset ) ? $back_to_top.addClass('cd-is-visible') : $back_to_top.removeClass('cd-is-visible cd-fade-out');
      if( $(this).scrollTop() > offset_opacity ) {
        $back_to_top.addClass('cd-fade-out');
      }
    });

    //smooth scroll to top
    $back_to_top.on('click', function(event){
      event.preventDefault();
      $('body,html').animate({
        scrollTop: 0 ,
        }, scroll_top_duration
      );
    });

  });
