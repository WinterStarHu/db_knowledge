# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2019/01/07/
> 分类: 源码分析

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
	

  

    
数据库内核月报 － 2019 / 01

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        POLARDB · 理论基础 · 数据库故障恢复机制的前世今生
                      

                    

                    

                  
                      

                        POLARDB · 最佳实践 · POLARDB不得不知道的秘密(二)
                      

                    

                    

                  
                      

                        MongoDB · 原理介绍 · MongoDB从事务到复制
                      

                    

                    

                  
                      

                        PgSQL · 引擎特性 · PostgreSQL 并行查询概述
                      

                    

                    

                  
                      

                        MSSQL · 最佳实践 · 如何打码隐私数据列
                      

                    

                    

                  
                      

                        Redis · 引擎特性 · Lua脚本新姿势
                      

                    

                    

                  
                      

                        Mariadb · 源码分析 · proxy protocol
                      

                    

                    

                  
                      

                        MySQL · InnoDB · tablespace源码分析
                      

                    

                    

                  
                      

                        MySQL · 最佳实践 · MySQL中的IO共享操作
                      

                    

                    

                  
                      

                        PgSQL · 应用案例 · native partition 分区表性能优化
                      

                    

 
        

    

  

    
 Mariadb · 源码分析 · proxy protocol  

    
 Author: 西加  

  

  

  
前言

MariaDB MaxScale 是一款数据库中间件，可以按照语义分发语句到多个数据库服务器上。它对应用程序透明，可以提供读写分离、负载均衡和高可用服务。

proxy protocol 是 MaxScale 引入，为了解决使用proxy作为中间件连接mysql时，mysql获取client ip用
client通过proxy中间价连接mysql时，mysql server接收到认证报文中，包含的是proxy节点的IP。如果mysql.user表中指定了client的IP，无法通过认证。

一种传统处理方式是在proxy节点上保存client的ip和密码，用于client的认证，而在mysql server上使用另一套ip和密码用于proxy 节点到mysql server的认证。

MariaDB MaxScale引入了proxy protocol来解决client ip透传的问题。proxy节点获取到client ip后，把client ip包装在proxy protocol报文中发给server，server解析到了proxy protocol报文，再用报文中的ip替换proxy节点的ip

因为 proxy protocol 本身不包含鉴权，同时可能影响数据库的鉴权行为，所以在数据库 server 端设置了一个ip白名单，只有白名单ip发送的 proxy protocol 报文才会被接受。

mysql连接与认证过程和网络模块数据结构可以参考以前的月报

MySQL · 源码分析 · 连接与认证过程

MySQL · 源码分析 · 网络通信模块浅析

报文格式

proxy protocol 有两个版本 v1 和 v2 通过报文签名区分

v1

v1 报文是字符串形式
“PROXY %s %s %s %d %d”

  

    

      
字段

      
内容

    

  

  

    

      
签名

      
PROXY

    

    

      
%s.1

      
address family

    

    

      
%s.2

      
client address

    

    

      
%s.3

      
server address

    

    

      
%d.1

      
client port

    

    

      
%d.2

      
server port

    

  

v2

  

    

      
字段

      
内容

    

  

  

    

      
报文签名12字节

      
\x0D\x0A\x0D\x0A\x00\x0D\x0A\x51\x55\x49\x54\x0A

    

    

      
ver_cmd 1 字节

      
version 高四位 0x2 « 4， command 0x1(PROXY) 0x0 (LOCAL)

    

    

      
family 1 字节

      
IPV4 0x11，IPV6 0x21，AF_UNIX 0x21

    

    

      
length 2字节

      
addr 部分的数据长度，IPV4 12， IPV6 36， AF_UNIX 216

    

    

      
addr 以IPV4为例

      
client地址4字节，server地址4字节，client port 2字节， server port 2字节

    

  

客户端改造

MaxScale 使用场景下，Proxy Protocol Header 由 MaxScale 发送，这里暂不分析

MariaDB 为了测试，也改造了 client，可以通过 mysql_option 设置 Proxy Protocol

使用方法：在mysql_real_connect之前，调用 mysql_option

mysql_optionsv(mysql, MARIADB_OPT_PROXY_HEADER, header_data, header_lengths);

第一个参数是 MYSQL 句柄，第二个参数是 PROXY_HEADER 标志位，第三个参数是 Proxy Protocol Header，第四个参数是 Header length

Proxy Protocol Header 按照上述规则传入即可

/* st_mysql_options_extension 结构体对应 mysql->options->extension */
struct st_mysql_options_extension {
  ...
  
  /*  */
  char *proxy_header;
  size_t proxy_header_len;
}

int
mysql_optionsv(MYSQL *mysql,enum mysql_option option, ...)
{
   ...
   switch (option) {
     case MARIADB_OPT_PROXY_HEADER:                                                                                                                                                                          
     {
       size_t arg2 = va_arg(ap, size_t);
       /* 把 proxy_header 和 proxy_header_len 保存到extension中 */
       OPT_SET_EXTENDED_VALUE(&mysql->options, proxy_header, (char *)arg1);
       OPT_SET_EXTENDED_VALUE(&mysql->options, proxy_header_len, arg2);
     }
       break;
   }
}

/*
  mysql_real_connect 过程中发送 proxy header
  发送时机在建连后，接收挑战码之前
  这样在鉴权时可以使用 proxy header 中保存的 ip port
*/
MYSQL *mthd_my_real_connect(MYSQL *mysql, const char *host, const char *user,
                   const char *passwd, const char *db, 
                   uint port, const char *unix_socket, unsigned long client_flag)
{
  ...
  
  /* 如果extension中保存了 proxy_header，则把header发送给server */
  if (mysql->options.extension && mysql->options.extension->proxy_header)                                                                                                                                 
  {
    char *hdr = mysql->options.extension->proxy_header;
    size_t len = mysql->options.extension->proxy_header_len;
    if (ma_pvio_write(pvio, (unsigned char *)hdr, len) <= 0)
    {
      ma_pvio_close(pvio);
      goto error;
    }
  }
}

服务端改造

我们知道，server 通过对比自己的 net->pkt_nr 和 client 发送过来的 net->pkt_nr 来保证包没有乱序。而proxy header 没有包含正确的 pkt_nr，就可以通过判断 pkt_nr 乱序来识别 proxy header。

对于一对client和server线程，pkt_nr是共享的。

假设 server 发送的第一个包 pkt_nr == 1，下一个包是 client 回包 pkt_nr == 2，那么server再发给client 的包 pkt_nr == 3 以此类推。

/*
  正常的 mysql 都包含4字节 header，前三字节是size，第四字节是 pkt_nr
*/
my_bool my_net_write(NET *net, const uchar *packet, size_t len)
{
  ...

  /* 如果大于最大包长度，则分成多个包发送 */
  while (len >= MAX_PACKET_LENGTH)
  {
    const ulong z_size = MAX_PACKET_LENGTH;
	/* 前三个字节保存size */
    int3store(buff, z_size);
    /* 第四字节保存pkt_nr */
    buff[3]= (uchar) net->pkt_nr++;
    if (net_write_buff(net, buff, NET_HEADER_SIZE) ||
        net_write_buff(net, packet, z_size))
    {
      MYSQL_NET_WRITE_DONE(1);
      return 1;
    }
    packet += z_size;
    len-=     z_size;
  }
  /* Write last packet */
  int3store(buff,len);
  buff[3]= (uchar) net->pkt_nr++;

  ...
}

/* my_real_read 里面处理 proxy header */
static ulong
my_real_read(NET *net, size_t *complen,
             my_bool header __attribute__((unused)))
{
retry:
    /* 收到的包不满足 pkt_nr 约束，可能是 proxy header，跳转到 packets_out_of_order */
    if (net->buff[net->where_b + 3] != (uchar) net->pkt_nr)
      goto packets_out_of_order;
     
packets_out_of_order:
	/*
	  判断是否是 proxy protocol header
	  判断标准是报文前几位是否符合 proxy protocol header 的 signature
	  前面已经提到
	  	v1 signature 五字节：PROXY
	 	v2 signature 12字节：\x0D\x0A\x0D\x0A\x00\x0D\x0A\x51\x55\x49\x54\x0A
	*/
    if (has_proxy_protocol_header(net)
        && net->thd && 
        ((THD *)net->thd)->get_command() == COM_CONNECT)
    {
      /* Proxy information found in the first 4 bytes received so far.
         Read and parse proxy header , change peer ip address and port in THD.
       */
      /* 处理 proxy header，修改 THD 中的 ip port */
      if (handle_proxy_header(net))
      {
        /* error happened, message is already written. */
        len= packet_error;
        goto end; 
      }
      
      /* proxy protocol header 处理成功，跳到函数头重新读取 */
      goto retry;
    }

static int handle_proxy_header(NET *net)
{
  /*
    判断 proxy protocol header 的来源 ip 是否在白名单中
    白名单是一个全局变量 proxy_protocol_networks
    白名单 ip 以逗号分隔保存在全局变量中
  */
  if (!is_proxy_protocol_allowed((sockaddr *)&(thd->net.vio->remote)))
  {
     /* proxy-protocol-networks variable needs to be set to allow this remote address */
     my_printf_error(ER_HOST_NOT_PRIVILEGED, "Proxy header is not accepted from %s",
       MYF(0), thd->main_security_ctx.ip);
     return 1;
  }

  /*
    根据格式解析 proxy protocol header，格式在上文中已做介绍
    解析结果保存在 peer_info 中
  */
  if (parse_proxy_protocol_header(net, &peer_info))
  {
     /* Failed to parse proxy header*/
     my_printf_error(ER_UNKNOWN_ERROR, "Failed to parse proxy header", MYF(0));
     return 1;
  }

  /* Change peer address in THD and ACL structures.*/
  /* 将 peer_info 中的信息转存到 thd 中 */
  return thd_set_peer_addr(thd, &(peer_info.peer_addr), NULL, peer_info.port, false);
}

  

    

		

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
