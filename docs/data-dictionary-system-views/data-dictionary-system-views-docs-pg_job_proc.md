# PG\_JOB\_PROC

PG\_JOB\_PROC系统表对应PG\_JOB表中每个任务的作业内容（包括：PL/SQL代码块、匿名块）。将存储过程信息独立出来，如果放到PG\_JOB中，被加载到共享内存的时候，会占用不必要的空间，所以在使用的时候再进行查询获取。

**表 1**  PG\_JOB\_PROC字段

oid oid 行标识符（隐含属性，必须明确选择）。
job_id integer 外键，关联pg_job表中的job_id。
what text 作业内容，定时任务中的程序内容。
job_name text 定时任务或程序名称。
