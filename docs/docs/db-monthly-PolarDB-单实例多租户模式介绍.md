# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2024/03/03/
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
	

  

    
数据库内核月报 － 2024 / 03

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 死锁场景 · 并发插入相同主键场景
                      

                    

                    

                  
                      

                        MySQL · 源码分析 · MySQL deadlock cause by lock inherit
                      

                    

                    

                  
                      

                        PolarDB 单实例多租户模式介绍
                      

                    

 
        

    

  

    
 PolarDB 单实例多租户模式介绍  

    
 Author: 有扈  

  

  

  
背景

简介

Saas下多租户模式相对于单租户模式的典型区别在于单租户模式一般通过硬件来进行物理上的隔离，每个租户购买自己的数据库实例；而多租户模式下各租户同在一个实例下共享计算/存储资源，需要考虑数据安全层面的隔离和性能层面的隔离。
MySQL本身对多租户并无特别的原生支持。在MySQL下实现多租户的手段一般可以分为三种方式：

  
独立数据库：一个租户一个数据库 ，物理意义上的数据隔离，类似单租户模式

  
共享数据库+独立Schema：所有租户共享Database，但是每个租户一个Schema，逻辑上进行了数据隔离

  
共享数据库+共享Schema+共享数据表：通过在表中增加TenantID多租户的数据字段来区分不同租户
三种方式数据独立性逐渐降低，共享度上升，但均无法实现性能资源上的隔离。

PolarDB MySQL 单实例多租户模式可以使得多个租户在同一实例下共享计算/存储资源，同时保证各租户下的数据隔离，保证租户仅能访问到自己的数据，以及各租户下的资源隔离，确保租户间不会出现资源争抢，保障业务稳定运行。

PolarDB MySQL 单实例多租户模式方案解决了以下一些客户业务痛点：

  
Saas多租户业务场景需要为每个租户创建不同库/表，业务代码需要针对每个租户进行适配。

  
关键业务在其他业务突发流量时无法保证资源分配，导致关键业务处理能力受到影响。

专有名词解释

  
租户：租户(Tenant)为实现单实例多租户模式所提出的概念，租户的层级结构在一个数据库实例之下，在DB与user之上。租户又可以分为系统租户与普通租户：
 a. 系统租户是为了适配原有模式下user的使用，原有数据库实例中的user默认属于系统租户，也可以成为系统用户。当通过系统租户下的user连接数据库时，可以访问所有租户下的DB（如果有对应权限）。
 b. 普通租户需要在系统租户下进行创建。普通租户下的DB与user都是完全隔离的，无法互相访问，并且普通租户无法访问至系统租户下的DB。

  
逻辑 DB name：各租户下的DB是完全隔离的，因此不同租户下可以存在相同名字的DB。如上图中tenant A B中都含有名为DB_1的DB。普通租户感知到的DB即为逻辑DB name。

  
物理 DB name：即使各租户下可以存在同名DB，但在同一数据库实例下DB的存储肯定不能是相同的名称，因此在数据库实例上真正存储的DB name 为物理DB name。例如Tenant A下的DB_1，在实例上物理存储的name 为DB_1@A， DB_1@A即为对应的物理DB name。

  
逻辑、物理user name：与逻辑、物理DB name 类似，逻辑、物理user name分别为普通租户感知到的user name以及真正存储在实例上的物理user name

整体架构设计

数据隔离

PolarDB 单实例多租户模式提供了数据隔离的能力。在多租户模式下，客户可以在同一个PolarDB 实例中创建多个租户，不同租户间的数据互不可见，并且在不同租户间可以创建同名DB/同名user。例如在上图中，Tenant A 中有 name 为DB_1的 database 以及 name为user_1 的 user，在多租户模式下，Tenant B 仍然可以创建DB_1 以及 user_1，这在原生MySQL中是不被允许的。这种数据隔离能力，能够解决部分Sass客户需要为不同租户维护不同业务代码的痛点。

资源隔离

PolarDB 单实例多租户模式提供了资源隔离的能力。在多租户模式下，客户可以创建多个resource_config 用来对租户进行资源限制，当租户绑定一个resource config 后，此租户使用的资源将会保证处于resource config的范围内。同时，后台线程会不断检测各租户间的负载情况，持续调度资源，来防止资源浪费。这种资源隔离能力，能够保证客户主要业务在其他业务流量突增时的稳定。

使用方式

SaaS 场景实践

以某客户典型的SaaS场景为例，该客户使用典型的SaaS部署模式，按库分租户，一个租户对应一个库，一个库中含有多个表。所有租户共同使用同一个实例的资源。

当使用 PolarDB 提供的多租户模式后，不再需要按照库去划分租户，而是可以直接创建租户。在租户下可以创建多个库表，无需担心库名重复问题，同时以某个租户下的user进行登录后，无需为多个租户进行业务代码上的适配。

  
当业务上有多个租户时，可以在PolarDB MySQL实例中创建对应的多个租户。

  

    
创建租户完成后，各租户间的数据完全隔离，互不可见其他租户数据。以租户下user进行登录后，无需根据租户来对业务代码进行适配，即使不同租户间有同名库，也可以直接对库表进行操作，仅会影响当前租户下的库表。

    
a. 以下文中“租户间数据隔离测试”为例，不同租户间执行相同的查询sql，将会返回当前租户下的数据。

  

  

    
可以为不同租户绑定不同的资源配置，来防止某一个租户流量突增导致影响其他租户。

    
a. 以下文中“租户间资源隔离对比测试”为例，可以为某个重要的租户A设置独占的CPU资源，来防止其他租户流量增长影响租户A

    
b. 也可以分别限制不同租户的最高CPU资源，来防止实例CPU资源消耗过多的情况。

  

资源配置创建

目前PolarDB MySQL 单机多租户资源隔离仅支持CPU资源隔离。在创建资源配置(resource_config)时指定此资源配置所对应的CPU资源限制，即min_cpu、max_cpu，当某一租户绑定此资源限制时便可限制此租户下user连接所使用的CPU资源。
通过create resource_config 语句来创建资源配置。

//
 
资源配置创建

create
 
resource_config
 
r1
 
min_cpu
 
0
 
max_cpu
 
1

;

create
 
resource_config
 
r2
 
min_cpu
 
1
 
max_cpu
 
4

;

//
 
查看资源配置

select
 
*
 
from
 
mysql

.

tenant_resource_config

;

租户创建

通过create tenant 语句来创建租户，创建租户时将与指定的resource config进行绑定。

//
 
创建租户
 
&&
 
绑定资源限制

create
 
tenant
 
tenant_1
 
resource_config
 
r2

;

//

查询租户

select
 
*
 
from
 
mysql

.

tenants

;

租户下创建 user & DB

系统租户下创建某一租户下的user

#
 
系统租户下删除

user

create
 
user
 
'user_1@tenant_1'

;

#
 
高权限账户下，为

user1

@

tenant_1
 
授予
 
租户

tenant_1

下的权限

grant
 
all
 
privileges
 
on
 
`%@tenant_1`

.

*
 
to
 
'user_1@tenant_1'

@

'%'
 
with
 
grant
 
option

;

租户下user 进行连接，连接后将会受到租户所对应resource_config的限制

mysql
 
--host=xxxxxx -u user1@tenant_1 -p pwssword

租户下user进行连接后，即可进行创建DB等其他操作

#
 
创建租户下

user

create
 
user
 
user2

;

#
 
创建租户下

DB

create
 
database
 
db2

;
 

use
 
db2

;

create
 
table
 
t

(

a
 
int

);

insert
 
into
 
t
 
values

(

100

);

select
 
*
 
from
 
t

;

drop
 
table
 
t

;

drop
 
database
 
db2

;

单实例多租户具体使用手册可参考：

多租户管理使用说明

场景测试

测试环境

  
测试的ECS和PolarDB MySQL版均在同一地域、同一可用区。

  
网络类型均为VPC网络
    

      
ECS实例和PolarDB MySQL版需保证在同一个VPC中。

    

  

  
测试用的PolarDB MySQL版如下：
    

      
PolarDB MySQL版本: 集群版 PolarDB802

      
节点规格为polar.mysql.x4.xlarge （8C 32G) （8核32 GB独享规格）

      
两节点集群（一主一只读）

      
使用的连接串为集群地址

    

  

  
测试用的ECS实例信息如下：
    

      
实例规格为ecs.g7.2xlarge

      
实例所使用的镜像为Ubuntu 22.04 64位

    

  

PolarDB 关键参数配置：

thread_pool_enable
 
=
 
ON

thread_pool_size
 
=
 
8
 
//
 
与

PolarDB

实例核心数一致

thread_pool_multi_tenant_enabled
 
=
 
ON

enable_multi_tenant
 
=
 
ON

租户间数据隔离测试

此次测试中，我们在同一实例中创建不同租户，并在不同租户间创建相同name的user、相同name的DB，在DB中创建不同结构的table，执行测试，比较两个租户下show database 以及查询table 展示出的结果。

创建租户
 
&
 
user

#

创建

resource_config

create
 
resource_config
 
r1
 
min_cpu
 
0
 
max_cpu
 
1

;

#

创建两个不同租户

create
 
tenant
 
tenant_1
 
resource_config
 
r1

;

create
 
tenant
 
tenant_2
 
resource_config
 
r1

;

#

在不同租户下分别创建相同

name
 
user

create
 
user
 
'user_1@tenant_1'
 
IDENTIFIED
 
BY
 
'xxxx'

;

create
 
user
 
'user_1@tenant_2'
 
IDENTIFIED
 
BY
 
'xxxx'

;

#

为

user

进行授权

grant
 
all
 
privileges
 
on
 
`%@tenant_1`

.

*
 
to
 
'user_1@tenant_1'

@

'%'
 
with
 
grant
 
option

;

grant
 
all
 
privileges
 
on
 
`%@tenant_2`

.

*
 
to
 
'user_1@tenant_2'

@

'%'
 
with
 
grant
 
option

;

创建 DB

#
 
tenant_1
 
下
 
user_1
 
进行创建

DB
 
&
 
table

create
 
database
 
dbtest

;

use
 
dbtest

create
 
table
 
t

(

a
 
int

);

insert
 
into
 
t
 
values

(

1

);

create
 
database
 
db_of_tenant_1

;

use
 
db_of_tenant_1

create
 
table
 
table_of_db_tenant_1

(

id
 
int

);

#
 
tenant_2
 
下

user_1
 
进行创建

DB
 
&
 
table

create
 
database
 
dbtest

;

use
 
dbtest

create
 
table
 
t

(

a
 
int

);

insert
 
into
 
t
 
values

(

2

);

create
 
database
 
db_of_tenant_2

;

use
 
db_of_tenant_2

create
 
table
 
table_of_db_tenant_2

(

id
 
int

);

最终在 tenant_1 与 tenant_2 下查询的结果分别如下图所示，可以看出在不同租户下执行相同sql，sql将会被重定向至不同租户中的DB，最终返回自己租户下的数据，且在此过程中，租户间的数据是互不可见的。

租户CPU资源限制动态修改测试

此次测试中，我们创建多个resource_config，在租户执行sysbench 测试时，动态修改租户对应的resource_config，观察CPU以及QPS变化

#
 
创建多个不同的

resource_config

create
 
resource_config
 
r1
 
min_cpu
 
0
 
max_cpu
 
1

;

create
 
resource_config
 
r2
 
min_cpu
 
1
 
max_cpu
 
2

;

create
 
resource_config
 
r3
 
min_cpu
 
1
 
max_cpu
 
4

;

create
 
resource_config
 
r4
 
min_cpu
 
1
 
max_cpu
 
6

;

create
 
resource_config
 
r5
 
min_cpu
 
1
 
max_cpu
 
8

;

通过之前创建的租户tenant_1 下user_1进行 sysbench 测试

# sysbench 准备数据

sysbench oltp_read_only  
--threads

=
512 
--mysql-host

=
xxxx  
--mysql-user

=
user_2@tenant_1 
--mysql-password

={
password
}
 
--mysql-db

=
sbtest 
--tables

=
10 
--table-size

=
50000   
--report-interval

=
1 
--time

=
7200  prepare

# sysbench 执行测试

sysbench oltp_read_only  
--threads

=
512 
--mysql-host

=
xxxx  
--mysql-user

=
user_2@tenant_1 
--mysql-password

={
password
}
 
--mysql-db

=
sbtest 
--tables

=
10 
--table-size

=
50000   
--report-interval

=
1 
--time

=
7200  run

在sysbench 测试过程中，tenant_1 所绑定的resource_config 变化顺序为：
r1->r2->r3->r4->r5->r4->r3->r2->r1
测试过程中，实例规格对应的CPU & QPS变化过程为：
RW-CPU：

RW-QPS：

RO-CPU:

RO-QPS：

观察此次测试结果，可以看到PolarDB 单实例多租户模式能够通过调整租户所绑定的资源配置来达到动态调整资源限制的效果，这使得客户可以更方便的控制租户间的资源分配。

租户间资源隔离对比测试

此次测试中，我们在租户/非租户 两种模式下进行对比测试，以此来模拟比较在其他业务突发高流量时，关键业务QPS的变化情况。

  
非租户模式下，某一user A 执行测试，另一user执行高线程测试，观察user A的qps变化过程

  
租户模式下，user A在独占租户下执行测试，另一个租户下 user执行高并发测试，观察user A的qps变化过程

非租户模式下并发测试

  
使用高权限账户进行 64 线程并发的 sysbench测试，此时观察到qps平均为230000

  
在高权限账号在进行 64 线程并发测试的同时，在另一终端使用高权限账号进行线程为512的sysbench测试，观察到64线程并发测试的qps 由230000降低到50000 左右。

多租户模式下并发测试

  
创建此次测试所需要的resource config
    

#
 
创建不同的

resource
 
config

create
 
resource_config
 
r6
 
min_cpu
 
2
 
max_cpu
 
2

;

    

  

  

    
通过文档之前提到的方式来创建租户以及租户下user
 a. tenant_1 与 tenant_2 租户都绑定resource config r6

  

  
tenant_1 下的user_1 执行sysbench 测试
    

sysbench oltp_read_only  --threads=64 --mysql-host=xxx  --mysql-user=user_1@tenant_1 --mysql-password=xxx --mysql-db=sbtest --tables=10 --table-size=50000   --report-interval=1 --time=7200 run 

    

  

  
tenant_1 下user_1 执行sysbench的同时，tenant_2 下user_1同时执行并发线程为512的sysbench 测试
    

sysbench oltp_read_only  
--threads

=
512 
--mysql-host

=
xxx  
--mysql-user

=
user_1@tenant_2 
--mysql-password

=
xxx 
--mysql-db

=
sbtest 
--tables

=
10 
--table-size

=
50000   
--report-interval

=
1 
--time

=
7200 run

    

  

观察到 tenant_1 下的 user_1 的sysbench 测试性能有155000左右下降至134000 左右。

通过在租户/非租户两种模式下的比较，能够看出在租户模式下，通过分配给固定资源给关键业务，能够保证在其他业务突发高流量时，关键业务仍然能够有足够资源保持稳定处理能力。

共享租户资源隔离测试

共享租户执行测试，观察CPU以及 qps随着独占租户的增加，导致CPU发生变化的测试

1.新建多个resource_config，用来控制独占租户的min_cpu

#
 
resource_config
 
r1

,

r2

,

r6
 
已经存在

#
 
create
 
resource_config
 
r1
 
min_cpu
 
0
 
max_cpu
 
1

;

#
 
create
 
resource_config
 
r2
 
min_cpu
 
1
 
max_cpu
 
2

;

#
 
create
 
resource_config
 
r6
 
min_cpu
 
2
 
max_cpu
 
2

;

create
 
resource_config
 
r7
 
min_cpu
 
4
 
max_cpu
 
4

;

create
 
resource_config
 
r8
 
min_cpu
 
6
 
max_cpu
 
8

;

create
 
resource_config
 
r9
 
min_cpu
 
7
 
max_cpu
 
8

2.通过高权限账户（sys 租户使用共享租户的资源）执行sysbench 测试

sysbench
 
oltp_read_only
  
--threads=512 --mysql-host=xxx  --mysql-user=xxx --mysql-password=xxx --mysql-db=sbtest --tables=10 --table-size=50000   --report-interval=1 --time=7200  run

3.在高权限账户执行sysbench测试期间，通过修改租户tenant_1 绑定的resource_config 资源来观察共享租户的资源隔离情况，tenant_1的resource_config 更改顺序为r1->r2->r6->r7->r8->r9->r8->r7->r6->r2->r1

RW-CPU：

RW-QPS:

RO-CPU:

RW-QPS:

观察此次测试结果，可以看出共享租户所能使用的资源随着独占租户的资源变化而进行变化，这保证了独占租户使用资源的独占性，保证独占租户任意时刻资源不被侵占。

总结

PolarDB MySQL 单实例多租户模式的推出，使得客户能够以简单的方式使得多个租户在同一实例下共享计算/存储资源，同时保证各租户下的数据隔离，保证租户仅能访问到自己的数据，以及各租户下的资源隔离，确保租户间不会出现资源争抢，保障业务稳定运行。 
PolarDB MySQL 单实例多租户模式解决了以下一些客户广泛存在的业务痛点：

  
Saas多租户业务场景需要为每个租户创建不同库/表，业务代码需要针对每个租户进行适配。

  
关键业务在其他业务突发流量时无法保证资源分配，导致关键业务处理能力受到影响。

  

    

		

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
