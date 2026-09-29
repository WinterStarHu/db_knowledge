# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2023/03/03/
> 分类: 

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
	

  

    
数据库内核月报 － 2023 / 03

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        PolarDB auto_inc 场景性能优化之路
                      

                    

                    

                  
                      

                        PolarDB MySQL · 持续补强的全局二级索引
                      

                    

                    

                  
                      

                        PolarDB for MySQL 优化器查询变换系列 - 条件下推
                      

                    

                    

                  
                      

                        MySQL · 参数故事 · max_prepared_stmt_count
                      

                    

 
        

    

  

    
 PolarDB for MySQL 优化器查询变换系列 - 条件下推  

    
 Author: xiaozhuo  

  

  

  
背景

条件下推是数据库优化器查询变换中的一个重要规则，目的在于将上层查询的条件尽可能多的下推到下层，使得查询任务在尽可能早的阶段对数据进行过滤，从而减少后续查询计算的代价，大幅提升查询性能。

条件下推到derived table

基于以上目的，MySQL 8.0.22及之后的版本支持将条件下推到派生表(derived table)，当派生表不能合并到外部查询时(例如，如果派生表使用聚合)，将外部WHERE条件下推到派生表中应该会减少需要处理的行数，从而加快查询的执行速度。示例如下:

    SELECT i, j
    FROM (
	        SELECT i
	        FROM t1
	        GROUP BY i
        ) dt, t2
    WHERE i > 2
	    AND j < 3;

    ====变换后====>

    SELECT i, j
    FROM (
            SELECT i
            FROM t1
            WHERE i > 2
            GROUP BY i
        ) dt
    WHERE j < 3;

Mysql社区版本的实现原理是prepare阶段，在所有的变换完成之后，由外向内，层层递归，判断当前block中 WHERE Clause的条件是否可以下推或者部分下推到任一个物化派生表。具体代码逻辑如下：

  -> SELECT_LEX::prepare
     -> push_conditions_to_derived_tables()
        -> 循环每一个物化表处理 WHERE condition
           -> make_cond_for_derived() // 生成可以下推到派生表的条件
              ->extract_cond_for_table() //提取和当前只和派生表相关的条件
              - push_past_window_functions（）//生成推到派生表HAVING Clause的条件
              - push_past_group_by（）//生成推到派生表 WHERER Clause的条件
              - make_remainder_cond() //生成下推之后剩余的条件
        -> 自顶向下，产生的下推条件可以被下推到嵌套在派生表内部派生表
           ->push_conditions_to_derived_tables() //递归

MySQL 8.0.29及以后的版本支持派生表条件下推优化可以用于UNION查询,虽然放开了对物化表是union的限制，但增加了以下限制:

  
如果UNION中的任何物化派生表是递归公共表表达式

  
不能将包含不确定性表达式的条件下推到派生表

PolarDB 版本的条件下推

条件下推到derived table增强版

基于用户复杂的查询场景，我们发现数据库需要更加强大的下推能力来加速用户查询。因此PolarDB基于MySQL 8.0.2, 对原有的条件下推实现进行了较大的改造，实现了更加完善和强大的下推能力，主要包括:

  
(1)考虑等值条件的传递 
(2)下推到派生表是union的情况
(3)下推后的条件可进一步基于等价关系级联下推

(1) 包含等值条件传递的条件下推

MySQL社区版本在检查条件下推时并没有考虑条件等值传递的影响。实际上，如果某一列满足条件下推的判断，其等价列也应该满足条件下推的判断，进而下推更多的条件，更大可能的减少中间数据和后续计算代价。同时，为了尽可能多的考虑等价条件的影响，PolarDB 将保留当前层的where 条件而不去移除已经下推的条件。相比较于filter的代价，更多的下推的可能性将带来更大的性能收益。例如，考虑如下的查询场景：

       SELECT *
       FROM t1, (
                  SELECT x
                  FROM t2
                  GROUP BY x
               ) d_tab, t2
       WHERE t1.a = d_tab.x
               AND t1.a > 6;
    
       ====变换后====>
    
      SELECT *
        FROM t1, (
                   SELECT x
                   FROM t2
                   WHERE x > 6
                   GROUP BY x
                ) d_tab
        WHERE t1.a = d_tab.x
                AND t1.a > 6;

虽然对于t1.a > 6条件，t1.a列并不依赖于派生表d_tab，但由于t1.a = d_tab.x的等值条件，我们可以推导出t1.a > 6条件是可以下推到derived table的，且按照映射关系转换为条件x > 6对物化表d_tab进行数据过滤，减少数据量的同时也减少了物化代价后后续数据的计算代价。当用户场景中的数据量大且条件过滤性好时，对于整个查询的性能提升十分明显。

(2) 条件下推到派生表是union的情况

MySQL社区版本起初由于实现限制，并没有实现条件下推到派生表是union的情况。PolarDB版本解除了这一限制。对于derived table是union的情况，根据union中并列的每个子query block的情况，依次将可下推的条件下推到部分符合的query block中。

    SELECT f1
    FROM (
	    SELECT (
		    	SELECT f1
		    	FROM t1
		    	LIMIT 1
		    ) AS f1
	    FROM t1
	    UNION
	    SELECT f2
	    FROM t2
    ) dt
    WHERE f1 = 1;

    ====变换后====>

    SELECT f1
    FROM (
	    SELECT (
		    	SELECT f1
		    	FROM t1
		    	LIMIT 1
		    ) AS f1
	    FROM t1
	    UNION
	    SELECT f2
	    FROM t2
	    WHERE f2 = 1
    ) dt
    WHERE f1 = 1

在上面的sql中，对于derived table是两个select的union，分别判断where 条件f1=1是否可以下推。 对于SELECT#1有LIMIT，条件下推之后将影响结果的行数，因此不可以下推到SELECT#1；而检查SELECT#2则满足下推的检查，因此最终f1=1可以下推到SELECT#2的WHERER Clause上并映射为f2 = 1。

MySQL 8.0.29及以后的版本支持的下推到UNION时优化是union的某个子SELECT不支持下推则该条件不能下推到该union的所有子SELECT，相比较而言，PolarDB支持下推到部分的UNION，在保证语义正确的前提下，更大限度的支持条件下推。

(3)下推后的条件可进一步基于等价关系级联下推

PolarDB还增加了对于当前query block 将符合条件的位于HACVING Clause上的条件下推至WHERER Clause。这样可以在结果进行group by操作之前对数据进行过滤，减少后续计算代价，极大提高查询性能。

在条件下推到派生表的过程中，我们仅仅将可以下推的条件应该放到派生表的 HAVING Clause，进而考虑
下推到HAVING Clause的
条件是否可以继续下推到派生表的WHERE Clause。为了更大限度的在更早的时期对数据进行过滤，PolarDB在条件下推的变换中，增加了检查每个query block中所有HAVING CALUZE 上的条件是否可以下推到WHRER Clause的检查。同时，在这个过程中也考虑等值条件传递，衔接条件下推到派生表的逻辑，进而尽可能将条件层层下推到内层query block。举例如下：

    SELECT t1.a, MAX(t1.b)
    FROM t1
    GROUP BY t1.a
    HAVING t1.a > 2
    AND MAX(c) > 12;

    ====变换后===>

    SELECT t1.a, MAX(t1.b)
    FROM t1
    WHERE t1.a > 2
    GROUP BY t1.a
    HAVING MAX(c) > 12;

为此，PolarDB在考虑where 条件下推到derived table之前先进行HAVING 条件是否可以下推到 WHERE 条件。并且自外向内地对每个query block依次检查是否可以条件下推，进而将可以下推的条件尽可能下到最内层。示例如下：

   SELECT *
   FROM (
	   SELECT f1, f2
	   FROM t1
   ) dt
   GROUP BY f1
   HAVING f1 < 3
   AND f2 > 11
   AND MAX(f3) > 12;

   ====变换后===>

   SELECT *
   FROM (
	   SELECT f1, f2
	   FROM t1
	   WHERE f1 < 3
   ) dt
   WHERE f1 < 3
   GROUP BY f1
   HAVING f2 > 11
   AND MAX(f3) > 12;

总结

PolarDB建立了完善的条件下推变换逻辑，在下推检查的过程中增加了对等值条件的考虑。同时，为了尽可能多的利用条件之间的传递关系，条件下推到新的query block之后，原来的query block仍然保留下推下去的条件，以便在后续优化中更多的利用过滤条件。PolarDB后续会按照论文“
Query Optimization by Predicate Move-Around
”提出的谓词下推算法演进，进一步增强PolarDB的谓词下推能力。

  

    

		

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
