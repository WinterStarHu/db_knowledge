# 数据库内核月报

> 来源: http://mysql.taobao.org/monthly/2014/10/10/
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
	

  

    
数据库内核月报 － 2014 / 10

  

  

    

      

        

          
当期文章

          

                    

                  
                      

                        MySQL · 5.7重构 · Optimizer Cost Model
                      

                    

                    

                  
                      

                        MySQL · 系统限制 · text字段数
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · binlog重放失败
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · 从库OOM
                      

                    

                    

                  
                      

                        MySQL · 捉虫动态 · 崩溃恢复失败
                      

                    

                    

                  
                      

                        MySQL · 功能改进 · InnoDB Warmup特性
                      

                    

                    

                  
                      

                        MySQL · 文件结构 · 告别frm文件
                      

                    

                    

                  
                      

                        MariaDB · 新鲜特性 · ANALYZE statement 语法
                      

                    

                    

                  
                      

                        TokuDB · 主备复制 · Read Free Replication
                      

                    

                    

                  
                      

                        TokuDB · 引擎特性 · 压缩
                      

                    

 
        

    

  

    
 TokuDB · 引擎特性 · 压缩  

    
 Author:   

  

  

  
TokuDB除了有着较好的写性能外，还有一个重要的特性：压缩，而且大部分情况下压缩效果很不错。

目前TokuDB有４种压缩算法：

tokudb_lzma:    压缩比高，CPU消耗也高
tokudb_zlib:    压缩比和CPU消耗持中(默认压缩算法)
tokudb_quicklz:    压缩比低，CPU消耗低
tokudb_uncompressed:无压缩

使用上也比较简单：

MariaDB:
CREATE TABLE `t_quicklz` (
`x` int(11) DEFAULT NULL,
`y` int(11) DEFAULT NULL
) ENGINE=TokuDB `compression`=&#039;tokudb_quicklz&#039;

MySQL(Percona Server):
CREATE TABLE `t_quicklz` (
`x` int(11) DEFAULT NULL,
`y` int(11) DEFAULT NULL
) ENGINE=TokuDB DEFAULT CHARSET=latin1 ROW_FORMAT=TOKUDB_QUICKLZ

可能大家会有一个疑问：如果一个表创建的时候压缩算法是tokudb_quicklz，我可以通过ALERT TABLE改成其他算法吗？答案是：可以的！

TokuDB在底层实现上，用1byte来标记当前block的压缩算法，并持久化到磁盘，当压缩算法改变后，从磁盘读取数据然后解压缩的代码类似：

switch (block_buffer[0] &amp; 0xF) {
case TOKU_NO_COMPRESSION:
...
break;

case TOKU_ZLIB_METHOD:
...
break;

case TOKU_QUICKLZ_METHOD:
...
break;
case TOKU_LZMA_METHOD:
...
break;
｝

是不是很机智？

在使用TokuDB的过程中，一般不会改变压缩算法，除非默认的tokudb_zlib不给力，TokuDB是大block(4MB)，压缩效果较好，enjoy~

  

    

		

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
