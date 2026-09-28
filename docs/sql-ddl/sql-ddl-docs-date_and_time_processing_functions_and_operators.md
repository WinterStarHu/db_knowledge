# 时间和日期处理函数和操作符

## 时间日期操作符

[!WARNING]注意

用户在使用时间和日期操作符时，对应的操作数请使用明确的类型前缀修饰，以确保数据库在解析操作数的时候能够与用户预期一致，不会产生用户非预期的结果。比如下面示例没有明确数据类型就会出现异常错误。

```
SELECT date '2001-10-01' - '7' AS RESULT;
```

**表 1**  时间和日期操作符

操作符 openGauss=# SELECT date '2001-9-28' + integer '7' AS RESULT;
result
---------------------
2001-10-05 00:00:00 (1 row) openGauss=# SELECT date '2001-09-28' + interval '1 hour' AS RESULT;
result
---------------------
2001-09-28 01:00:00 (1 row) openGauss=# SELECT date '2001-09-28' + time '03:00' AS RESULT;
result
---------------------
2001-09-28 03:00:00 (1 row) openGauss=# SELECT interval '1 day' + interval '1 hour' AS RESULT;
result
----------------
1 day 01:00:00 (1 row) openGauss=# SELECT timestamp '2001-09-28 01:00' + interval '23 hours' AS RESULT;
result
---------------------
2001-09-29 00:00:00 (1 row) openGauss=# SELECT time '01:00' + interval '3 hours' AS RESULT;
result
----------
04:00:00 (1 row) openGauss=# SELECT date '2001-10-01' - date '2001-09-28' AS RESULT;
result
--------
3days (1 row) openGauss=# SELECT date '2001-10-01' - integer '7' AS RESULT;
result
---------------------
2001-09-24 00:00:00 (1 row) openGauss=# SELECT date '2001-09-28' - interval '1 hour' AS RESULT;
result
---------------------
2001-09-27 23:00:00 (1 row) openGauss=# SELECT time '05:00' - time '03:00' AS RESULT;
result
----------
02:00:00 (1 row) openGauss=# SELECT time '05:00' - interval '2 hours' AS RESULT;
result
----------
03:00:00 (1 row) openGauss=# SELECT timestamp '2001-09-28 23:00' - interval '23 hours' AS RESULT;
result
---------------------
2001-09-28 00:00:00 (1 row) openGauss=# SELECT interval '1 day' - interval '1 hour' AS RESULT;
result
----------
23:00:00 (1 row) openGauss=# SELECT timestamp '2001-09-29 03:00' - timestamp '2001-09-27 12:00' AS RESULT;
result
----------------
1 day 15:00:00 (1 row) openGauss=# SELECT 900 * interval '1 second' AS RESULT;
result
----------
00:15:00 (1 row) openGauss=# SELECT 21 * interval '1 day' AS RESULT;
result
---------
21 days (1 row) openGauss=# SELECT double precision '3.5' * interval '1 hour' AS RESULT;
result
----------
03:30:00 (1 row) openGauss=# SELECT interval '1 hour' / double precision '1.5' AS RESULT;
result
----------
00:40:00 (1 row)

## 时间/日期函数

- age\(timestamp, timestamp\)

描述：将两个参数相减，并以年、月、日作为返回值。若相减值为负，则函数返回亦为负，入参可以都带timezone或都不带timezone。

返回值类型：interval

示例：

    ```
    openGauss=# SELECT age(timestamp '2001-04-10', timestamp '1957-06-13');
               age
    -------------------------
     43 years 9 mons 27 days
    (1 row)
    ```

- age\(timestamp\)

描述：当前时间和参数相减，入参可以带或者不带timezone。

返回值类型：interval

示例：

    ```
    openGauss=# SELECT age(timestamp '1957-06-13');
               age
    -------------------------
     60 years 2 mons 18 days
    (1 row)
    ```

- clock\_timestamp\(\)

描述：实时时钟的当前时间戳。

返回值类型：timestamp with time zone

示例：

    ```
    openGauss=# SELECT clock_timestamp();
            clock_timestamp
    -------------------------------
     2017-09-01 16:57:36.636205+08
    (1 row)
    ```

- current\_date

描述：当前日期。

返回值类型：date

示例：

    ```
    openGauss=# SELECT current_date;
        date
    ------------
     2017-09-01
    (1 row)
    ```

- current\_time

描述：当前时间。

返回值类型：time with time zone

示例：

    ```
    openGauss=# SELECT current_time;
           timetz
    --------------------
     16:58:07.086215+08
    (1 row)
    ```

- current\_timestamp

描述：当前日期及时间。

返回值类型：timestamp with time zone

示例：

    ```
    openGauss=# SELECT current_timestamp;
           pg_systimestamp
    ------------------------------
     2017-09-01 16:58:19.22173+08
    (1 row)
    ```

- date\_part\(text, timestamp\)

描述：获取日期/时间值中子域的值，例如年或者小时的值。等效于extract\(field from timestamp\)。

timestamp类型：abstime、date、interval、reltime、time with time zone、time without time zone、timestamp with time zone、timestamp without time zone。

返回值类型：double precision

示例：

    ```
    openGauss=# SELECT date_part('hour', timestamp '2001-02-16 20:38:40');
     date_part
    -----------
            20
    (1 row)
    ```

- date\_part\(text, interval\)

描述：获取日期/时间值中子域的值。获取月份值时，如果月份值大于12，则取与12的模。等效于extract\(field from timestamp\)。

返回值类型：double precision

示例：

    ```
    openGauss=# SELECT date_part('month', interval '2 years 3 months');
     date_part
    -----------
             3
    (1 row)
    ```

- date\_trunc\(text, timestamp\)

描述：截取到参数text指定的精度。

返回值类型：interval、timestamp with time zone、timestamp without time zone

示例：

    ```
    openGauss=# SELECT date_trunc('hour', timestamp  '2001-02-16 20:38:40');
         date_trunc
    ---------------------
     2001-02-16 20:00:00
    (1 row)
    ```

- trunc\(timestamp\)

描述：默认按天截取。

示例：

    ```
    openGauss=# SELECT trunc(timestamp  '2001-02-16 20:38:40');                                                                                                                                                                   trunc
    ---------------------
    2001-02-16 00:00:00
    (1 row)
    ```

- daterange\(arg1, arg2\)

描述：获取时间边界信息。arg1和arg2的类型为date。

返回值类型：daterange

示例：

    ```
    openGauss=# select daterange('2000-05-06','2000-08-08');
            daterange
    -------------------------
     [2000-05-06,2000-08-08)
    (1 row)
    ```

- daterange\(arg1, arg2, text\)

描述：获取时间边界信息。arg1和arg2的类型为date，text类型为text。

返回值类型：daterange

示例：

    ```
    openGauss=# select daterange('2000-05-06','2000-08-08','[]');
            daterange
    -------------------------
     [2000-05-06,2000-08-09)
    (1 row)
    ```

- extract\(field from timestamp\)

描述：获取小时的值。

返回值类型：double precision

示例：

    ```
    openGauss=# SELECT extract(hour from timestamp '2001-02-16 20:38:40');
     date_part
    -----------
            20
    (1 row)
    ```

- extract\(field from interval\)

描述：获取月份的值。如果大于12，则取与12的模。

返回值类型：double precision

示例：

    ```
    openGauss=# SELECT extract(month from interval '2 years 3 months');
     date_part
    -----------
             3
    (1 row)
    ```

- isfinite\(date\)

描述：测试是否为有效日期。

返回值类型：Boolean

示例：

    ```
    openGauss=# SELECT isfinite(date '2001-02-16');
     isfinite
    ----------
     t
    (1 row)
    ```

- isfinite\(timestamp\)

描述：测试判断是否为有效时间。

返回值类型：Boolean

示例：

    ```
    openGauss=# SELECT isfinite(timestamp '2001-02-16 21:28:30');
     isfinite
    ----------
     t
    (1 row)
    ```

- isfinite\(interval\)

描述：测试是否为有效区间。

返回值类型：Boolean

示例：

    ```
    openGauss=# SELECT isfinite(interval '4 hours');
     isfinite
    ----------
     t
    (1 row)
    ```

- justify\_days\(interval\)

描述：将时间间隔以月（30天为一月）为单位。

返回值类型：interval

示例：

    ```
    openGauss=# SELECT justify_days(interval '35 days');
     justify_days
    --------------
     1 mon 5 days
    (1 row)
    ```

- justify\_hours\(interval\)

描述：将时间间隔以天（24小时为一天）为单位。

返回值类型：interval

示例：

    ```
    openGauss=# SELECT JUSTIFY_HOURS(INTERVAL '27 HOURS');
     justify_hours
    ----------------
     1 day 03:00:00
    (1 row)
    ```

- justify\_interval\(interval\)

描述：结合justify\_days和justify\_hours，调整interval。

返回值类型：interval

示例：

    ```
    openGauss=# SELECT JUSTIFY_INTERVAL(INTERVAL '1 MON -1 HOUR');
     justify_interval
    ------------------
     29 days 23:00:00
    (1 row)
    ```

- localtime

描述：当前时间。

返回值类型：time

示例：

    ```
    openGauss=# SELECT localtime AS RESULT;
         result
    ----------------
     16:05:55.664681
    (1 row)
    ```

- localtimestamp

描述：当前日期及时间。

返回值类型：timestamp

示例：

    ```
    openGauss=# SELECT localtimestamp;
             timestamp
    ----------------------------
     2017-09-01 17:03:30.781902
    (1 row)
    ```

- now\(\)

描述：当前日期及时间。

返回值类型：timestamp with time zone

示例：

    ```
    openGauss=# SELECT now();
                  now
    -------------------------------
     2017-09-01 17:03:42.549426+08
    (1 row)
    ```

- timenow

描述：当前日期及时间。

返回值类型：timestamp with time zone

示例：

    ```
    openGauss=# select timenow();
            timenow
    ------------------------
     2020-06-23 20:36:56+08
    (1 row)
    ```

- numtodsinterval\(num, interval\_unit\)

描述：将数字转换为interval类型。num为numeric类型数字，interval\_unit为固定格式字符串（'DAY' | 'HOUR' | 'MINUTE' | 'SECOND'）。

可以通过设置参数[IntervalStyle](../database_reference/locale_and_formatting.md)为a，兼容该函数interval输出格式。

示例：

    ```
    openGauss=# SELECT numtodsinterval(100, 'HOUR');
     numtodsinterval
    -----------------
     100:00:00
    (1 row)

    openGauss=# SET intervalstyle = a;
    SET
    openGauss=# SELECT numtodsinterval(100, 'HOUR');
            numtodsinterval
    -------------------------------
     +000000004 04:00:00.000000000
    (1 row)
    ```

- pg\_sleep\(seconds\)

描述：服务器线程延迟时间，单位为秒。

返回值类型：void

示例：

    ```
    openGauss=# SELECT pg_sleep(10);
     pg_sleep
    ----------

    (1 row)
    ```

- statement\_timestamp\(\)

描述：当前日期及时间。

返回值类型：timestamp with time zone

示例：

    ```
    openGauss=# SELECT statement_timestamp();
          statement_timestamp
    -------------------------------
     2017-09-01 17:04:39.119267+08
    (1 row)
    ```

- sysdate

描述：当前日期及时间。

返回值类型：timestamp

示例：

    ```
    openGauss=# SELECT sysdate;
           sysdate
    ---------------------
     2017-09-01 17:04:49
    (1 row)
    ```

- timeofday\(\)

描述：当前日期及时间（像clock\_timestamp，但是返回时为text）。

返回值类型：text

示例：

    ```
    openGauss=# SELECT timeofday();
                  timeofday
    -------------------------------------
     Fri Sep 01 17:05:01.167506 2017 CST
    (1 row)
    ```

- transaction\_timestamp\(\)

描述：当前日期及时间，与current\_timestamp等效。

返回值类型：timestamp with time zone

示例：

    ```
    openGauss=# SELECT transaction_timestamp();
         transaction_timestamp
    -------------------------------
     2017-09-01 17:05:13.534454+08
    (1 row)
    ```

- add\_months\(d,n\)

描述：用于计算时间点d再加上n个月的时间。

d：timestamp类型的值，以及可以隐式转换为timestamp类型的值。

n：INTEGER类型的值，以及可以隐式转换为INTEGER类型的值。

返回值类型：timestamp

示例：

    ```
    openGauss=# SELECT add_months(to_date('2017-5-29', 'yyyy-mm-dd'), 11) FROM sys_dummy;
         add_months
    ---------------------
     2018-04-29 00:00:00
    (1 row)
    ```

- last\_day\(d\)

描述：用于计算时间点d当月最后一天的时间。

返回值类型：timestamp

示例：

    ```
    openGauss=# select last_day(to_date('2017-01-01', 'YYYY-MM-DD')) AS cal_result;
         cal_result
    ---------------------
     2017-01-31 00:00:00
    (1 row)
    ```

- new_time(date, timezone1,timezone2)

描述: 将date从timezone1转换为timezone2对应的日期时间。

参数类型：timestamp without time zone, text, text

返回值类型: timestamp without time zone

示例:

    ```
    openGauss=# select new_time('2024-07-22 14:00:00', 'EST', 'PST');
          new_time
    ---------------------
     2024-07-22 11:00:00
    (1 row)
    ```

> [!NOTE]说明
>
> 1.该函数仅在A兼容模式下支持，即 dbcompatibility = 'A'。
>
> 2.入参date不能是timestamp with time zone类型。

- next\_day\(x,y\)

描述：用于计算时间点x开始的下一个星期几（y）的时间。

返回值类型：timestamp

示例：

    ```
    openGauss=# select next_day(timestamp '2017-05-25 00:00:00','Sunday')AS cal_result;
         cal_result
    ---------------------
     2017-05-28 00:00:00
    (1 row)
    ```

- tinterval\(abstime, abstime \)

描述：用两个绝对时间创建时间间隔。

返回值类型：tinterval

示例：

    ```
    openGauss=# call tinterval(abstime 'May 10, 1947 23:59:12', abstime 'Mon May  1 00:30:30 1995');
                          tinterval
    -----------------------------------------------------
     ["1947-05-10 23:59:12+09" "1995-05-01 00:30:30+08"]
    (1 row)
    ```

- tintervalend\(tinterval\)

描述：返回tinteval的结束时间。

返回值类型：abstime

示例：

    ```
    openGauss=# select tintervalend('["Sep 4, 1983 23:59:12" "Oct4, 1983 23:59:12"]');
          tintervalend
    ------------------------
     1983-10-04 23:59:12+08
    (1 row)
    ```

- tintervalrel\(tinterval\)

描述：计算并返回tinterval的相对时间。

返回值类型：reltime

示例：

    ```
    openGauss=# select tintervalrel('["Sep 4, 1983 23:59:12" "Oct4, 1983 23:59:12"]');
     tintervalrel
    --------------
     1 mon
    (1 row)
    ```

- smalldatetime\_ge

描述：判断是否第一个参数大于等于第二个参数。

参数：smalldatetime, smalldatetime

返回值类型：boolean

- smalldatetime\_cmp

描述：对比smalldatetime是否相等。

参数：smalldatetime, smalldatetime

返回值类型：integer

- smalldatetime\_eq

描述：对比smalldatetime是否相等。

参数：smalldatetime, smalldatetime

返回值类型：boolean。

- smalldatetime\_gt

描述：判断是否第一个参数大于第二个参数。

参数：smalldatetime, smalldatetime

返回值类型：boolean

- smalldatetime\_hash

描述：计算timestamp对应的哈希值。

参数：smalldatetime

返回值类型：integer

- smalldatetime\_in

描述：输入timestamp。

参数：cstring, oid, integer

返回值类型：smalldatetime

- smalldatetime\_larger

描述：返回较大的timestamp。

参数：smalldatetime, smalldatetime

返回值类型：smalldatetime

- smalldatetime\_le

描述：判断是否第一个参数小于等于第二个参数。

参数：smalldatetime, smalldatetime

返回值类型：boolean

- smalldatetime\_lt

描述：判断是否第一个参数小于第二个参数。

参数：smalldatetime, smalldatetime

返回值类型：boolean

- smalldatetime\_ne

描述：比较两个timestamp是否不相等。

参数：smalldatetime, smalldatetime

返回值类型：boolean

- smalldatetime\_out

描述：timestamp转换为外部形式。

参数：smalldatetime

返回值类型：cstring

- smalldatetime\_send

描述：timestamp转换为二进制格式。

参数：smalldatetime

返回值类型：bytea

- smalldatetime\_smaller

描述：返回较小的一个smalldatetime。

参数：smalldatetime, smalldatetime

返回值类型：smalldatetime

- smalldatetime\_to\_abstime

描述：smalldatetime转换为abstime。

参数：smalldatetime

返回值类型：abstime

- smalldatetime\_to\_time

描述：smalldatetime转换为time。

参数：smalldatetime

返回值类型：time without time zone

- smalldatetime\_to\_timestamp

描述：smalldatetime转换为timestamp。

参数：smalldatetime

返回值类型：timestamp without time zone

- smalldatetime\_to\_timestamptz

描述：smalldatetime转换为timestamptz。

参数：smalldatetime

返回值类型：timestamp with time zone

- smalldatetime\_to\_varchar2

描述：smalldatetime转换为varchar2。

参数：smalldatetime

返回值类型：character varying

>[!NOTE]说明
>
>获取当前时间有多种方式，请根据实际业务从场景选择合适的接口：
>
>1. 以下接口按照当前事务的开始时刻返回值：
>
> ```
> CURRENT_DATE CURRENT_TIME CURRENT_TIME(precision) CURRENT_TIMESTAMP(precision) LOCALTIME LOCALTIMESTAMP LOCALTIME(precision) LOCALTIMESTAMP(precision)
>  ```
>
> 其中CURRENT\_TIME和CURRENT\_TIMESTAMP(precision)传递带有时区的值；LOCALTIME和LOCALTIMESTAMP传递的值不带时区。CURRENT\_TIME、LOCALTIME和 LOCALTIMESTAMP可以有选择地接受一个精度参数， 该精度导致结果的秒域被园整为指定小数位。如果没有精度参数，结果将被给予所能得到的全部精度。
> 因为这些函数全部都按照当前事务的开始时刻返回结果，所以它们的值在事务运行的整个期间内都不改变。 我们认为这是一个特性：目的是为了允许一个事务在“当前”时间上有一致的概念， 这样在同一个事务里的多个修改可以保持同样的时间戳。
>
>2. 以下接口返回当前语句开始时间：
>
> ```
> transaction_timestamp() statement_timestamp() now()
>  ```
>
> 其中transaction\_timestamp\(\)等价于CURRENT\_TIMESTAMP(precision)，但是其命名清楚地反映了它的返回值。statement\_timestamp\(\)返回当前语句的开始时刻（更准确的说是收到 客户端最后一条命令的时间）。statement\_timestamp\(\)和transaction\_timestamp\(\)在一个事务的第一条命令期间返回值相同，但是在随后的命令中却不一定相同。
> now\(\)等效于transaction\_timestamp\(\)。
> 1. 以下接口返回函数被调用时的真实当前时间：
>
>      ```
>      clock_timestamp() timeofday()
>      ```
>
>      clock\_timestamp\(\)返回真正的当前时间，因此它的值甚至在同一条 SQL 命令中都会变化。timeofday\(\)和clock\_timestamp\(\)相似，timeofday\(\)也返回真实的当前时间，但是它的结果是一个格式化的text串，而不是timestamp with time zone值。

## TIMESTAMPDIFF

- **TIMESTAMPDIFF\(**_unit , timestamp\_expr1, timestamp\_expr2_**\)**

timestampdiff函数是计算两个日期时间之间\(timestamp\_expr2-timestamp\_expr1\)的差值，并以unit形式返回结果。timestamp\_expr1，timestamp\_expr2必须是一个timestamp、timestamptz、date类型的值表达式。unit表示的是两个日期差的单位。

>[!NOTE]说明
>
>该函数仅在openGauss兼容MY类型时（即dbcompatibility = 'B'）有效，其他类型不支持该函数。
>该函数仅在GUC参数[dolphin.b_compatibility_mode](https://docs.opengauss.org/zh/docs/latest/extension_reference/dolphin_guc_parameters.html#section203671436825)为true/on时，才可正确兼容MySQL。

- year

年份。

    ```
    openGauss=#  SELECT TIMESTAMPDIFF(YEAR, '2018-01-01', '2020-01-01');
     timestamp_diff
    ----------------
                  2
    (1 row)
    ```

- quarter

季度。

    ```
    openGauss=#  SELECT TIMESTAMPDIFF(QUARTER, '2018-01-01', '2020-01-01');
     timestamp_diff
    ----------------
                  8
    (1 row)
    ```

- month

月份。

    ```
    openGauss=#  SELECT TIMESTAMPDIFF(MONTH, '2018-01-01', '2020-01-01');
     timestamp_diff
    ----------------
                 24
    (1 row)
    ```

- week

星期。

    ```
    openGauss=#  SELECT TIMESTAMPDIFF(WEEK, '2018-01-01', '2020-01-01');
     timestamp_diff
    ----------------
                104
    (1 row)
    ```

- day

天。

    ```
    openGauss=#  SELECT TIMESTAMPDIFF(DAY, '2018-01-01', '2020-01-01');
     timestamp_diff
    ----------------
                730
    (1 row)
    ```

- hour

小时。

    ```
    openGauss=#  SELECT TIMESTAMPDIFF(HOUR, '2020-01-01 10:10:10', '2020-01-01 11:11:11');
     timestamp_diff
    ----------------
                  1
    (1 row)

    ```

- minute

分钟。

    ```
    openGauss=#  SELECT TIMESTAMPDIFF(MINUTE, '2020-01-01 10:10:10', '2020-01-01 11:11:11');
     timestamp_diff
    ----------------
                 61
    (1 row)

    ```

- second

秒。

    ```
    openGauss=#  SELECT TIMESTAMPDIFF(SECOND, '2020-01-01 10:10:10', '2020-01-01 11:11:11');
     timestamp_diff
    ----------------
               3661
    (1 row)

    ```

- microseconds

秒域（包括小数部分）乘以1,000,000。

    ```
    openGauss=#  SELECT TIMESTAMPDIFF(MICROSECOND, '2020-01-01 10:10:10.000000', '2020-01-01 10:10:10.111111');
     timestamp_diff
    ----------------
             111111
    (1 row)

    ```

- timestamp\_expr含有时区

    ```
    openGauss=# SELECT TIMESTAMPDIFF(HOUR,'2020-05-01 10:10:10-01','2020-05-01 10:10:10-03');
     timestamp_diff
    ----------------
                  2
    (1 row)
    ```

## EXTRACT

- **EXTRACT**\(field **FROM** source\)

extract函数从日期或时间的数值里抽取子域，比如年、小时等。source必须是一个timestamp、time或interval类型的值表达式（类型为date的表达式转换为timestamp，因此也可以用）。field是一个标识符或者字符串，它指定从源数据中抽取的域。对于大部分field，extract函数返回类型为double precision的数值。对于TIMEZONE\_REGION,TIMEZONE\_ABBR这些field，extract函数返回text类型。field的取值范围如下所示。

- century

世纪。

第一个世纪从0001-01-01 00:00:00 AD开始。这个定义适用于所有使用阳历的国家。没有0世纪，直接从公元前1世纪到公元1世纪。

示例：

    ```
    openGauss=# SELECT EXTRACT(CENTURY FROM TIMESTAMP '2000-12-16 12:21:13');
     date_part
    -----------
            20
    (1 row)
    ```

- day
  - 如果source为timestamp，表示月份里的日期（1-31）。

        ```
        openGauss=# SELECT EXTRACT(DAY FROM TIMESTAMP '2001-02-16 20:38:40');
         date_part
        -----------
                16
        (1 row)
        ```

  - 如果source为interval，表示天数。

        ```
        openGauss=# SELECT EXTRACT(DAY FROM INTERVAL '40 days 1 minute');
         date_part
        -----------
                40
        (1 row)
        ```

- decade

年份除以10。

    ```
    openGauss=# SELECT EXTRACT(DECADE FROM TIMESTAMP '2001-02-16 20:38:40');
     date_part
    -----------
           200
    (1 row)
    ```

- dow

每周的星期几，星期天（0）到星期六（6）。

    ```
    openGauss=# SELECT EXTRACT(DOW FROM TIMESTAMP '2001-02-16 20:38:40');
     date_part
    -----------
             5
    (1 row)
    ```

- doy

一年的第几天（1\~365/366）。

    ```
    openGauss=# SELECT EXTRACT(DOY FROM TIMESTAMP '2001-02-16 20:38:40');
     date_part
    -----------
            47
    (1 row)
    ```

- epoch
  - 如果source为timestamp with time zone，表示自1970-01-01 00:00:00-00 UTC以来的秒数（结果可能是负数）；

如果source为date和timestamp，表示自1970-01-01 00:00:00-00当地时间以来的秒数；

如果source为interval，表示时间间隔的总秒数。

        ```
        openGauss=# SELECT EXTRACT(EPOCH FROM TIMESTAMP WITH TIME ZONE '2001-02-16 20:38:40.12-08');
          date_part
        --------------
         982384720.12
        (1 row)
        ```

        ```
        openGauss=# SELECT EXTRACT(EPOCH FROM INTERVAL '5 days 3 hours');
         date_part
        -----------
            442800
        (1 row)
        ```

  - 将epoch值转换为时间戳的方法。

        ```
        openGauss=# SELECT TIMESTAMP WITH TIME ZONE 'epoch' + 982384720.12 * INTERVAL '1 second' AS RESULT;
                  result
        ---------------------------
         2001-02-17 12:38:40.12+08
        (1 row)
        ```

- hour

小时域（0-23）。

    ```
    openGauss=# SELECT EXTRACT(HOUR FROM TIMESTAMP '2001-02-16 20:38:40');
     date_part
    -----------
            20
    (1 row)
    ```

- isodow

一周的第几天（1-7）。

星期一为1，星期天为7。

  >[!NOTE]说明
  >
  >除了星期天外，都与dow相同。

  ```
  openGauss=# SELECT EXTRACT(ISODOW FROM TIMESTAMP '2001-02-18 20:38:40');
   date_part
  -----------
           7
  (1 row)
  ```

- isoyear

日期中的ISO 8601标准年（不适用于间隔）。

每个带有星期一开始的周中包含1月4日的ISO年，所以在年初的1月或12月下旬的ISO年可能会不同于阳历的年。详细信息请参见后续的week描述。

    ```
    openGauss=# SELECT EXTRACT(ISOYEAR FROM DATE '2006-01-01');
     date_part
    -----------
          2005
    (1 row)
    ```

    ```
    openGauss=# SELECT EXTRACT(ISOYEAR FROM DATE '2006-01-02');
     date_part
    -----------
          2006
    (1 row)
    ```

- microseconds

秒域（包括小数部分）乘以1,000,000。

    ```
    openGauss=# SELECT EXTRACT(MICROSECONDS FROM TIME '17:12:28.5');
     date_part
    -----------
      28500000
    (1 row)
    ```

- millennium

千年。

20世纪（19xx年）里面的年份在第二个千年里。第三个千年从2001年1月1日零时开始。

    ```
    openGauss=# SELECT EXTRACT(MILLENNIUM FROM TIMESTAMP '2001-02-16 20:38:40');
     date_part
    -----------
             3
    (1 row)
    ```

- milliseconds

秒域（包括小数部分）乘以1000。请注意它包括完整的秒。

    ```
    openGauss=# SELECT EXTRACT(MILLISECONDS FROM TIME '17:12:28.5');
     date_part
    -----------
         28500
    (1 row)
    ```

- minute

分钟域（0-59）。

    ```
    openGauss=# SELECT EXTRACT(MINUTE FROM TIMESTAMP '2001-02-16 20:38:40');
     date_part
    -----------
            38
    (1 row)
    ```

- month

如果source为timestamp，表示一年里的月份数（1-12）。

    ```
    openGauss=# SELECT EXTRACT(MONTH FROM TIMESTAMP '2001-02-16 20:38:40');
     date_part
    -----------
             2
    (1 row)
    ```

如果source为interval，表示月的数目，然后对12取模（0-11）。

    ```
    openGauss=# SELECT EXTRACT(MONTH FROM INTERVAL '2 years 13 months');
     date_part
    -----------
             1
    (1 row)
    ```

- quarter

该天所在的该年的季度（1-4）。

    ```
    openGauss=# SELECT EXTRACT(QUARTER FROM TIMESTAMP '2001-02-16 20:38:40');
     date_part
    -----------
             1
    (1 row)
    ```

- second

秒域，包括小数部分（0-59）。

    ```
    openGauss=# SELECT EXTRACT(SECOND FROM TIME '17:12:28.5');
     date_part
    -----------
          28.5
    (1 row)
    ```

- timezone

与UTC的时区偏移量，单位为秒。正数对应UTC东边的时区，负数对应UTC西边的时区。

- timezone\_hour

支持时间戳类型的输入，比如timestamptz或timetz。对于timestamptz类型，返回的是 **当前会话** 的时区偏移量的小时部分，而不是输入的时区偏移量的小时部分。对于timetz类型，返回输入的时区偏移量的小时部分。对于其他时间戳类型，会先将输入转换为timestamptz或timetz，再返回时区偏移量的小时部分。

    ```
    SET TIMEZONE TO 'Asia/Beijing';
    SELECT EXTRACT(TIMEZONE_HOUR FROM TIMESTAMPTZ '2024-09-02 10:30:00 Europe/London');
     date_part
    -----------
             8
    (1 row)
    ```

- timezone\_minute

支持时间戳类型的输入，比如timestamptz或timetz。对于timestamptz类型，返回的是 **当前会话** 的时区偏移量的分钟部分，而不是输入的时区偏移量的分钟部分。对于timetz类型，返回输入的时区偏移量的分钟部分。对于其他时间戳类型，会先将输入转换为timestamptz或timetz，再返回时区偏移量的分钟部分。

    ```
    SET TIMEZONE TO 'Asia/Beijing';
    SELECT EXTRACT(TIMEZONE_MINUTE FROM TIMESTAMPTZ '2024-09-02 10:30:00 Europe/London');
     date_part
    -----------
             0
    (1 row)
    ```

- week

该天在所在的年份里是第几周。ISO 8601定义一年的第一周包含该年的一月四日（ISO-8601 的周从星期一开始）。换句话说，一年的第一个星期四在第一周。

在ISO定义里，一月的头几天可能是前一年的第52或者第53周，十二月的后几天可能是下一年第一周。比如，2005-01-01是2004年的第53周，而2006-01-01是2005年的第52周，2012-12-31是2013年的第一周。建议isoyear字段和week一起使用以得到一致的结果。

    ```
    openGauss=# SELECT EXTRACT(WEEK FROM TIMESTAMP '2001-02-16 20:38:40');
     date_part
    -----------
             7
    (1 row)
    ```

- year

年份域。

    ```
    openGauss=# SELECT EXTRACT(YEAR FROM TIMESTAMP '2001-02-16 20:38:40');
     date_part
    -----------
          2001
    (1 row)
    ```

- timezone\_region

支持时间戳类型的输入，比如timestamptz或timetz。对于timestamptz类型，返回 **当前会话** 的时区，而不是输入的时区。这点与timezone\_hour，timezone\_minute类似。对于timetz类型，由于类型本身不包含时区地点的信息，所以返回Unknown。对于其他时间戳类型，会先将输入转换为timestamptz或timetz，再返回对应的结果。

    ```
    SET TIMEZONE TO 'Asia/Beijing';
    SELECT EXTRACT(TIMEZONE_REGION FROM TIMESTAMPTZ '2024-09-02 10:30:00 Europe/London');
    timezone_extract
    ------------------
    Asia/Beijing
    (1 row)

    SET TIMEZONE TO 'UTC';
    SELECT EXTRACT(TIMEZONE_REGION FROM TIMESTAMPTZ '2024-09-02 10:30:00 Europe/London');
    timezone_extract
    ------------------
    UTC
    (1 row)

    SELECT EXTRACT(TIMEZONE_REGION FROM TIMESTAMPTZ 'infinity');
    timezone_extract
    ------------------
    Unknown
    (1 row)
    ```

- timezone\_abbr

类似timezone\_region， 支持时间戳类型的输入，比如timestamptz或timetz。对于timestamptz类型，返回 **当前会话** 的时区缩写，而不是输入的时区缩写。这点与timezone\_hour，timezone\_minute类似。对于timetz类型，由于类型本身不包含时区地点的信息，所以返回Unknown。对于其他时间戳类型，会先将输入转换为timestamptz或timetz，再返回对应的结果。

    ```
    SET TIMEZONE TO 'Asia/Beijing';
    SELECT EXTRACT(TIMEZONE_ABBR FROM TIMESTAMPTZ '2024-09-02 10:30:00 Europe/London');
    timezone_extract
    ------------------
    CST
    (1 row)

    SET TIMEZONE TO 'UTC';
    SELECT EXTRACT(TIMEZONE_ABBR FROM TIMESTAMPTZ '2024-09-02 10:30:00 Europe/London');
    timezone_extract
    ------------------
    UTC
    (1 row)

    SELECT EXTRACT(TIMEZONE_ABBR FROM TIMESTAMPTZ 'infinity');
    timezone_extract
    ------------------
    Unknown
    (1 row)
    ```

## date\_part

date\_part函数是在传统的Ingres函数的基础上制作的（该函数等效于SQL标准函数extract）：

- **date\_part**\('field', source\)

这里的field参数必须是一个字符串，而不是一个名称。有效的field与extract一样，详细信息请参见[EXTRACT](#zh-cn_topic_0283136846_zh-cn_topic_0237121972_zh-cn_topic_0059779084_scb40477163d740de80f0e984cad28e7b)。

示例：

```
openGauss=# SELECT date_part('day', TIMESTAMP '2001-02-16 20:38:40');
 date_part
-----------
        16
(1 row)
```

```
openGauss=# SELECT date_part('hour', INTERVAL '4 hours 3 minutes');
 date_part
-----------
         4
(1 row)
```

[表3](#zh-cn_topic_0283136846_zh-cn_topic_0237121972_zh-cn_topic_0059779084_t2e5425ae98464c3dab59352ff3bfa786)显示了可以用于格式化日期和时间值的模版。

**表 3**  用于日期/时间格式化的模式

一天的小时数（01-12） HH12 一天的小时数（01-12） HH24 一天的小时数（00-23） 分钟（00-59） 秒（00-59） 微秒（000000-999999） SSSSS 午夜后的秒（0-86399） 上、下午 AM或A.M.
上午标识 PM或P.M.
下午标识 Y,YYY 带逗号的年（4和更多位） SYYYY 公元前四位年 YYYY 年（4和更多位） YYY 年的后三位 年的后两位 年的最后一位 IYYY ISO年（4位或更多位） IYY ISO年的最后三位 ISO年的最后两位 ISO年的最后一位 年的后两位（可在21世纪存储20世纪的年份） RRRR 可接收4位年或两位年。若是两位，则和RR的返回值相同，若是四位，则和YYYY相同。
BC或B.C.AD或A.D.
纪元标识。BC（公元前），AD（公元后）。
MONTH 全长大写月份名（空白填充为9字符） MON 大写缩写月份名（3字符） 月份数（01-12） 罗马数字的月份（I-XII ；I=JAN）（大写） DAY 全长大写日期名（空白填充为9字符） 缩写大写日期名（3字符） DDD 一年里的日（001-366） 一个月里的日（01-31） 一周里的日（1-7 ；周日是 1） 一个月里的周数（1-5）（第一周从该月第一天开始） 一年里的周数（1-53）（第一周从该年的第一天开始） ISO一年里的周数（第一个星期四在第一周里） 世纪（2位）（21 世纪从 2001-01-01 开始） 儒略日 儒略日（自公元前 4712 年 1 月 1 日来的天数）

>[!NOTE]说明
>
>上表中RR计算年的规则如下：
>
>- 输入的两位年份在00\~49之间：当前年份的后两位在00\~49之间，返回值年份的前两位和当前年份的前两位相同；当前年份的后两位在50\~99之间，返回值年份的前两位是当前年份的前两位加1。
>
>- 输入的两位年份在50\~99之间：当前年份的后两位在00\~49之间，返回值年份的前两位是当前年份的前两位减1；当前年份的后两位在50\~99之间，返回值年份的前两位和当前年份的前两位相同。

## timezone\_extract

timezone_extract是对EXTRACT函数的扩展，支持TIMEZONE\_REGION和TIMEZONE\_ABBR两种新格式。当使用TIMEZONE\_REGION和TIMEZONE\_ABBR关键字时，EXTRACT会调用timezone_extract函数。该功能允许从带有时区信息的时间戳中提取时区的区域名称（如 "America/New_York"）或缩写（如 "EST"）。

- **timezone\_extract\('**_field_**', **_source_**\)**

这里的field参数必须是一个字符串，而不是一个名称。有效的field有TIMEZONE\_REGION和TIMEZONE\_ABBR。

示例：

```
SET TIMEZONE TO 'Asia/Beijing';
SELECT timezone_extract('TIMEZONE_REGION', TIMESTAMPTZ '2024-09-02 10:30:00 Europe/London');
timezone_extract
------------------
Asia/Beijing
(1 row)

SET TIMEZONE TO 'UTC';
SELECT timezone_extract('TIMEZONE_REGION', TIMESTAMPTZ '2024-09-02 10:30:00 Europe/London');
timezone_extract
------------------
UTC
(1 row)
```

```
SET TIMEZONE TO 'Asia/Beijing';
SELECT timezone_extract('TIMEZONE_ABBR', TIMESTAMPTZ '2024-09-02 10:30:00 Europe/London');
timezone_extract
------------------
CST
(1 row)

SET TIMEZONE TO 'UTC';
SELECT timezone_extract('TIMEZONE_ABBR', TIMESTAMPTZ '2024-09-02 10:30:00 Europe/London');
timezone_extract
------------------
UTC
(1 row)
```
