# 通信库参数

本节介绍通信库相关的参数设置及取值范围等内容。

## tcp\_keepalives\_idle

**参数说明**： 在支持TCP\_KEEPIDLE套接字选项的系统上，设置发送活跃信号的间隔秒数。不设置发送保持活跃信号，连接就会处于闲置状态。

该参数属于USERSET类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

>[!TIP]须知
>
>- 如果操作系统不支持TCP\_KEEPIDLE选项，这个参数的值必须为0。
>
>- 在通过Unix域套接字进行的连接的操作系统上，这个参数将被忽略。
>
>- 将该值设置为0时，将使用系统的值。
>
>- 该参数在不同的**会话之间不共享**，也就是说不同的会话连接可能有不同的值。
>
>- 查看该参数时查出来的是**当前会话连接内的参数值**，而不是**guc副本的值**。

**取值范围**： 0-3600，单位为s。

**默认值**： 0

## tcp\_keepalives\_interval

**参数说明**： 在支持TCP\_KEEPINTVL套接字选项的操作系统上，以秒数声明在重新传输之间等待响应的时间。

该参数属于USERSET类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**： 0-180，单位为s。

**默认值**： 0

>[!TIP]须知
>
>- 如果操作系统不支持TCP\_KEEPINTVL选项，这个参数的值必须为0。
>
>- 在通过Unix域套接字进行的连接的操作系统上，这个参数将被忽略。
>
>- 将该值设置为0时，将使用系统的值。
>
>- 该参数在不同的**会话之间不共享**，也就是说不同的会话连接可能有不同的值。
>
>- 查看该参数时查出来的是**当前会话连接内的参数值**，而不是**guc副本的值**。

## tcp\_keepalives\_count

**参数说明**： 在支持TCP\_KEEPCNT套接字选项的操作系统上，设置openGauss服务端在断开与客户端连接之前可以等待的保持活跃信号个数。

该参数属于USERSET类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

>[!TIP]须知
>
>- 如果操作系统不支持TCP\_KEEPCNT选项，这个参数的值必须为0。
>
>- 在通过Unix域套接字进行连接的操作系统上，这个参数将被忽略。
>
>- 将该值设置为0时，将使用系统的值。
>
>- 该参数在不同的**会话之间不共享**，也就是说不同的会话连接可能有不同的值。
>
>- 查看该参数时查出来的是**当前会话连接内的参数值**，而不是**guc副本的值**。

**取值范围**： 0-100，其中0表示openGauss未收到客户端反馈的保持活跃信号则立即断开连接。

**默认值**： 0

## tcp\_user\_timeout

**参数说明**： 在支持TCP\_USER\_TIMEOUT套接字选项的操作系统上，设置openGauss在发送数据时，指定传输的数据在TCP连接被强制关闭之前可以保持未确认状态的最大时长。

该参数属于SIGHUP类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

>[!TIP]须知
>
>- 如果操作系统不支持TCP\_USER\_TIMEOUT选项，这个参数的值将不生效，默认为0。
>- 在通过Unix域套接字进行连接的操作系统上，这个参数将被忽略。

**取值范围**： 0-3600000，单位为ms。其中0表示跟随操作系统设置。

**默认值**： 0

注意，不同操作系统内核下，这个参数生效结果将不同：

- aarch64 EulerOS（Linux内核版本：4.19），超时时间即为该参数设置值。

- x86 Euler2.5（Linux内核版本：3.10），超时时间不是该参数设置值，而是不同区间的最大值，即超时时间取值为：tcp\_user\_timeout设置值所处“Linux TCP重传总耗时”区间的上限最大值。例如：tcp\_user\_timeout=40000时，重传总耗时为51秒。

**表 1**  x86 Euler2.5（Linux内核版本：3.10）tcp\_user\_timeout参数取值示意

Linux TCP重传次数 Linux TCP重传总耗时区间（秒） tcp_user_timeout设置举例（毫秒） 实际Linux TCP重传总耗时（秒） (0.2,0.6] 400
0.6
(0.6,1.4] 1000
1.4
(1.4,3] 2000 (3,6.2] 4000
6.2
(6.2,12.6] 10000
12.6
(12.6,25.4] 20000
25.4
(25.4,51] 40000 (51,102.2] 80000
102.2
(102.2,204.6] 150000
204.6
(204.6,324.6] 260000
324.6
(324.6,444.6] 400000
444.6

注：TCP每次重传耗时随重传次数指数增加，当TCP一次重传到达120秒后，后续每次重传都将耗时120秒不再变化。

## comm\_proxy\_attr

**参数说明**： 通信代理库相关参数配置。

>[!NOTE]说明
>
>- 该参数仅支持欧拉2.9系统下的集中式ARM单机。
>- 本功能在线程池开启状态下生效，即enable\_thread\_pool为on。
>- 配置该参数时需同步配置GUC参数local\_bind\_address为libos\_kni的网卡IP。
>- 参数模板：comm\_proxy\_attr = '\{enable\_libnet:true, enable\_dfx:false, numa\_num:4, numa\_bind:\[\[30,31\],\[62,63\],\[94,95\],\[126,127\]\]\}'
>- 可配置参数说明。
>   - enable\_libnet：是否开启用户态协议，取值范围：true、false。
>   - enable\_dfx：是否开启通信代理库视图，取值范围：true、false。
>   - numa\_num：机器环境中numa的数量，支持2P、4P服务器，取值范围：4、8。
>   - numa\_bind：代理线程绑核参数，每个numa两个CPU绑核，共numa\_num组，取值范围：\[0，cpu数-1\]。

该参数属于POSTMASTER类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**：字符串，长度大于0。

**默认值**： 'none'

## hcom4db\_link\_path

**参数说明**： 指定hcom4db通信库目录，配合comm\_sctp\_type使用可以将Stream算子使用的libcom库替换为hcom4db

该参数属于POSTMASTER类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**：字符串，长度大于0。

**默认值**： 'none'

## comm\_sctp\_type

**参数说明**： 配置hcom使用的连接类型

>[!NOTE]说明
>
>- 该参数需要在配置有效hcom4db\_link\_path的前提下生效
>- 该参数生效范围为：SPQ场景下的跨节点Stream算子
>- 可配置参数说明。
>   - ORIGIN：不替换libcom
>   - TCP：使用hcom4db通信库，并且使用TCP模式
>   - UBC：使用hcom4db通信库，并且使用UBC模式

该参数属于POSTMASTER类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**："ORIGIN", "TCP", "UBC"

**默认值**： 'ORIGIN'

## comm\_link\_num

**参数说明**： 配置Hcom4db场景下节点间多连接功能

>[!NOTE]说明
>
>- 该参数表明两个节点之间建立连接的数量，有助于减少向同一个节点发送信息时的锁竞争。

该参数属于POSTMASTER类型参数，请参考[表1](../database_administration_guide/reset_parameters.md#zh-cn_topic_0283137176_zh-cn_topic_0237121562_zh-cn_topic_0059777490_t91a6f212010f4503b24d7943aed6d846)中对应设置方法进行设置。

**取值范围**：1-32

**默认值**： 1
