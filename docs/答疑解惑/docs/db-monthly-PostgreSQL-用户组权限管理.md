# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2015/11/03/
> 分类: 答疑解惑

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
	

  

    
数据库内核月报 － 2015 / 11

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 社区见闻 · OOW 2015 总结 MySQL 篇
                      

                    

                    

                  
                      

                        MySQL · 特性分析 · Statement Digest
                      

                    

                    

                  
                      

                        PgSQL · 答疑解惑 · PostgreSQL 用户组权限管理
                      

                    

                    

                  
                      

                        MySQL · 特性分析 · MDL 实现分析
                      

                    

                    

                  
                      

                        PgSQL · 特性分析 · full page write 机制
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · MySQL 外键异常分析
                      

                    

                    

                  
                      

                        MySQL · 答疑解惑 · MySQL 优化器 range 的代价计算
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · ORDER/GROUP BY 导致 mysqld crash
                      

                    

                    

                  
                      

                        MySQL · TokuDB · TokuDB 中的行锁
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · order by limit 造成优化器选择索引错误
                      

                    

 
        

    

  

    
 PgSQL · 答疑解惑 · PostgreSQL 用户组权限管理  

    
 Author: 义从  

  

  

  
背景

RDS上的PG没有开放超级用户，这给很多云上的客户使用PG带来了困难。因此有必要给大家讲讲PG的用户权限管理的一些小知识，它可以很好的帮助用户顺利的从之前的 DB 管理方式过度到云上。

  
PG 的 superuser 拥有几乎全部的数据库权限，甚至可以直接修改系统表，潜在风险相当大；

  
RDS PG 使用 superuser 运维 DB，例如管理用、管理流复制、备份等，这些操作用户是不需要关心的，换句话说它应该完全的交给云服务来处理；

  
对于用户而言，PG 的普通用户权限是完全够用的。使用普通用户，可以管理自己在云上的数据（对表进行DDL、DML、创建修改和管理其他数据库对象）。

之前的 PG 用户习惯使用 superuser 进行日常运维，一方面 superuser 完全不用做任何的授权，使用方便；另一方面这样的操作带来了潜在的风险，容易误操作。

最近碰到了较多的用户反馈，没有了超级用户，无法使用 RDS 的普通用户，管理其他普通用户创建的对象，经常出现操作对象无权限的问题，尤其存在多用户的情况下。通常情况下：

  
一个普通用户只能在自己 owner 的DB下创建 schema；

  
DB 下的对象有一个所属的 schema，普通用户可以在 public 下创建对象（如 table），在其他 schema 下创建对象需要 schema 的 owner 是当前用户或特别的授权；

  
管理一个数据库对象，需要是超级用户、或对象的 owner 是当前用户（在用户组权限之外）。

很多用户，使用了很多个 user 在 public 模式下创建了多张表，但是单个用户却没有权限同时管理他们， 更没有权限切换他们的 owner 到一个统一的用户下做统一处理，十分恼火。

解决方法

在这里，我们提供一种通用的方法，可以使用 PG 的用户组和继承特性，做到使用一个普通用户管理多个其他用户。

  

    
使用 RDS 的根账号创建一个用于管理数据库和用户的管理员账号，他具有创建用户和创建 DB 的权限

    

 postgres=# create user admin createdb createrole login password 'pgsql';
 CREATE ROLE
 postgres=# \du
                               List of roles
   Role name  |                   Attributes                   | Member of 
 -------------+------------------------------------------------+-----------
  admin       | Create role, Create DB                         | {}
  test        | Superuser                                      | {}

    

  

  

    
使用这个 admin 登陆 postgres，创建用于存放数据的DB

    

 postgres=> create database dbadmin;
 CREATE DATABASE

    

  

  

    
创建子账户subuser1 subuser2，并把他们的权限给admin

    

 dbadmin=> create user subuser1 ;
 CREATE ROLE
 dbadmin=> create user subuser2 ;
 CREATE ROLE
 dbadmin=> grant subuser1 to admin;
 GRANT ROLE
 dbadmin=> grant subuser2 to admin;
 GRANT ROLE

    

  

  

    
我们看到 admin 用户组管理了下列2个用户，也就是admin 拥有 subuser1，subuser2 的所有权限

    

 dbadmin=> \du
                                    List of roles
   Role name  |                   Attributes                   |      Member of
 -------------+------------------------------------------------+---------------------
  admin       | Create role, Create DB                         | {subuser1,subuser2}
  subuser1    |                                                | {}
  subuser2    |                                                | {}

    

  

  

    
使用 subuser1 或 subuser2 登陆数据库 dbadmin，public schema上创建 owner 是自己的表对象和其他对象。分别用3个用户创建3张表a b c用作测试，另外也可以使用 admin 用户创建分别属于 subuser1 和 subuser2 的 schema ，再创建 table

    

 dbadmin=> \d
            List of relations
  Schema |    Name    | Type  |  Owner
 --------+------------+-------+----------
  public | t_admin    | table | admin
  public | t_subuser1 | table | subuser1
  public | t_subuser2 | table | subuser2

    

  

  

    
使用 admin 用户，可以对这3张表做管理，例如:

    

 dbadmin=> select user;
  current_user
 --------------
  admin
 (1 row)
 dbadmin=> drop table t_admin,t_subuser1,t_subuser2;
 DROP TABLE

    

  

  

    
但是 subuser1 无法删除 t_admin 和 t_subuser2，同理 subuser2 也无法删除 t_admin 和 t_subuser1

    

 dbadmin=> select user;
  current_user
 --------------
  subuser1
 (1 row)
 dbadmin=> drop table t_admin;
 ERROR:  must be owner of relation t_admin
 dbadmin=> drop table t_subuser1;
 DROP TABLE
 dbadmin=> drop table t_subuser2;
 ERROR:  must be owner of relation t_subuser2

    

  

  

    
同理，可以使用 admin 用户，重置这3张表的 owner 到3个用户中的一个，而使用 subuser1 和 subuser2 则没有权限操作，例如:

    

 dbadmin=> select user;
  current_user
 --------------
  admin
 (1 row)
 dbadmin=> alter table t_admin owner to subuser1;
 ALTER TABLE
 dbadmin=> alter table t_subuser2 owner to subuser1;
 ALTER TABLE
 dbadmin=> alter table t_subuser1 owner to subuser2;
 ALTER TABLE

 dbadmin=> select user;
  current_user
 --------------
  subuser1
 (1 row)
 dbadmin=> \d
            List of relations
  Schema |    Name    | Type  |  Owner
 --------+------------+-------+----------
  public | t_admin    | table | subuser1
  public | t_subuser1 | table | subuser2
  public | t_subuser2 | table | subuser1
 (3 rows)
 dbadmin=> alter table t_admin owner to admin;
 ERROR:  must be member of role "admin"
 dbadmin=> alter table t_subuser1 owner to subuser1;
 ERROR:  must be owner of relation t_subuser1

    

  

  

    
最后，提一个完成上述功能的假设，admin 用户默认具有 INHERIT 权限，INHERIT 权限决定一个角色是否“继承”它所在组的角色的权限。一个带有 INHERIT 属性的角色可以自动使用已经赋与它直接或间接所在组的任何权限。没有 INHERIT，其它角色的成员关系只赋与该角色 SET ROLE 成其它角色的能力；其它角色的权限只是在这么做了之后才能获得。如果没有声明，缺省是 INHERIT。通过系统表， pg_roles 可以获得该用户的权限信息

    

 dbadmin=> select rolname,rolinherit from pg_roles ;
    rolname   | rolinherit
 -------------+------------
  subuser1    | t
  subuser2    | t
  admin       | t

    

  

总结

使用 PG 用户组可以做到使用一个 PG 用户组管理所在组内的所有其他普通用户和他们的对象。RDS 用户设置一个用户组，既可以管理多个用户的对象，又可以实现一定程度上的权限隔离，同时权限又不会过大，推荐在云上使用该方式管理自己的数据库。

如果要实现更加细粒度的权限控制，则需要使用 grant 和 revoke 语句，请参考官方
sql-createrole
  和 
sql-grant
。

  

    

		

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
