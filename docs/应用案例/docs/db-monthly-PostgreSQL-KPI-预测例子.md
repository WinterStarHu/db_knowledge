# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2019/05/10/
> 分类: 应用案例

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
	

  

    
数据库内核月报 － 2019 / 05

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MSSQL · 最佳实践 · 挑战云计算安全的存储过程
                      

                    

                    

                  
                      

                        MySQL · 源码分析 · 聚合函数（Aggregate Function）的实现过程
                      

                    

                    

                  
                      

                        PgSQL · 最佳实践 · RDS for PostgreSQL 的逻辑订阅
                      

                    

                    

                  
                      

                        MySQL · 引擎特性 · 通过 SQL 管理 UNDO TABLESPACE
                      

                    

                    

                  
                      

                        MySQL · 最佳实践 · 通过Resource Group来控制线程计算资源
                      

                    

                    

                  
                      

                        MySQL · 引擎特性 · Skip Scan Range
                      

                    

                    

                  
                      

                        MongoDB · 应用案例 · killOp 案例详解
                      

                    

                    

                  
                      

                        MySQL · 源码分析 · LinkBuf设计与实现
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · PostgreSQL KPI分解，目标设定之 - 等比数列
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · PostgreSQL KPI 预测例子
                      

                    

 
        

    

  

    
 PgSQL · 应用案例 · PostgreSQL KPI 预测例子  

    
 Author: digoal  

  

  

  
背景

预测营收目标，预测KPI风险。使用PostgreSQL二维线性回归，更高级一点可以使用MADLIB多维线性回归。

预测方法：

例如有最近连续4周的营收数据，预测第一季度，第二季度，第三季度，第四季度的营收。

例如设定了财年的营收目标，有最近连续四周的营收完成比率，预测第一季度，第二季度，第三季度，第四季度的营收完成率。

公式：

自变量，第N周的数据  
  
因变量，第N+1周的数据  
  
src = array[第N周数据，第N+1周数据，...，第N+x周数据];  
  
  select   
  regr_slope(y,x),   -- 斜率  
  regr_intercept(y,x)   -- 截距  
  from (  
    select src[xx] x, src[xx+1] y from generate_series(1, array_length(src, 1)-1) xx  
  ) as t;  
  
预测第N+x+1周数据 = 第N+x周数据 * 斜率 + 截距  

例子

假设设定今年要完成100亿的营收目标，有如下连续4周的营收完成情况

时间 | 财年目标 | 完成营收 | 完成比例  
---|---|---|---  
20190422 | 100亿 | xxx | 3.9%   
20190415 | 100亿 | xxx | 2.7%   
20190408 | 100亿 | xxx | 1.6%   
20190401 | 100亿 | xxx | 0.49%   

财年的Q1，Q2，Q3，Q4时间点如下

  d1 date := '20190630';   
  d2 date := '20190930';   
  d3 date := '20191231';   
  d4 date := '20200331';   

预测财年每个Q的完成比例。

do language plpgsql $$  
declare  
  -- 录入连续4周的完成比率，一定要按顺序  
  src float8[] := array[0.49, 1.6, 2.7, 3.9];   
    
  -- 连续四周的最后一周的时间点  
  d0 date := '20190422';   
    
  -- 四个Q的时间节点  
  d1 date := '20190630';   
  d2 date := '20190930';   
  d3 date := '20191231';   
  d4 date := '20200331';   
    
  -- 四个Q离连续四周的最后一周的时间点的间隔周数  
  q1 int := round((d1-d0)/7, 0);   
  q2 int := round((d2-d0)/7, 0);   
  q3 int := round((d3-d0)/7, 0);   
  q4 int := round((d4-d0)/7, 0);   
    
  -- 斜率  
  slope float8;   
  -- 截距  
  intercept float8;   
    
  -- 每一次预测的下一个预测数，因变量数组  
  prev float8[];   
    
  -- 因变量数组的下标，从2开始动态计算  
  i int := 2;   
    
  -- 包含源数据、所有预测数据的大数组，作为每一次预测的源  
  tmp float8[];   
  
begin  
  -- 第一次预测，计算斜率、截距  
  select regr_slope(y,x), regr_intercept(y,x) into slope,intercept from (  
    select src[xx] x, src[xx+1] y from generate_series(1, array_length(src, 1)-1) xx  
  ) as t;  
  
  -- raise notice '%,%', slope, intercept;  
    
  -- 第一个预测到的因变量  
  prev[1] := round((src[array_length(src,1)]*slope + intercept)::numeric, 2);  
  -- raise notice '%,%', prev, src;  
  
loop  
  -- 将预测到的因变量数组追加到原始数组，生成tmp  
  tmp := array_cat(src, prev);  
  -- raise notice '%', tmp;  
  -- 使用tmp，计算截距、斜率  
  select regr_slope(y,x),regr_intercept(y,x) into slope,intercept from (  
    select tmp[xx] x, tmp[xx+1] y from generate_series(1, array_length(tmp, 1)-1) xx  
  ) as t;  
  
  -- 那截距、斜率计算因变量  
  prev[i] := round(((prev[i-1])*slope + intercept)::numeric, 2);  
  -- raise notice '%,%', prev, src;  
    
  -- 遇到关键节点，抛出对应预测数据  
  case i   
    when q1 then raise notice 'q1: %', prev[i];  
    when q2 then raise notice 'q2: %', prev[i];  
    when q3 then raise notice 'q3: %', prev[i];  
    when q4 then raise notice 'q4: %', prev[i];  
  else  
    null;  
  end case;  
    
  -- 到达Q4最后一天的周数，退出循环  
  exit when i=q4;  
    
  -- 周数累加  
  i := i+1;  
end loop;  
    
end;  
$$;  

结果

NOTICE:  q1: 16.93  
NOTICE:  q2: 49.17  
NOTICE:  q3: 100.18  
NOTICE:  q4: 185.56  
DO  

预测数据还不错。

预测数据说明

此预测方法为线性预测，在加速上升期的产品，实际曲线是斜率越来越大的，所以预测期越远的预测数值可能会越低于实际数值。

处于放缓上升速度的上升期的产品，实际曲线的斜率是越来越小的，所以预测期越远的预测数值可能会远大于实际数值。

参考

《PostgreSQL 多元线性回归 - 2 股票预测》

《在PostgreSQL中用线性回归分析(linear regression) - 实现数据预测》

《PostgreSQL 线性回归 - 股价预测 1》

《在PostgreSQL中用线性回归分析linear regression做预测 - 例子2, 预测未来数日某股收盘价》

  

    

		

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
