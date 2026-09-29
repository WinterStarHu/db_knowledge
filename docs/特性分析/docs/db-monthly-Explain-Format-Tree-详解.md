# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2021/02/01/
> 分类: 特性分析

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
	

  

    
数据库内核月报 － 2021 / 02

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        PolarDB ·  特性分析 · Explain Format Tree 详解
                      

                    

                    

                  
                      

                        MySQL · 源码阅读 · InnoDB Export/Import Tablespace解析
                      

                    

                    

                  
                      

                        MySQL · 源码解析 · MySQL 8.0.23 Hypergraph Join Optimizer代码详解
                      

                    

                    

                  
                      

                        MySQL · 性能优化 · InnoDB 事务 sharded 锁系统优化
                      

                    

                    

                  
                      

                        DataBase · 社区动态 · 数据库中的表达式
                      

                    

                    

                  
                      

                        MySQL · 源码分析 · Group by优化逻辑代码分析
                      

                    

                    

                  
                      

                        MySQL · 源码阅读 · X-plugin的传输协议
                      

                    

                    

                  
                      

                        MySQL · 源码阅读 · MySQL8.0 innodb锁相关
                      

                    

                    

                  
                      

                        PolarDB · 优化改进 · 使用窗口聚合函数来将子查询解关联
                      

                    

 
        

    

  

    
 PolarDB ·  特性分析 · Explain Format Tree 详解  

    
 Author: xuanxu  

  

  

  
前言

Mysql从8.0.18引入了Explain Format Tree的功能，PolarDB-2.0也支持了该功能。 本篇，我们来详细介绍下Explain Format Tree功能，以及Parallel Query对该功能的支持和变化。

Mysql Explain Format Tree 执行计划

Explain Format Tree依赖的是mysql新引入的iterator tree格式的执行计划。通过递归遍历iterator tree来完成Format Tree格式的执行计划的展示。
Iterator的组织形式的树形的，通常的Iterator都只有一个children（JOIN iterator有两个，分别是JOIN的外表和内表），所有在递归遍历过程中直接访问的Iterator都是RowIterator的子类。

下面是一个Explain Format Tree的例子和解读：

mysql> explain format=tree select a1, a3, sum(b2) sum from t1 join t2 where t1.a1 = t2.b2 and t2.b1 > 0 group by a1,a3 order by sum limit 10\G
*************************** 1. row ***************************
EXPLAIN: -> Limit: 10 row(s)
    -> Sort: <temporary>.sum, limit input to 10 row(s) per chunk
        -> Table scan on <temporary>
            -> Aggregate using temporary table
                -> Nested loop inner join  (cost=9301.16 rows=8737)
                    -> Filter: (t2.b1 > 0)  (cost=51.95 rows=171)
                        -> Table scan on t2  (cost=51.95 rows=512)
                    -> Filter: (t1.a1 = t2.b2)  (cost=3.03 rows=51)
                        -> Table scan on t1  (cost=3.03 rows=512)

上面是一个典型的Mysql查询，包含了join， group by, order by 和 limit
通过上面的计划我们可以知道整个SQL的执行过程是

  
对t2表进行scan和过滤，t2是驱动表

  
将结果和t1表进行nest loop join，join条件是 t1.a1 = t2.b2

  
对join的结果进行聚集计算，计算的通过临时表进行的，聚集结果也保存在临时表中

  
对临时表的内容进行排序

  
对排序结果limit 10输出

这个例子的Iterator Tree的样子是：

LimitOffsetIterator
|-> SortingIterator
    |-> TableScanIterator
        |-> TemptableAggregateIterator
            |-> NestLoopIterator
                |-> FilterIterator
                |   |-> TableScanIterator
                |-> FilterIterator
                    |-> TableScanIterator
              

可以看出结构和format tree的输出是完全一样的。

Iterator基本结构和组织方式

RowIterator是所有Iterator的基类，下面列出了explain相关的主要成员和方法：

class RowIterator {
public:
  struct Child {
  RowIterator *iterator;
  std::string description;
  };
  virtual std::vector<Child> children() const { return std::vector<Child>(); }   // 返回iterator的children list，在递归中使用
  virtual std::vector<std::string> DebugString() = 0；   // 输出Iterator的计划信息，不同的Iterator会有各自的实现
  JOIN *join_for_explain() const { return m_join_for_explain; }   // 如果是join的root_iterator会返回join的指针，用来遍历join上的子查询并输出子查询的查询计划。

private：
  double m_estimated_cost = -1.0;     // Iterator执行完成预期的代价
  double m_expected_rows = -1.0;      // Iterator输出的行数
};

RowIterator::children

返回当前iterator的children list，包装结构为Child，部分Iterator在实现该方法时除了返回childrend iterator的指针以外，还返回了description。
例如：

mysql> explain format=tree select * from t1 join t2 on a1=b1 \G
*************************** 1. row ***************************
EXPLAIN: -> Inner hash join (t2.b1 = t1.a1)  (cost=26269.36 rows=26214)
    -> Table scan on t2  (cost=0.01 rows=512)
    -> Hash
        -> Table scan on t1  (cost=54.20 rows=512)

Iterator tree的结构如下：

HashJoinIterator
  --> TableScanIterator    // t2, probe side
  --> TableScanIterator    // t1, build side

HashJoinIterator的children方法返回的内容如下：

{<TableScanIterator(t2), null>,
<TableScanIterator(t1), "Hash">}

其中Hash是description， 这里表示对t1表build hash然后再去join t2表。

RowIterator::DebugString()

产生Iterator的格式化字符串， 每个Iterator都有自己的实现，主要是描述Iterator的行为，包括Table Scan的方式， 过滤的Condition，Join method等等， 通常都是一行。

Explain Format Tree 介绍

执行过程

Explain

- handle_query()
  - SELECT_LEX_UNIT::optimize()
    - SELECT_LEX::optimize()
      - JOIN::optimize()
        - JOIN::create_iterators()          // 创建join的iterators
          - JOIN::create_table_iterators()
          - JOIN::create_root_iterator_for_join()
          - JOIN::attach_iterators_for_having_and_limit()      
    - SELECT_LEX_UNIT::create_iterators()   // 创建union的iterators
  - explain_query()
    - ExplainIterator()     // 如果explain_format = tree，调用此接口输出执行计划
      - PrintQueryPlan()    // 将iterator的信息格式化为tree格式的执行计划字符串，该接口会对iteratortree进行递归
        - FullDebugString（） // 生成iterator的计划信息
        

PrintQueryPlan()

std::string PrintQueryPlan(int level, RowIterator *iterator) {                       
  string ret;                                                                        
                                                                                     
  if (iterator == nullptr) {                                                         
    ret.assign(level * 4, ' ');                                                      
    return ret + "<not executable by iterator executor>\n";                          
  }                                                                                  
                                                                                     
  int top_level = level;   // 当前缩进level， 每个level缩进4个空格                                                         
                                                                                     
  // 输出自身的计划信息
  for (const string &str : FullDebugString(current_thd, *iterator)) {                
    ret.append(level * 4, ' ');                                                      
    ret += "-> ";                                                                    
    ret += str;                                                                      
    ret += "\n";                                                                     
    ++level;                                                                         
  }                                                                                  
              
  // 遍历所有的children iterator， 递归输出计划信息                                                                   
  for (const RowIterator::Child &child : iterator->children()) {                 
    if (!child.description.empty()) {                                            
      ret.append(level * 4, ' ');                                                
      ret.append("-> ");                                                         
      ret.append(child.description);                                             
      ret.append("\n");                                                          
      ret += PrintQueryPlan(level + 1, child.iterator);                          
    } else {                                                                     
      ret += PrintQueryPlan(level, child.iterator);                              
    }                                                                            
  }
  
  //                                                                               
  if (iterator->join_for_explain() != nullptr) {                                 
    for (const auto &child :                                                     
         GetIteratorsFromSelectList(iterator->join_for_explain())) {             
      ret.append(top_level * 4, ' ');                                            
      ret.append("-> ");                                                         
      ret.append(child.description);                                             
      ret.append("\n");                                                          
      ret += PrintQueryPlan(top_level + 1, child.iterator);                      
    }                                                                            
  }                                                                              
  return ret;                                                                    
}

FullDebugString()

通过本方法输出一个iterator的完整的计划信息，包括iterator本身的信息，cost信息和执行信息

vector<string> FullDebugString(const THD *thd, const RowIterator &iterator) {    
  vector<string> ret = iterator.DebugString();           // 生成iterator的计划信息                            
  if (iterator.expected_rows() >= 0.0) {                 // 生成cost info                            
    // NOTE: We cannot use %f, since MSVC and GCC round 0.5 in different             
    // directions, so tests would not be reproducible between platforms.             
    // Format/round using my_gcvt() and llrint() instead.                            
    char cost_as_string[FLOATING_POINT_BUFFER];                                      
    my_fcvt(iterator.estimated_cost(), 2, cost_as_string, /*error=*/nullptr);    
    char str[512];                                                                   
    snprintf(str, sizeof(str), "  (cost=%s rows=%lld)", cost_as_string,              
             llrint(iterator.expected_rows()));                                      
    ret.back() += str;                                                               
  }                                                                                  
  if (thd->lex->is_explain_analyze) {                    // 生成执行信息                             
    if (iterator.expected_rows() < 0.0) {                                            
      // We always want a double space between the iterator name and the costs.                                                                                                                                                        
      ret.back().push_back(' ');                                                 
    }                                                                                
    ret.back().push_back(' ');                                                       
    ret.back() += iterator.TimingString();                                           
  }                                                                                  
  return ret;                                                                        
}          

Parallel Query 中 Explain Format Tree 的变化

PolarDB的Parallel Query功能引入了新的exchange算子， 同时多阶段并行计划在生成计划的过程中是基于Cost选择的最优计划，我们对Parallel Query计划Format Tree的输出信息进行了完善和补充， 下面是Parallel Query计划的Explain Format Tree的一个简单例子。

mysql> explain format=tree select a1, a3, sum(b2) sum from t1 join t2 where t1.a1 = t2.b2 and t2.b1 > 0 group by a1,a3 order by sum limit 10\G                                                                                         
*************************** 1. row ***************************
EXPLAIN: -> Limit: 10 row(s)  (cost=2825.63 rows=10)
    -> Sort: <temporary>.sum, limit input to 10 row(s) per chunk  (cost=2825.63 rows=51)
        -> Stream results
            -> Gather (slice: 1; workers: 4)  (cost=2815.55 rows=51)
                -> Table scan on <temporary>
                    -> Aggregate using temporary table  (cost=2802.35 rows=13)
                        -> Nested loop inner join  (cost=2363.21 rows=2184)
                            -> Repartition (hash keys: t2.b2; slice: 2; workers: 2)  (cost=50.91 rows=43)
                                -> Filter: (t2.b1 > 0)  (cost=25.97 rows=85)
                                    -> Parallel table scan on t2, with parallel partitions: 2  (cost=25.97 rows=256)
                            -> Filter: (t1.a1 = t2.b2)  (cost=3.12 rows=51)
                                -> Table scan on t1  (cost=3.12 rows=512)

从上面的计划可以看出相对于Mysql原版计划，parallel query的计划作出了下面的变化

  
对 group by/ distinct / order by / window / limit iterator增加了代价显示的支持

  
新增了exchange算子和exchange算子详细信息的显示，包括算子类型（gather/repartition/nroadcast）， slice id， parallel worker number。 对于repartition的exchange算子，同时还显示了repartition column。

附录

Iterator List

RowIterator <|--- TimingIterator
               |- UnqualifiedCountIterator
               |- FakeSingleRowIterator
               |- ZeroRowsIterator
               |- ZeroRowsAggregatedIterator
               |- FollowTailIterator
               |- FilterIterator
               |- LimitOffsetIterator
               |- AggregateIterator
               |- PrecomputedAggregateIterator
               |- NestedLoopIterator
               |- CacheInvalidatorIterator
               |- WeedoutIterator
               |- RemoveDuplicatesIterator
               |- NestedLoopSemiJoinWithDuplicateRemovalIterator
               |- WindowingIterator
               |- BufferingWindowingIterator
               |- MaterializeInformationSchemaTableIterator
               |- AppendIterator
               |- HashJoinIterator
               |- SortingIterator
               |- TableRowIterator <|--- TableScanIterator
                                      |- IndexScanIterator
                                      |- IndexRangeScanIterator
                                      |- SortBufferIterator
                                      |- SortBufferIndirectIterator
                                      |- SortFileIterator
                                      |- SortFileIndirectIterator
                                      |- MaterializeIterator
                                      |- StreamingIterator
                                      |- TemptableAggregateIterator
                                      |- MaterializedTableFunctionIterator
                                      |- RefIterator
                                      |- RefOrNullIterator
                                      |- EQRefIterator
                                      |- ConstIterator
                                      |- FullTextSearchIterator
                                      |- DynamicRangeIterator
                                      |- PushedJoinRefIterator
                                      |- AlternativeIterator
                                      

注：文中引用代码是基于mysql-8.0.20版本的。

  

    

		

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
