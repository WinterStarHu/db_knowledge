# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2019/10/07/
> 分类: performance/tuning

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
	

  

    
数据库内核月报 － 2019 / 10

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 引擎特性 · Innodb 表空间
                      

                    

                    

                  
                      

                        MySQL · 引擎特性 · POLARDB 并行查询加速全程详解
                      

                    

                    

                  
                      

                        MySQL · Optimizer · Parallel Index Scans, One is Better Than Two
                      

                    

                    

                  
                      

                        MySQL · 最佳实践 · X-Engine MySQL RDS 用户的新选择
                      

                    

                    

                  
                      

                        MySQL · 引擎特性 · Sequence Engine
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · 分组提交的使用与注意
                      

                    

                    

                  
                      

                        MongoDB · 最佳实践 · Spark Connector 实战指南
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · PG 12 tpcc - use sysbench-tpcc by Percona-Lab
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 ·  阿里云RDS PG 11开放dblink, postgres_fdw权限
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · Oracle 20c 新特性 - 翻出了PG十年前的特性
                      

                    

 
        

    

  

    
 MongoDB · 最佳实践 · Spark Connector 实战指南  

    
 Author: linqing  

  

  

  
Why Spark with MongoDB?

  
高性能，官方号称 100x faster，因为可以全内存运行，性能提升肯定是很明显的

  
简单易用，支持 Java、Python、Scala、SQL 等多种语言，使得构建分析应用非常简单

  
统一构建	，支持多种数据源，通过 Spark RDD 屏蔽底层数据差异，同一个分析应用可运行于不同的数据源；

  
应用场景广泛，能同时支持批处理以及流式处理

MongoDB Spark Connector 为官方推出，用于适配 Spark 操作 MongoDB 数据；本文以 Python 为例，介绍 MongoDB Spark Connector 的使用，帮助你基于 MongoDB 构建第一个分析应用。

准备 MongoDB 环境

安装 MongoDB 参考 
Install MongoDB Community Edition on Linux

mkdir mongodata
mongod --dbpath mongodata --port 9555

准备 Spark python 环境

参考 
PySpark - Quick Guide

下载 Spark

cd /home/mongo-spark
wget http://mirrors.tuna.tsinghua.edu.cn/apache/spark/spark-2.4.4/spark-2.4.4-bin-hadoop2.7.tgz
tar zxvf spark-2.4.4-bin-hadoop2.7.tgz

设置 Spark 环境变量

export SPARK_HOME=/home/mongo-spark/spark-2.4.4-bin-hadoop2.7
export PATH=$PATH:/home/mongo-spark/spark-2.4.4-bin-hadoop2.7/bin
export PYTHONPATH=$SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-0.10.4-src.zip:$PYTHONPATH
export PATH=$SPARK_HOME/python:$PATH

运行 Spark RDD 示例

# count.py
from pyspark import SparkContext
sc = SparkContext("local", "count app")
words = sc.parallelize (
   ["scala", 
   "java", 
   "hadoop", 
   "spark", 
   "akka",
   "spark vs hadoop", 
   "pyspark",
   "pyspark and spark"]
)
counts = words.count()

$SPARK_HOME/bin/spark-submit count.py
Number of elements in RDD → 8  

如果上述程序运行成功，说明 Spark python 环境准备成功，还可以测试 Spark 的其他 RDD 操作，比如 collector、filter、map、reduce、join 等，更多示例参考 
PySpark - Quick Guide

Spark 操作 MongoDB 数据

参考 
Spark Connector Python Guide

准备测试数据 test.coll01 插入3条测试数据，test.coll02 未空

mongo --port 9555

> db.coll01.find()
{ "_id" : 1, "type" : "apple", "qty" : 5 }
{ "_id" : 2, "type" : "orange", "qty" : 10 }
{ "_id" : 3, "type" : "banana", "qty" : 15 }
> db.coll02.find()

准备操作脚本，将输入集合的数据按条件进行过滤，写到输出集合

# mongo-spark-test.py
from pyspark.sql import SparkSession

# Create Spark Session

spark = SparkSession \
    .builder \
    .appName("myApp") \
    .config("spark.mongodb.input.uri", "mongodb://127.0.0.1:9555/test.coll01") \
    .config("spark.mongodb.output.uri", "mongodb://127.0.0.1:9555/test.coll") \
    .getOrCreate()

# Read from MongoDB
df = spark.read.format("mongo").load()
df.show()

# Filter and Write
df.filter(df['qty'] >= 10).write.format("mongo").mode("append").save()    

# Use SQL 
# df.createOrReplaceTempView("temp")
# some_fruit = spark.sql("SELECT type, qty FROM temp WHERE type LIKE '%e%'")
# some_fruit.show()

运行脚本

$SPARK_HOME/bin/spark-submit --packages org.mongodb.spark:mongo-spark-connector_2.11:2.4.1 mongo-spark-test.py

mongo --port 9555

> db.coll02.find()
{ "_id" : 2, "qty" : 10, "type" : "orange" }
{ "_id" : 3, "qty" : 15, "type" : "banana" }

  

    

		

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
