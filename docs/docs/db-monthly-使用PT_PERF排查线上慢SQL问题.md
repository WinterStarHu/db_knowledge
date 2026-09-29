# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2024/07/04/
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
	

  

    
数据库内核月报 － 2024 / 07

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        PolarDB MySQL 冷数据DDL优化
                      

                    

                    

                  
                      

                        PolarDB MySQL 冷数据查询性能优化
                      

                    

                    

                  
                      

                        PostgreSQL 子事务探秘
                      

                    

                    

                  
                      

                        使用PT_PERF排查线上慢SQL问题
                      

                    

 
        

    

  

    
 使用PT_PERF排查线上慢SQL问题  

    
 Author: bayan  

  

  

  
背景

在我们线上的客户有一个实例，在每天固定的时间都会出现慢SQL的问题；该用户线上业务对于SQL执行的时间较为严格，执行时间超过150ms就认为是慢SQL。
在以往的排查经验中，认为这类慢SQL的问题一般都是锁等待的问题，或者是底层文件系统的IO抖动造成的；但是这次我们都排查过一番，出现慢SQL语句的锁等待很低；而且在底层的文件系统虽然偶尔会有一些长尾的慢IO的情况，但是和慢SQL出现的时间对不上。
后面我们尝试使用线上版本复现用户的这个场景，后来终于在模拟了线上用户执行SQL的模式和压力后，复现了线上出现慢SQL的场景。我们尝试对这个实例进行打栈后发现一些蛛丝马迹，怀疑可能和IO有关系；因为用户请求的栈最后落到了IO上面；但是这并不能说明和IO一定有关系，因为我们打栈时的情况并不一定是出现慢SQL时的情况。
此时，我们需要一个工具来精确的分析出慢SQL到底是怎么执行的，这样我们才能具体的分析出问题的根本原因；所以我们借助
PT_PERF
工具来分析一下这次慢SQL具体的执行过程。

排查过程

通过
PT_PERF 使用介绍
这篇文章我们可以非常精确的知道每一个函数的执行时间；那么我们知道MySQL处理用户请求的入口函数是

do_command

，那么我们在获取到进程号，和执行

do_command

的线程号后就可以通过下面这个命令就可以查看到这个函数在处理用户请求时执行的一些具体情况：

//

首先通过
 
--history=1 这个参数来采集一批perf数据，后面只需要使用参数 --history=2 参数来对这批perf数据进行处理，不然就需要每次从进程5147 线程53218 上抓取数据

/

usr

/

share

/

pt_func_perf

/

func_latency
 
-

b
 
"/u01/polardb57_current/bin/mysqld"
 
-

P
 
"/usr/share/pt_func_perf/perf"
 
-

f
 
"do_command"
 
-

d
 
15
 
-

p
 
5147
 
-

t
 
-

s
 
-

T
 
53218
 
--history=1

//
 
打出

do_command

函数执行的具体情况

/

usr

/

share

/

pt_func_perf

/

func_latency
 
-

b
 
"/u01/polardb57_current/bin/mysqld"
 
-

P
 
"/usr/share/pt_func_perf/perf"
 
-

f
 
"do_command"
 
-

d
 
15
 
-

p
 
5147
 
-

t
 
-

s
 
-

T
 
53218
 
--history=2                                                               

[
 
start
 
10
 
parallel
 
workers
 
]

[
 
perf
 
script
 
has
 
consumed
 
3

.

61
 
seconds
 
]

[
 
parse
 
actions
 
has
 
consumed
 
0

.

01
 
seconds
 
]

[
 
parsed
 
44524
 
actions

,
 
trace
 
errors

:
 
0
 
]

[
 
analyze
 
functions
 
has
 
consumed
 
0

.

01
 
seconds
 
]

[
 
real
 
trace
 
time

:
 
14

.

85
 
seconds
 
]

[
 
miss
 
trace
 
time

:
 
0

.

00
 
seconds
 
]

===========================================================================================================

Histogram
 
-
 
Latency
 
of
 
[

do_command

]:

          
ns
             
:
 
cnt
        
distribution

     
16384
 
->
 
32767
      
:
 
1
        
|
                    
|

     
32768
 
->
 
65535
      
:
 
0
        
|
                    
|

     
65536
 
->
 
131071
     
:
 
0
        
|
                    
|

    
131072
 
->
 
262143
     
:
 
0
        
|
                    
|

    
262144
 
->
 
524287
     
:
 
268
      
|***
                 
|

    
524288
 
->
 
1048575
    
:
 
1734
     
|********************|

   
1048576
 
->
 
2097151
    
:
 
200
      
|**
                  
|

   
2097152
 
->
 
4194303
    
:
 
15
       
|
                    
|

   
4194304
 
->
 
8388607
    
:
 
6
        
|
                    
|

   
8388608
 
->
 
16777215
   
:
 
0
        
|
                    
|

  
16777216
 
->
 
33554431
   
:
 
0
        
|
                    
|

  
33554432
 
->
 
67108863
   
:
 
1
        
|
                    
|

  
67108864
 
->
 
134217727
  
:
 
1
        
|
                    
|

trace
 
count

:
 
2226

,
 
average
 
latency

:
 
854514
 
ns

...

//

如果需要函数

do_command

执行的更加详细的时间线以及耗时，可以执行如下命令

#/

usr

/

share

/

pt_func_perf

/

func_latency
 
-

b
 
"/u01/polardb57_current/bin/mysqld"
 
-

P
 
"/usr/share/pt_func_perf/perf"
 
-

f
 
"do_command"
 
-

d
 
15
 
-

p
 
5147
 
-

t
 
-

s
 
-

T
 
53218
 
-

l
 
--history=2

[
 
start
 
10
 
parallel
 
workers
 
]

[
 
perf
 
script
 
has
 
consumed
 
3

.

54
 
seconds
 
]

[
 
parse
 
actions
 
has
 
consumed
 
0

.

01
 
seconds
 
]

[
 
parsed
 
44524
 
actions

,
 
trace
 
errors

:
 
0
 
]

[
 
analyze
 
functions
 
has
 
consumed
 
0

.

01
 
seconds
 
]

[
 
real
 
trace
 
time

:
 
14

.

85
 
seconds
 
]

[
 
miss
 
trace
 
time

:
 
0

.

00
 
seconds
 
]

Thread
 
53218

:
 

start_timestamp

:
 
2772258869939489

┐

y

(

us

)

⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀

├

118322

⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀

│⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀

│⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠐⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀

│⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀

├

94657

.

4

⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀

│⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀

│⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀

│⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀

├

70993

⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀

│⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀

│⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀

│⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀

├

47328

.

7

⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀

│⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀

│⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀

│⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀

├

23664

.

3

⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀

│⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀

│⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀

│⣀⣀⡁⠀⡀⢀⢈⣀⡀⣀⣀⣀⣠⡠⣀⢄⡠⠀⡀⣈⣀⢀⠀⠀⠀⠀⠀⠀⡨⣀⣀⠄⣐⢀⣀⡀⣀⠀⡀⣀⣀⣀⢀⡀⢀⠀⣀⡀⢀⣀⣀⡀⢀⢀⡠⣀⠀⣀⠀⡀⠀⣀⣀⣀⡀⣀⣀⣀⠄⢀⡀⠀⠀⠀⠀⠀⠀⢀⡀

┼───────────┬───────────┬───────────┬───────────┬───────────┬───────────┬──────┐

│

0

⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀

2

.

22715

e

+

06

⠀

4

.

45429

e

+

06

⠀

6

.

68144

e

+

06

⠀

8

.

90859

e

+

06

⠀

1

.

11357

e

+

07

⠀⠀⠀⠀⠀⠀⠀⠀

x

(

us

)

│⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀

┘⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀

[
 
print
 
stat
 
has
 
consumed
 
0

.

00
 
seconds
 
]

...

从上面的结果我们可以很清晰的看到虽然

do_command

的平均执行时间在0.85ms左右，而且绝大部分执行时间都在0.5ms~1ms之间；但是偶尔会出现超过67ms的慢请求；同时这个工具也可以打出

do_command

执行的时间线及耗时，从这个时间线上我们可以看到，有一次超过94ms的长尾请求，这个超过94ms的长尾请求就是我们需要关注的。
那么通过

-a

参数可以指定父函数并且指定父函数的耗时范围，然后查看这个父函数的子函数执行情况，这样我们就可以知道这次超过67ms的执行，最终是那个子函数耗时占比最大。
然后我们一直顺着耗时最大的子函数一直向下定位就能发现最终的具体情况；具体的调用链路为：
do_command -> dispatch_command->mysql_parse->mysql_execute_command->Sql_cmd_update::execute->Sql_cmd_update::try_single_table_update->mysql_update->handler::ha_update_row->ha_innobase::update_row->row_update_for_mysql->row_update_for_mysql_using_upd_graph->row_upd_step->row_upd->row_upd_clust_step->btr_pcur_restore_position_func->btr_cur_search_to_nth_level->buf_page_get_gen
最终我们一直定位到如下情况：

//

指定父函数为

do_command

，耗时区间在

67

ms

~

134

ms

；子函数

buf_page_get_gen

的执行情况

/

usr

/

share

/

pt_func_perf

/

func_latency
 
-

b
 
"/u01/polardb57_current/bin/mysqld"
 
-

P
 
"/usr/share/pt_func_perf/perf"
 
-

f
 
"buf_page_get_gen"
 
-

d
 
15
 
-

p
 
5147
 
-

t
 
-

s
 
-

T
 
53218
 
--history=2 -a do_command#67108864,134217727

[
 
start
 
10
 
parallel
 
workers
 
]

[
 
perf
 
script
 
has
 
consumed
 
3

.

74
 
seconds
 
]

[
 
parse
 
actions
 
has
 
consumed
 
0

.

12
 
seconds
 
]

[
 
parsed
 
389356
 
actions

,
 
trace
 
errors

:
 
0
 
]

[
 
analyze
 
functions
 
has
 
consumed
 
0

.

07
 
seconds
 
]

[
 
real
 
trace
 
time

:
 
14

.

85
 
seconds
 
]

[
 
miss
 
trace
 
time

:
 
0

.

00
 
seconds
 
]

[
 
ancestor

:
 
do_command

,
 
call

:
 
2226

,
 
return

:
 
2226
 
]

====================================================================================================

Histogram
 
-
 
Latency
 
of
 
[

buf_page_get_gen

]:

          
ns
             
:
 
cnt
        
distribution
        
        
64
 
->
 
127
        
:
 
2
        
|*************
       
|

       
128
 
->
 
255
        
:
 
2
        
|*************
       
|

       
256
 
->
 
511
        
:
 
3
        
|********************|

       
512
 
->
 
1023
       
:
 
3
        
|********************|

      
1024
 
->
 
2047
       
:
 
1
        
|******
              
|

      
2048
 
->
 
4095
       
:
 
0
        
|
                    
|

      
4096
 
->
 
8191
       
:
 
0
        
|
                    
|

      
8192
 
->
 
16383
      
:
 
0
        
|
                    
|

     
16384
 
->
 
32767
      
:
 
0
        
|
                    
|

     
32768
 
->
 
65535
      
:
 
0
        
|
                    
|

     
65536
 
->
 
131071
     
:
 
0
        
|
                    
|

    
131072
 
->
 
262143
     
:
 
0
        
|
                    
|

    
262144
 
->
 
524287
     
:
 
0
        
|
                    
|

    
524288
 
->
 
1048575
    
:
 
0
        
|
                    
|

   
1048576
 
->
 
2097151
    
:
 
0
        
|
                    
|

   
2097152
 
->
 
4194303
    
:
 
0
        
|
                    
|

   
4194304
 
->
 
8388607
    
:
 
0
        
|
                    
|

   
8388608
 
->
 
16777215
   
:
 
0
        
|
                    
|

  
16777216
 
->
 
33554431
   
:
 
0
        
|
                    
|

  
33554432
 
->
 
67108863
   
:
 
0
        
|
                    
|

  
67108864
 
->
 
134217727
  
:
 
1
        
|******
              
|

trace
 
count

:
 
12

,
 
average
 
latency

:
 
8761090
 
ns

----------------------------------------------------------------------------------------------------

Histogram
 
-
 
Child
 
functions

's Latency of [buf_page_get_gen]:
               name            : avg        cnt        call_line        distribution (total) 
pfs_rw_lock_x_lock_func        : 26281791   4          buf0buf.cc:5111 |********************|
buf_page_make_young_if_needed  : 174        12         buf0buf.cc:5049 |                    |
thd_add_io_stats               : 89         12         buf0buf.cc:4533 |                    |
buf_page_hash_get_low          : 88         12         buf0buf.cc:4562 |                    |
mtr_t::memo_push               : 62         12         buf0buf.cc:5120 |                    |
*self                          : 58         12         -               |                    |
pfs_rw_lock_s_unlock_func      : 12         12         buf0buf.cc:4694 |                    |
pfs_rw_lock_s_lock_func        : 6          8          buf0buf.cc:5097 |                    |
fsp_is_system_temporary        : 1          12         buf0buf.cc:4679 |                    |
srv_polar_is_master            : 0          12         buf0buf.cc:5064 |                    |
fsp_is_system_temporary        : 0          12         buf0buf.cc:4722 |                    |
----------------------------------------------------------------------------------------------------
...

====================================================================================================
Histogram - Latency of [buf_page_get_gen]
           called from [btr_cur_search_to_nth_level(buf0buf.cc:5139)]:
          ns             : cnt        distribution        
        64 -> 127        : 2        |*************       |
       128 -> 255        : 1        |******              |
       256 -> 511        : 3        |********************|
       512 -> 1023       : 0        |                    |
      1024 -> 2047       : 1        |******              |
      2048 -> 4095       : 0        |                    |
      4096 -> 8191       : 0        |                    |
      8192 -> 16383      : 0        |                    |
     16384 -> 32767      : 0        |                    |
     32768 -> 65535      : 0        |                    |
     65536 -> 131071     : 0        |                    |
    131072 -> 262143     : 0        |                    |
    262144 -> 524287     : 0        |                    |
    524288 -> 1048575    : 0        |                    |
   1048576 -> 2097151    : 0        |                    |
   2097152 -> 4194303    : 0        |                    |
   4194304 -> 8388607    : 0        |                    |
   8388608 -> 16777215   : 0        |                    |
  16777216 -> 33554431   : 0        |                    |
  33554432 -> 67108863   : 0        |                    |
  67108864 -> 134217727  : 1        |******              |
trace count: 8, average latency: 13141336 ns

----------------------------------------------------------------------------------------------------
Histogram - Child functions'

s
 
Latency
 
of
 
[

buf_page_get_gen

]

                             
called
 
from
 
[

btr_cur_search_to_nth_level

(

buf0buf

.

cc

:

5139

)]:

               
name
            
:
 
avg
        
cnt
        
call_line
        
distribution
 
(

total

)
 

pfs_rw_lock_x_lock_func
        
:
 
105126958
  
1
          
buf0buf

.

cc

:

5111
 
|********************|

buf_page_make_young_if_needed
  
:
 
156
        
8
          
buf0buf

.

cc

:

5049
 
|
                    
|

buf_page_hash_get_low
          
:
 
85
         
8
          
buf0buf

.

cc

:

4562
 
|
                    
|

mtr_t

::

memo_push
               
:
 
85
         
8
          
buf0buf

.

cc

:

5120
 
|
                    
|

thd_add_io_stats
               
:
 
64
         
8
          
buf0buf

.

cc

:

4533
 
|
                    
|

*

self
                          
:
 
55
         
8
          
-
               
|
                    
|

pfs_rw_lock_s_unlock_func
      
:
 
10
         
8
          
buf0buf

.

cc

:

4694
 
|
                    
|

pfs_rw_lock_s_lock_func
        
:
 
5
          
7
          
buf0buf

.

cc

:

5097
 
|
                    
|

srv_polar_is_master
            
:
 
1
          
8
          
buf0buf

.

cc

:

5064
 
|
                    
|

fsp_is_system_temporary
        
:
 
1
          
8
          
buf0buf

.

cc

:

4722
 
|
                    
|

fsp_is_system_temporary
        
:
 
1
          
8
          
buf0buf

.

cc

:

4679
 
|
                    
|

====================================================================================================

...

从上面的信息我们就可以看出，这次长尾的慢SQL主要是由于在更新主键索引时获取主键所在的数据页等锁导致的；而page锁的等锁时间不会反映在慢SQL的信息中。
一般主键的page锁等待有下面这几种情况：

  
热点数据更新争抢page锁。

  
purge data时拿page锁。

  
这个page正在刷盘，IO问题导致持有page锁时间长。

那么我们下面就分别详细的分析这上面三个问题，来看下到底是什么情况。

热点数据争抢page锁

首先我们从上面的信息知道，这里的锁等待时间超过100ms；那么有两种可能：

  
另外一个拿这个page锁的请求也持有锁超过了100ms，这种情况下我们肯定也可以观察到这次慢请求；但是事实上，只有上面这一次慢请求；所以这种情况排除。

  
这个page非常的热，有非常多的请求来抢这个page的锁。如果有这么多排队的请求，那就不可能只有个别几个长尾请求。

那么如果是上面这两种情况，我们只需要监控一下整个进程

do_command

函数的耗时分布就可以查明具体的情况。

//

对进程

5147

进行全采样

#/

usr

/

share

/

pt_func_perf

/

func_latency
 
-

b
 
"/u01/polardb57_current/bin/mysqld"
 
-

P
 
"/usr/share/pt_func_perf/perf"
 
-

f
 
"do_command"
 
-

d
 
2
 
-

p
 
5147
 
-

t
 
-

s
 
--history=2                                                                         

[
 
start
 
10
 
parallel
 
workers
 
]

[
 
perf
 
script
 
has
 
consumed
 
28

.

63
 
seconds
 
]

[
 
parse
 
actions
 
has
 
consumed
 
0

.

09
 
seconds
 
]

[
 
parsed
 
422494
 
actions

,
 
trace
 
errors

:
 
0
 
]

[
 
analyze
 
functions
 
has
 
consumed
 
0

.

02
 
seconds
 
]

[
 
real
 
trace
 
time

:
 
2

.

10
 
seconds
 
]

[
 
miss
 
trace
 
time

:
 
0

.

00
 
seconds
 
]

===========================================================================================================

Histogram
 
-
 
Latency
 
of
 
[

do_command

]:

          
ns
             
:
 
cnt
        
distribution

      
1024
 
->
 
2047
       
:
 
2
        
|
                    
|

      
2048
 
->
 
4095
       
:
 
0
        
|
                    
|

      
4096
 
->
 
8191
       
:
 
1
        
|
                    
|

      
8192
 
->
 
16383
      
:
 
7
        
|
                    
|

     
16384
 
->
 
32767
      
:
 
7
        
|
                    
|

     
32768
 
->
 
65535
      
:
 
5
        
|
                    
|

     
65536
 
->
 
131071
     
:
 
2
        
|
                    
|

    
131072
 
->
 
262143
     
:
 
8
        
|
                    
|

    
262144
 
->
 
524287
     
:
 
1214
     
|*
                   
|

    
524288
 
->
 
1048575
    
:
 
16244
    
|********************|

   
1048576
 
->
 
2097151
    
:
 
3535
     
|****
                
|

   
2097152
 
->
 
4194303
    
:
 
81
       
|
                    
|

   
4194304
 
->
 
8388607
    
:
 
9
        
|
                    
|

   
8388608
 
->
 
16777215
   
:
 
0
        
|
                    
|

  
16777216
 
->
 
33554431
   
:
 
0
        
|
                    
|

  
33554432
 
->
 
67108863
   
:
 
0
        
|
                    
|

  
67108864
 
->
 
134217727
  
:
 
0
        
|
                    
|

 
134217728
 
->
 
268435455
  
:
 
0
        
|
                    
|

 
268435456
 
->
 
536870911
  
:
 
0
        
|
                    
|

 
536870912
 
->
 
1073741823
 
:
 
1
        
|
                    
|

trace
 
count

:
 
21116

,
 
average
 
latency

:
 
901122
 
ns

-----------------------------------------------------------------------------------------------------------

Histogram
 
-
 
Child
 
functions

's Latency of [do_command]:
                    name                 : avg        cnt        call_line          distribution (total) 
dispatch_command                         : 842302     21116      sql_parse.cc:1126 |********************|
Protocol_classic::get_command            : 58478      21116      sql_parse.cc:1065 |*                   |
my_realloc                               : 6117       6          sql_string.h:372  |                    |
*self                                    : 140        21116      -                 |                    |
my_net_set_read_timeout                  : 120        21116      sql_parse.cc:1033 |                    |
my_net_set_read_timeout                  : 35         21116      sql_parse.cc:1124 |                    |
Protocol_classic::get_packet             : 19         21116      sql_parse.cc:1127 |                    |
Protocol_text::type                      : 14         21116      sql_parse.cc:1001 |                    |
Protocol_classic::get_net                : 8          21116      sql_parse.cc:1032 |                    |
Diagnostics_area::reset_diagnostics_area : 0          21116      sql_parse.cc:1022 |                    |
Protocol_classic::get_packet             : 0          21116      sql_parse.cc:1120 |                    |
===========================================================================================================
...

通过这个工具的采样我们可以发现，超过50ms的长尾请求只有一个，并没有多个，所以排除了第一种另外一个线程也持有这个page锁很长时间的情况。
而且进一步观察，长尾请求超过几十ms的只有一个，说明这个page锁只有这一个请求在等待；所以也排除了第二种情况。

purge data时拿page锁

这种情况我们只需要对purge线程的逻辑采样，就可以知道purge线程的各个子函数的耗时；如果有purge的长尾，那么就有可能和导致这个长尾的慢SQL。

#/

usr

/

share

/

pt_func_perf

/

func_latency
 
-

b
 
"/u01/polardb57_current/bin/mysqld"
 
-

P
 
"/usr/share/pt_func_perf/perf"
 
-

f
 
"row_purge_step"
 
-

d
 
30
 
-

p
 
5147
 
-

t
 
-

s
 
-

T
 
5290

,

5291

,

5292

,

5293
  
--history=2                                            

[
 
start
 
10
 
parallel
 
workers
 
]

[
 
perf
 
script
 
has
 
consumed
 
24

.

12
 
seconds
 
]

[
 
parse
 
actions
 
has
 
consumed
 
1

.

13
 
seconds
 
]

[
 
parsed
 
2676658
 
actions

,
 
trace
 
errors

:
 
0
 
]

[
 
analyze
 
functions
 
has
 
consumed
 
0

.

31
 
seconds
 
]

[
 
real
 
trace
 
time

:
 
30

.

00
 
seconds
 
]

[
 
miss
 
trace
 
time

:
 
0

.

00
 
seconds
 
]

====================================================================================================

Histogram
 
-
 
Latency
 
of
 
[

row_purge_step

]:

          
ns
             
:
 
cnt
        
distribution
       
         
0
 
->
 
1
          
:
 
153560
   
|****
                
|

         
2
 
->
 
3
          
:
 
737319
   
|********************|

         
4
 
->
 
7
          
:
 
113474
   
|***
                 
|

         
8
 
->
 
15
         
:
 
18556
    
|
                    
|

        
16
 
->
 
31
         
:
 
14378
    
|
                    
|

        
32
 
->
 
63
         
:
 
25776
    
|
                    
|

        
64
 
->
 
127
        
:
 
38635
    
|*
                   
|

       
128
 
->
 
255
        
:
 
28274
    
|
                    
|

       
256
 
->
 
511
        
:
 
41669
    
|*
                   
|

       
512
 
->
 
1023
       
:
 
1786
     
|
                    
|

      
1024
 
->
 
2047
       
:
 
242
      
|
                    
|

      
2048
 
->
 
4095
       
:
 
9443
     
|
                    
|

      
4096
 
->
 
8191
       
:
 
1518
     
|
                    
|

      
8192
 
->
 
16383
      
:
 
375
      
|
                    
|

     
16384
 
->
 
32767
      
:
 
7
        
|
                    
|

     
32768
 
->
 
65535
      
:
 
4
        
|
                    
|

     
65536
 
->
 
131071
     
:
 
1
        
|
                    
|

    
131072
 
->
 
262143
     
:
 
1
        
|
                    
|

    
262144
 
->
 
524287
     
:
 
1
        
|
                    
|

trace
 
count

:
 
1185019

,
 
average
 
latency

:
 
59
 
ns

----------------------------------------------------------------------------------------------------

row_purge_step是purge的入口函数，从这里我们可以观察到，row_purge_step最长的耗时也就0.2ms~0.5ms左右；而且purge的平均耗时是59ns，而且history list一直保持在2.5K左右，说明purge再整个处理过程中不是瓶颈；所以应该也不是purge导致的这次慢请求。

这个page正在刷盘，IO问题导致持有page锁时间变长

  
如果是底层文件系统的慢IO，我们从文件系统的监控中可以很容易的发现这次慢IO（比较超过100ms）；但是我们查看文件系统的IO监控后，只发现了偶尔有5ms、8ms的长尾慢IO，而且这些长尾慢IO和这次慢SQL发生的时间并不能对上，所以应该也不是底层文件系统的慢IO导致的。
    

//

发现的慢

IO

日志

[

Warning

]
 
InnoDB

:
 
[

RDS
 
Diagnose

]
 
Write
 
len

:

16384

,
 
latency

:
 
5676

us

.

[

Warning

]
 
InnoDB

:
 
[

RDS
 
Diagnose

]
 
Write
 
len

:

16384

,
 
latency

:
 
5171

us

.

[

Warning

]
 
InnoDB

:
 
[

RDS
 
Diagnose

]
 
Write
 
len

:

16384

,
 
latency

:
 
8820

us

.

[

Warning

]
 
InnoDB

:
 
[

RDS
 
Diagnose

]
 
Write
 
len

:

16384

,
 
latency

:
 
7188

us

.

[

Warning

]
 
InnoDB

:
 
[

RDS
 
Diagnose

]
 
Write
 
len

:

16384

,
 
latency

:
 
6346

us

.

...

    

  

  
有可能是DB测的IO导致的，因为我们在刷盘时并不是直接调用文件系统接口进行IO；
    

      
为了提高IO效率，尽可能的把文件系统的IO打满；我们有一批IO线程，和IO队列；需要对page刷盘时，先将page丢入IO队列，然后IO线程会从对应的IO队列中获取刷盘的page，对其进行刷盘动作。

      
需要注意的是，当page放入IO队列时page此时是持有page锁的，因为这个时候已经不在允许page发生修改。

      
那么就可能会发生这样的情况：aio队列中可能已经有几千个page等待刷盘，那么队尾的page需要等前面以及本身完成刷盘后才能放锁；这就回导致这个page持有锁的时间变长。但是如果发生这种情况，虽然靠近队尾的那些page应该持有锁的时间都比较长；只有用户请求的page和队尾的page正好碰上，才有可能发生这种长尾慢请求。

    

  

为了进一步验证上面这种情况，我们修改了IO队列长度；发现改短IO队列长度后，慢SQL马上减少了很多，进一步调整以后，慢SQL完全消失；这充分说明了，就是这里导致的问题。

总结

在以往我们定位性能问题的时候，尤其是长尾问题；如果想要知道某一个函数具体的调用时间的分布，只能在函数中进行埋点；但是这一方面依赖于我们对代码的熟悉程度，另一方面埋点可能导致程序的行为发生改变。所以在定位性能问题，尤其是定位一些长尾的问题时是很困难的。这类问题发生在线上时，因为发布的代码不能更改，不能打栈，之前我们只能使用perf查看程序运行的一些大致情况。
但是，通过PT_PERF工具，我们不仅仅可以知道任一函数执行的情况，还可以指定父函数，指定耗时来查看其子函数的行为；这大大加快了我们定位问题的速度。而且这个工具的采样对于程序影响很小，对于线上问题的定位非常友好。
最后，需要注意的一点是，使用PT_PERF工具对程序进行采样是，需要注意采样时间；因为对整个进程进行采样，可能采样的数据量会特别大；在这种情况下，如果可以确定要采样的内容的线程号，可以指定线程进行采样，这样数据量会少很多。

  

    

		

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
