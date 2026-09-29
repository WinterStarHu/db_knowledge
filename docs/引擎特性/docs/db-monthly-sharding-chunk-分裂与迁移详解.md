# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2018/08/05/
> 分类: 引擎特性

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
	

  

    
数据库内核月报 － 2018 / 08

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 引擎特性 · 主库 binlog 概览
                      

                    

                    

                  
                      

                        MySQL · RocksDB · Write Prepared Policy
                      

                    

                    

                  
                      

                        MSSQL · 最佳实践 · 使用对称秘钥实现列加密
                      

                    

                    

                  
                      

                        MySQL · 特性分析 · InnoDB对binlog_format的限制
                      

                    

                    

                  
                      

                        MongoDB · 引擎特性 · sharding chunk 分裂与迁移详解
                      

                    

                    

                  
                      

                        PgSQL · 源码分析 · PostgreSQL物理备份内部原理
                      

                    

                    

                  
                      

                        MySQL · 源码分析 · 连接与认证过程
                      

                    

                    

                  
                      

                        MySQL · RocksDB ·  MemTable的写入逻辑
                      

                    

                    

                  
                      

                        PgSQL · 最佳实践 · Greenplum RoaringBitmap多阶段聚合
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · 高并发空间位置更新、多属性KNN搜索并测
                      

                    

 
        

    

  

    
 MongoDB · 引擎特性 · sharding chunk 分裂与迁移详解  

    
 Author: linqing  

  

  

  
MongoDB Sharding

关于 MongoDB sharding 的原理，如果不了解请先参考

  

关于MongoDB Sharding，你应该知道的

  

MongoDB Sharded cluster架构原理

注：本文的内容基于 mongoDB 3.2 版本。

Primary shard

使用 MongoDB sharding 后，数据会以 chunk 为单位（默认64MB）根据 
shardKey
 分散到后端1或多个 shard 上。

每个 database 会有一个 
primary shard
，在数据库创建时分配

  
database 下启用分片（即调用 
shardCollection
 命令）的集合，刚开始会生成一个[minKey, maxKey] 的 chunk，该 chunk 初始会存储在 
primary shard
 上，然后随着数据的写入，不断的发生 chunk 分裂及迁移，整个过程如下图所示。

  
database 下没有启用分片的集合，其所有数据都会存储到  
primary shard

何时触发 chunk 分裂？

mongos 上有个 
sharding.autoSplit
 的配置项，可用于控制是否自动触发 chunk 分裂，默认是开启的。如无专业人士指导，强烈建议不要关闭 autoSplit，更好的方式是使用「预分片」的方式来提前分裂，后面会详细介绍。

mongoDB 的自动 chunk 分裂只会发生在 mongos 写入数据时，当写入的数据超过一定量时，就会触发 chunk 的分裂，具体规则如下。

int ChunkManager::getCurrentDesiredChunkSize() const {
    // split faster in early chunks helps spread out an initial load better
    const int minChunkSize = 1 << 20;  // 1 MBytes

    int splitThreshold = Chunk::MaxChunkSize;  // default 64MB

    int nc = numChunks();

    if (nc <= 1) {
        return 1024;
    } else if (nc < 3) {
        return minChunkSize / 2;
    } else if (nc < 10) {
        splitThreshold = max(splitThreshold / 4, minChunkSize);
    } else if (nc < 20) {
        splitThreshold = max(splitThreshold / 2, minChunkSize);
    }

    return splitThreshold;
} 

bool Chunk::splitIfShould(OperationContext* txn, long dataWritten) const {
    dassert(ShouldAutoSplit);
    LastError::Disabled d(&LastError::get(cc()));

    try {
        _dataWritten += dataWritten;
        int splitThreshold = getManager()->getCurrentDesiredChunkSize();
        if (_minIsInf() || _maxIsInf()) {
            splitThreshold = (int)((double)splitThreshold * .9);
        }

        if (_dataWritten < splitThreshold / ChunkManager::SplitHeuristics::splitTestFactor)
            return false;

        if (!getManager()->_splitHeuristics._splitTickets.tryAcquire()) {
            LOG(1) << "won't auto split because not enough tickets: " << getManager()->getns();
            return false;
        }
        ......
}

chunkSize 为默认64MB是，分裂阈值如下

  

    

      
集合 chunk 数量

      
分裂阈值

    

  

  

    

      
1

      
1024B

    

    

      
[1, 3)

      
0.5MB

    

    

      
[3, 10)

      
16MB

    

    

      
[10, 20)

      
32MB

    

    

      
[20, max)

      
64MB

    

  

写入数据时，当 chunk 上写入的数据量，超过分裂阈值时，就会触发 chunk 的分裂，chunk 分裂后，当出现各个 shard 上 chunk 分布不均衡时，就会触发 chunk 迁移。

何时触发 chunk 迁移？

默认情况下，MongoDB 会开启 balancer，在各个 shard 间迁移 chunk 来让各个 shard 间负载均衡。用户也可以手动的调用 
moveChunk
 命令在 shard 之间迁移数据。

Balancer 在工作时，会根据
shard tag
、
集合的 chunk 数量
、
shard 间 chunk 数量差值
 来决定是否需要迁移。

（1）根据 shard tag 迁移

MongoBD sharding 支持 
shard tag
 特性，用户可以给 shard 打上标签，然后给集合的某个range 打上标签，mongoDB 会通过 balancer 的数据迁移来保证「拥有 tag 的 range 会分配到具有相同 tag 的 shard 上」。

（2）根据 shard 间 chunk 数量迁移

int threshold = 8;
if (balancedLastTime || distribution.totalChunks() < 20)
    threshold = 2;
else if (distribution.totalChunks() < 80)
    threshold = 4;

  

    

      
集合 chunk 数量

      
迁移阈值

    

  

  

    

      
[1, 20)

      
2

    

    

      
[20, 80)

      
4

    

    

      
[80, max)

      
8

    

  

针对所有启用分片的集合，如果 「拥有最多数量 chunk 的 shard」 与 「拥有最少数量 chunk 的 shard」 的差值超过某个阈值，就会触发 chunk 迁移； 有了这个机制，当用户调用 
addShard
 添加新的 shard，或者各个 shard 上数据写入不均衡时，balancer 就会自动来均衡数据。

（3）removeShard 触发迁移

还有一种情况会触发迁移，当用户调用  
removeShard
 命令从集群里移除shard时，Balancer 也会自动将这个 shard 负责的 chunk 迁移到其他节点，因 
removeShard
 过程比较复杂，这里先不做介绍，后续专门分析下 
removeShard
 的实现。

chunkSize 对分裂及迁移的影响

MongoDB 默认的 chunkSize 为64MB，如无特殊需求，建议保持默认值；chunkSize 会直接影响到 chunk 分裂、迁移的行为。

  
chunkSize 越小，chunk 分裂及迁移越多，数据分布越均衡；反之，chunkSize 越大，chunk 分裂及迁移会更少，但可能导致数据分布不均。

  
chunkSize 太小，容易出现 jumbo chunk（即shardKey 的某个取值出现频率很高，这些文档只能放到一个 chunk 里，无法再分裂）而无法迁移；chunkSize 越大，则可能出现 
chunk 内文档数太多（chunk 内文档数不能超过 250000 ）
而无法迁移。

  
chunk 自动分裂只会在数据写入时触发，所以如果将 chunkSize 改小，系统需要一定的时间来将 chunk 分裂到指定的大小。

  
chunk 只会分裂，不会合并，所以即使将 chunkSize 改大，现有的 chunk 数量不会减少，但 chunk 大小会随着写入不断增长，直到达到目标大小。


如何减小分裂及迁移的影响？

mongoDB sharding 运行过程中，自动的 chunk 分裂及迁移如果对服务产生了影响，可以考虑一下如下措施。

（1）预分片提前分裂

在使用 
shardCollection
 对集合进行分片时，如果使用 hash 分片，可以对集合进行「预分片」，直接创建出指定数量的 chunk，并打散分布到后端的各个 shard。

指定 
numInitialChunks
 参数在 
shardCollection
 指定初始化的分片数量，该值不能超过 8192。

Optional. Specifies the number of chunks to create initially when sharding an empty collection with a hashed shard key. MongoDB will then create and balance chunks across the cluster. The numInitialChunks must be less than 8192 per shard. If the collection is not empty, numInitialChunks has no effect.

如果使用 range 分片，因为 shardKey 的取值不确定，预分片意义不大，很容易出现部分 chunk 为空的情况，所以 range 分片只支持 hash 分片。

（2）合理配置 balancer

monogDB 的 balancer 能支持非常
灵活的配置策略
来适应各种需求

  
Balancer 能动态的开启、关闭

  
Blancer 能针对指定的集合来开启、关闭

  
Balancer 支持配置时间窗口，只在制定的时间段内进行迁移

参考资料

  

Aliyun MongoDB sharding

  

Manage Sharded Cluster Balancer

  

shardCollection command

  

Migration Thresholds

  

shard tag

  

    

		

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
