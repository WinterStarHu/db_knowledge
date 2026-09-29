# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2019/06/05/
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
	

  

    
数据库内核月报 － 2019 / 06

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 引擎特性 · 安全及权限改进相关
                      

                    

                    

                  
                      

                        MySQL · 最佳实践 · RDS MySQL 8.0 语句级并发控制
                      

                    

                    

                  
                      

                        CloudDBA · 最佳实践 · Performance Insights
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · 学生为什么应该学PG
                      

                    

                    

                  
                      

                        MongoDB · 引擎特性 · 4.2 新特性解读
                      

                    

                    

                  
                      

                        PgSQL · 答疑解惑 · 垃圾回收、膨胀、多版本管理、存储引擎
                      

                    

                    

                  
                      

                        MySQL · 引擎特性 · 说说InnoDB Log System的隐藏参数
                      

                    

                    

                  
                      

                        MySQL · 引擎特性 · CHECK CONSTRAINT
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · 如何修改PostgreSQL分区表分区范围
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · 什么情况下可能表膨胀
                      

                    

 
        

    

  

    
 MongoDB · 引擎特性 · 4.2 新特性解读  

    
 Author: lingqing  

  

  

  
MongoDB World 2019 上发布新版本 MongoDB 4.2 Beta，包含多项数据库新特性，本文尝试从技术角度解读。

Full Text Search

MongoDB 4.2 之前，全文搜索（Full Text Search）的能力是靠 Text Index 来支持的，在 MongoDB-4.2 里，MongoDB 直接与 Lucene 等引擎整合，在 Atlas 服务里提供全文建索的能力。

MongoDB FTS 原理

  
用户可以在 Atlas 上，对集合开启全文索引，后台会开起 Lucene 索引引擎（索引引擎、查询引擎均可配置），对存量数据建立索引。

  
对于开启全文建索的集合，新写入到 MongoDB 的数据， 后台的服务会通过 Change Stream 的方式订阅，并更新到 Lucene  索引引擎里。

  
索引的查询直接以 MongoDB Query 的方式提供，Mongod 收到请求会把请求转发到 Lucene 引擎，收到建索结果后回复给客户端。

Full Text Search 示例

下面是一个 Full Text Search 使用的简单示例，整个使用体验非常简单，除了需要在 Atlas 控制台上建索引，其他跟正常使用 MongoDB 毫无差别，随着这块能力的完善，能覆盖很多 Elastic Search 的场景。

Step1: 准备数据

MongoDB Enterprise > db.fruit.find()
{ "_id" : 1, "type" : "apple", "description" : "Apples come in several varieties, including Fuji, Granny Smith, and Honeycrisp." }
{ "_id" : 2, "type" : "banana", "description" : "Bananas are usually sold in bunches of five or six." }

Step2: Atlas 上创建 FTS 索引

Step3: 使用 MongoDB 客户端做搜索，支持 Wildcard、Prefix 等多种搜索能力

// 简单查询

db.fruit.aggregate([
  {
    $searchBeta: {
      "term": {
        "query": "Smith",
        "path": "description"
      }
    }
  }
])
{ "_id" : 1, "type" : "apple", "description" : "Apples come in several varieties, including Fuji, Granny Smith, and Honeycrisp." }

// Wildcard 查询
db.fruit.aggregate([
  {
    $searchBeta: {
      "term": {
        "query": "s*l*",
        "path": "description",
        "wildcard": true
      }
    }
  }
])
{ "_id" : 1, "type" : "apple", "description" : "Apples come in several varieties, including Fuji, Granny Smith, and Honeycrisp." }
{ "_id" : 2, "type" : "banana", "description" : "Bananas are usually sold in bunches of five or six." }

Distributed Transaction

MongoDB 4.0 支持副本集事务，极大的丰富了应用场景；4.0 的事务存在最大修改 16MB、事务执行时间不能过长的限制，在 4.2 支持分布式事务的这些问题都解决了。分布式事务的支持也意味用户修改分片key的内容成为可能，因为修改分片key的内容，可能会导致key要迁移到其他shard，而在4.2之前，无法保证这个迁移动作（目标上新写、源上删掉）的原子性，而借助分布式事务，这个问题也就迎刃而解。

4.2 支持的分布式事务是硬核技术，目前具备这个能力的开源数据库本身也不多，MongoDB 采用二阶段提交的方式（细节以后再分析），实现在多个 Shard 间发生的修改，要么同时发生，要么都不发生，保证事务的 ACID 特性。

在使用上，4.2 的分布式事务跟 4.0 副本集事务使用方式完全一样，用户无需关心后端数据如何分布。

High Availablity

MongoDB 在保证数据库服务可用性方面持续努力，在 4.0 提供了 
Retryable Write
 功能，在新的 4.2 版本，MongoDB 增加了 
Retryable Read
 功能，对于一些临时的网络问题，用户无需自己实现重试逻辑，MongoDB 会自动重试处理，保证用户业务的连续性。

Improved Query Language

MongoDB 4.2 在查询语言的表达能力上进一步增强，update、aggregation、index 等方面都有巨大的提升，具体细节等 4.2 正式版文档发出可以详细了解。

Update 能力增强

4.2 之前，Update 操作基本上都是用确定的值更新某个字段，在新版本里，Update 能根据文档现有的字段内容来生成新的更新内容，如下的实例，根据文档 pay、tax 字段，加起来生成一个 total 字段；这个在 4.2 之前，用户需要先读取文档内容，获取 pay、tax 字段得到结果，然后调用 Update 设置新的字段。类似的特性还有很多，基本上 Aggregation 里能表达的更新操作，4.2 的 Update 命令都能支持。

db.orders.find()
{ "_id" : 1, "pay" : 100, "tax" : 17 }

// 这个操作发布会PPT上有写，但实际连 4.2 测试并不能工作，等正式版出来再看看
db.orders.update( {_id: 1}, 
    { "$set": {  
        "total": { "$sum": ["$pay", "$tax"]    }   
        }     
})

分析能力增强

Aggregation 方面，MongoDB 也做了大量的改进，来更好的支持业务分析场景；比如增加 $merge 操作符，能不断的将增量分析结果与原来的结果进行汇总（老的版本只支持 $out，把当次分析结果写到某个集合）。

Index 能力增强（Wildcard Index）

使用 MongoDB 时，经常会遇到一些场景，某个字段包含很多个属性，很多属性都可能需要用于查询，现在的解决方案时，针对每个属性，必须提前知道它的访问行为，建立必要的索引；MongoDB 4.2 引入 
Wildcard Index
，可以针对一系列的字段自动建索引，满足丰富的查询需求。

如下面的例子所示，书籍的 attribute 字段里包含很多熟悉，包括颜色、大小等信息，如果经常需要根据属性查找，可以针对 attribute 字段建立 Wildcard index。

db.books.find()
{ "_id" : ObjectId("5d0c5d931eefdf585ae9ca95"), "type" : "book", "title" : "The Red Book", "attributes" : { "color" : "red", "size" : "large", "inside" : { "bookmark" : 1, "postitnote" : 2 }, "outside" : { "dustcover" : "worn" } } }
{ "_id" : ObjectId("5d0c5d9e1eefdf585ae9ca96"), "type" : "book", "title" : "The Blue Book", "attributes" : { "color" : "blue", "size" : "small", "inside" : { "map" : 1 }, "outside" : { "librarystamp" : "Local Library" } } }
{ "_id" : ObjectId("5d0c5dac1eefdf585ae9ca97"), "type" : "book", "title" : "The Green Book", "attributes" : { "color" : "green", "size" : "small", "inside" : { "map" : 1, "bookmark" : 2 }, "outside" : { "librarystamp" : "Faraway Library", "dustcover" : "good" } } }

// 没有索引的时候，根据颜色属性查找，走全表扫描
db.books.find({"attributes.color": "green"}).explain()
{
	"queryPlanner" : {
		"queryHash" : "528C4C03",
		"planCacheKey" : "528C4C03",
		"winningPlan" : {
			"stage" : "COLLSCAN",
}

// 针对 attributes 字段所有的子字段建立 Wildcard 索引，针对 color、size 等的查询就都可以走索引
db.books.createIndex({ "attributes.$**": 1 });

db.books.find({"attributes.color": "green"}).explain()
{
	"queryPlanner" : {
		"winningPlan" : {
			"stage" : "FETCH",
			"inputStage" : {
				"stage" : "IXSCAN",
}
db.books.find({"attributes.size": "small"}).explain()
{
	"queryPlanner" : {
		"winningPlan" : {
			"stage" : "FETCH",
			"inputStage" : {
				"stage" : "IXSCAN",
}

Field Level Encrytion

MongoDB 除了支持 SSL、TDE 等安全机制，在 4.2 引入「字段级加密」的支持，实现对用户JSON文档的Value 进行自动加密。整个过程在 Driver 层完成，传输、存储到服务端的文档Value都是密文，MongoDB 4.2 Drvier 支持丰富的加密策略，可以针对集合、字段维度开启加密，加密过程对开发者完全透明。

MongoDB and Kubernetes

Kubernetes 是工业级的容器编排管理平台，可以使用 Kubernetes 管理 MongoDB 集群的整个生命周期，但随着业务部署环境越来越复杂多样化，有的可能是私有云部署、有的是公有云的部署，使得集群的管理难度也越来越高。

在新版本 MongoDB Atlas（公有云）, MongoDB Cloud Manager（私有云企业版管理） 都集成了 Kubernetes operators 的支持，使得用户可以使用 Kubernetes 统一管理 MongoDB 资源。

MongoDB Chart

MongoDB Chart 在去年的 MongoDB World 已经介绍过了，今年有做了多方面的增强，算得上是一个功能比较完备的 BI 分析工具了。有了 Charts，MongoDB 也无需支持 SQL 来去对接 BI 工具了。

Charts 在使用上还是有一定学习成本的，不是特别直观，需要配合教程，了解下运作原理，才能得到想要的图，比如这个例子里，针对电影集合，Released 的年份做了聚合分析，得到分布图。

MongoDB Realm

MongoDB 在4月份的时候收购了 Realm，一个为移动端开发而设计的新型数据库。MongoDB 去年发布了 MongoDB Mobile 来应对移动端的数据存储需求，在收购 Realm 后，二者会进行深度整合，Real Core 里会借助MongoDB提供的能力，增加非结构化数据存储到能力，比如 JSON、Dict、Set，让 Realm 变得更强大，同时发挥 Realm 在移动端生态以及 MongoDB 数据库存储的优势。

Atlas Data Lake (Beta)

在新版本 Atlas 服务里，提供了 Atlas Data Lake，能直接通过 MongoDB API 访问存储在 AWS S3 (未来支持 Azure、Google 的存储服务）里的数据。

  

    

		

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
