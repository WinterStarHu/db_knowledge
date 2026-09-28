# CREATE TRIGGER

## 功能描述

创建一个触发器。 触发器将与指定的表或视图关联，并在特定条件下执行指定的函数。

## 注意事项

- 当前仅支持在普通行存表上创建触发器，不支持在列存表、临时表、unlogged表等类型表上创建触发器。
- 如果为同一事件定义了多个相同类型的触发器，则按触发器的名称字母顺序触发它们。
- 触发器常用于多表间数据关联同步场景，对SQL执行性能影响较大，不建议在大数据量同步及对性能要求高的场景中使用。
- 执行创建触发器操作的用户需要拥有指定表的TRIGGER权限或被授予了CREATE ANY TRIGGER权限。
- 当使用WHEN ( condition )时，此处的括号不能省略，condition需要被括号括起。

## 语法格式

- **o风格创建触发器的语法**

```
CREATE [ CONSTRAINT ] TRIGGER trigger_name { BEFORE | AFTER | INSTEAD OF } { event [ OR ... ] }
    ON table_name
    [ FROM referenced_table_name ]
    { NOT DEFERRABLE | [ DEFERRABLE ] { INITIALLY IMMEDIATE | INITIALLY DEFERRED } }
    [ FOR [ EACH ] { ROW | STATEMENT } ]
    [ WHEN ( condition ) ]
    EXECUTE { PROCEDURE | FUNCTION } function_name ( arguments );
```

- **兼容mysql兼容风格的创建触发器的语法**

```
CREATE [ CONSTRAINT ] [ DEFINER=user ] TRIGGER [ IF NOT EXISTS ] trigger_name { BEFORE | AFTER | INSTEAD OF } { event [ OR ... ] }
    ON table_name
    [ FROM referenced_table_name ]
    { NOT DEFERRABLE | [ DEFERRABLE ] { INITIALLY IMMEDIATE | INITIALLY DEFERRED } }
    [ FOR [ EACH ] { ROW | STATEMENT } ]
    [ WHEN ( condition ) ]
    [ trigger_order ]
    trigger_body
```

其中event包含以下几种：

```
    INSERT
    UPDATE [ OF column_name [, ... ] ]
    DELETE
    TRUNCATE
```

其中trigger_order是：

```
    { FOLLOWS|PRECEDES } other_trigger_name
```

## 参数说明

- **CONSTRAINT**

可选项，指定此参数将创建约束触发器，即触发器作为约束来使用。除了可以使用SET CONSTRAINTS调整触发器触发的时间之外，这与常规触发器相同。 约束触发器必须是AFTER ROW触发器。

- **DEFINER**

可选项，指定此参数可以影响触发器内引用对象的权限控制。

- **IF NOT EXISTS**

可选项，指定此参数如果触发器在相同的模式中具有相同的名称、相同的表、相同的表，则防止发生错误。

- **trigger\_name**

触发器名称，该名称在mysql兼容风格语法中可以指定模式，触发器模式必须与其所在表的模式相同，若不限定模式，触发器自动继承其所在表的模式，同一个表的触发器不能重名。对于约束触发器，使用[SET CONSTRAINTS](set_constraints.md)修改触发器行为时也使用此名称。

取值范围：符合标识符命名规范的字符串，且最大长度不超过63个字符。

- **BEFORE**

触发器函数是在触发事件发生前执行。

- **AFTER**

触发器函数是在触发事件发生后执行，约束触发器只能指定为AFTER。

- **INSTEAD OF**

触发器函数直接替代触发事件。

- **event**

启动触发器的事件，取值范围包括：INSERT、UPDATE、DELETE或TRUNCATE，也可以通过OR同时指定多个触发事件。

对于UPDATE事件类型，可以使用下面语法指定列：

    ```
    UPDATE OF column_name1 [, column_name2 ... ]
    ```

表示当这些列作为UPDATE语句的目标列时，才会启动触发器，但是INSTEAD OF UPDATE类型不支持指定列信息。如果UPDATE OF指定的列包含生成列，当生成列依赖的列是UPDATE语句的目标列时，也会启动触发器。

- **table\_name**

需要创建触发器的表名称。

取值范围：数据库中已经存在的表名称。

- **referenced\_table\_name**

约束引用的另一个表的名称。 只能为约束触发器指定，常见于外键约束。

取值范围：数据库中已经存在的表名称。

- **DEFERRABLE | NOT DEFERRABLE**

约束触发器的启动时机，仅作用于约束触发器。这两个关键字设置该约束是否可推迟。

详细介绍请参见[CREATE TABLE](create_table.md)。

- **INITIALLY IMMEDIATE** **| INITIALLY DEFERRED**

如果约束是可推迟的，则这个子句声明检查约束的缺省时间，仅作用于约束触发器。

详细介绍请参见[CREATE TABLE](create_table.md)。

- **FOR EACH ROW | FOR EACH STATEMENT**

触发器的触发频率。

  - FOR EACH ROW是指该触发器是受触发事件影响的每一行触发一次。
  - FOR EACH STATEMENT是指该触发器是每个SQL语句只触发一次。

未指定时默认值为FOR EACH STATEMENT。约束触发器只能指定为FOR EACH ROW。

- **condition**

决定是否实际执行触发器函数的条件表达式。当指定WHEN时，只有在条件返回true时才会调用该函数。

在FOR EACH ROW触发器中，WHEN条件可以通过分别写入OLD.column\_name或NEW.column\_name来引用旧行或新行值的列。 当然，INSERT触发器不能引用OLD和DELETE触发器不能引用NEW。

INSTEAD OF触发器不支持WHEN条件。

WHEN表达式不能包含子查询。

对于约束触发器，WHEN条件的评估不会延迟，而是在执行更新操作后立即发生。 如果条件返回值不为true，则触发器不会排队等待延迟执行。

- **function\_name**

用户定义的函数，必须声明为不带参数并返回类型为触发器，在触发器触发时执行。

在`CREATE TRIGGER`语法中，关键字`PROCEDURE`和`FUNCTION`具有相同的含义与作用。

- **arguments**

执行触发器时要提供给函数的可选的以逗号分隔的参数列表。参数是文字字符串常量，简单的名称和数字常量也可以写在这里，但它们都将被转换为字符串。 请检查触发器函数的实现语言的描述，以了解如何在函数内访问这些参数。

- **trigger\_order**

可选项，trigger_order特征中的{FOLLOWS|PRECEDES}控制触发器的优先触发顺序，mysql兼容性模式下允许对同一个表，在同一触发事件定义多个触发器，会按照触发器创建的先后顺序来决定触发的优先顺序（先创建的优先）。可以通过{FOLLOWS|PRECEDES}来调整优先级。使用FOLLOWS，最后一次使用的触发器与原始触发器最紧挨着，其他的触发器的优先级都顺序向后挤压；使用PRECEDES，最后一次使用的触发器与原始触发器最紧挨着，其他的触发器的优先级都顺序向前挤压。

- **trigger\_body**

直接通过在begin...end之间书写代码块，定义触发器之后要完成的工作。

**表 1**  表和视图上支持的触发器种类：

  >[!NOTE]说明
  >
  >关于触发器种类：
  >
  >- INSTEAD OF的触发器必须标记为FOR EACH ROW，并且只能在视图上定义。
  >- BEFORE和AFTER触发器作用在视图上时，只能标记为FOR EACH STATEMENT。
  >- TRUNCATE类型触发器仅限FOR EACH STATEMENT。

触发时机 触发事件 语句级 BEFORE INSERT/UPDATE/DELETE 表和视图 TRUNCATE 不支持 AFTER INSERT/UPDATE/DELETE 表和视图 TRUNCATE 不支持 INSTEAD OF INSERT/UPDATE/DELETE 不支持 TRUNCATE 不支持 不支持

**表 2**  PLPGSQL类型触发器函数特殊变量：

变量名 变量含义 NEW INSERT及UPDATE操作涉及tuple信息中的新值，对DELETE为空。
OLD UPDATE及DELETE操作涉及tuple信息中的旧值，对INSERT为空。
TG_NAME 触发器名称。
TG_WHEN 触发器触发时机（BEFORE/AFTER/INSTEAD OF）。
TG_LEVEL 触发频率（ROW/STATEMENT）。
TG_OP 触发操作（INSERT/UPDATE/DELETE/TRUNCATE）。
TG_RELID 触发器所在表OID。
TG_RELNAME 触发器所在表名（已废弃，现用TG_TABLE_NAME替代）。
TG_TABLE_NAME 触发器所在表名。
TG_TABLE_SCHEMA 触发器所在表的SCHEMA信息。
TG_NARGS 触发器函数参数个数。
TG_ARGV[] 触发器函数参数列表。

**触发器函数的返回值规则如下：**

- 语句级触发器：由语句级触发器调用的触发器函数应始终返回 NULL。
- 行级触发器：
  - BEFORE 触发器：
  - 返回 NULL，以跳过对当前行的操作（INTERT、UPDATE或DELETE）。注意：如上表2所述，变量NEW对DELETE为空，变量OLD对INTERT为空。
  - 对于行级 INSERT 和 UPDATE 触发器，返回的行将成为要插入或替换正在更新的行，允许触发器函数修改该行。
  - 不希望产生上述两种行为的行级 BEFORE 触发器，需返回传入的同一行（INSERT 和 UPDATE 触发器的 NEW 行，DELETE 触发器的 OLD 行）。
  - INSTEAD OF 触发器：
  - 返回 NULL，表示未修改视图底层基表的数据。
  - 返回传入的视图行（INSERT 和 UPDATE 操作的 NEW 行，DELETE 操作的 OLD 行），非空返回值表示触发器在视图中执行了必要的数据修改，会使受命令影响的行数计数增加。对于 INSERT 和 UPDATE 操作，触发器可在返回 NEW 行前对其进行修改，以改变 INSERT RETURNING 或 UPDATE RETURNING 返回的数据。
  - AFTER 触发器：返回值会被忽略，可返回 NULL。

## 示例

```
--创建源表及触发表
openGauss=# CREATE TABLE test_trigger_src_tbl(id1 INT, id2 INT, id3 INT);
openGauss=# CREATE TABLE test_trigger_des_tbl(id1 INT, id2 INT, id3 INT);

--创建触发器函数
openGauss=# CREATE OR REPLACE FUNCTION tri_insert_func() RETURNS TRIGGER AS
           $$
           DECLARE
           BEGIN
                   INSERT INTO test_trigger_des_tbl VALUES(NEW.id1, NEW.id2, NEW.id3);
                   RETURN NEW;
           END
           $$ LANGUAGE PLPGSQL;

openGauss=# CREATE OR REPLACE FUNCTION tri_update_func() RETURNS TRIGGER AS
           $$
           DECLARE
           BEGIN
                   UPDATE test_trigger_des_tbl SET id3 = NEW.id3 WHERE id1=OLD.id1;
                   RETURN OLD;
           END
           $$ LANGUAGE PLPGSQL;

openGauss=# CREATE OR REPLACE FUNCTION TRI_DELETE_FUNC() RETURNS TRIGGER AS
           $$
           DECLARE
           BEGIN
                   DELETE FROM test_trigger_des_tbl WHERE id1=OLD.id1;
                   RETURN OLD;
           END
           $$ LANGUAGE PLPGSQL;

--创建INSERT触发器
openGauss=# CREATE TRIGGER insert_trigger
           BEFORE INSERT ON test_trigger_src_tbl
           FOR EACH ROW
           EXECUTE PROCEDURE tri_insert_func();

--创建UPDATE触发器
openGauss=# CREATE TRIGGER update_trigger
           AFTER UPDATE ON test_trigger_src_tbl
           FOR EACH ROW
           EXECUTE PROCEDURE tri_update_func();

--创建DELETE触发器
openGauss=# CREATE TRIGGER delete_trigger
           BEFORE DELETE ON test_trigger_src_tbl
           FOR EACH ROW
           EXECUTE PROCEDURE tri_delete_func();

--执行INSERT触发事件并检查触发结果
openGauss=# INSERT INTO test_trigger_src_tbl VALUES(100,200,300);
openGauss=# SELECT * FROM test_trigger_src_tbl;
openGauss=# SELECT * FROM test_trigger_des_tbl;  //查看触发操作是否生效。

--执行UPDATE触发事件并检查触发结果
openGauss=# UPDATE test_trigger_src_tbl SET id3=400 WHERE id1=100;
openGauss=# SELECT * FROM test_trigger_src_tbl;
openGauss=# SELECT * FROM test_trigger_des_tbl;  //查看触发操作是否生效

--执行DELETE触发事件并检查触发结果
openGauss=# DELETE FROM test_trigger_src_tbl WHERE id1=100;
openGauss=# SELECT * FROM test_trigger_src_tbl;
openGauss=# SELECT * FROM test_trigger_des_tbl;  //查看触发操作是否生效

--修改触发器
openGauss=# ALTER TRIGGER delete_trigger ON test_trigger_src_tbl RENAME TO delete_trigger_renamed;

--修改触发器owner为jack（需保证jack为数据库中已创建的用户）。
openGauss=# ALTER TRIGGER delete_trigger ON test_trigger_src_tbl OWNER TO jack;

--ALTER TRIGGER 方式禁用insert_trigger触发器
openGauss=# ALTER TRIGGER insert_trigger DISABLE;

--ALTER TRIGGER 方式启用insert_trigger触发器
openGauss=# ALTER TRIGGER insert_trigger ENABLE;

--禁用insert_trigger触发器
openGauss=# ALTER TABLE test_trigger_src_tbl DISABLE TRIGGER insert_trigger;

--禁用当前表上所有触发器
openGauss=# ALTER TABLE test_trigger_src_tbl DISABLE TRIGGER ALL;

--删除触发器
openGauss=# DROP TRIGGER insert_trigger ON test_trigger_src_tbl;
openGauss=# DROP TRIGGER update_trigger ON test_trigger_src_tbl;
openGauss=# DROP TRIGGER delete_trigger_renamed ON test_trigger_src_tbl;
--创建mysql兼容数据库
openGauss=# create database db_mysql dbcompatibility 'B';
--创建触发器定义用户
openGauss=# create user test_user password '******';
--创建原表及触发表
db_mysql=# create table test_mysql_trigger_src_tbl (id INT);
db_mysql=# create table test_mysql_trigger_des_tbl (id INT);
db_mysql=# create table animals (id INT, name CHAR(30));
db_mysql=# create table food (id INT, foodtype VARCHAR(32), remark VARCHAR(32), time_flag TIMESTAMP);
--创建MySQL兼容definer语法触发器
db_mysql=# create definer=test_user trigger trigger1
     after insert on test_mysql_trigger_src_tbl
     for each row
     begin
         insert into test_mysql_trigger_des_tbl values(1);
     end;
     /
--创建MySQL兼容trigger_order语法触发器
db_mysql=# create trigger animal_trigger1
      after insert on animals
     for each row
     begin
         insert into food(id, foodtype, remark, time_flag) values (1,'ice cream', 'sdsdsdsd', now());
     end;
     /
--创建MySQL兼容FOLLOWS触发器
db_mysql=# create trigger animal_trigger2
     after insert on animals
     for each row
     follows animal_trigger1
     begin
         insert into food(id, foodtype, remark, time_flag) values (2,'chocolate', 'sdsdsdsd', now());
     end;
     /
db_mysql=# create trigger animal_trigger3
          after insert on animals
          for each row
          follows animal_trigger1
          begin
              insert into food(id, foodtype, remark, time_flag) values (3,'cake', 'sdsdsdsd', now());
          end;
          /
db_mysql=# create trigger animal_trigger4
          after insert on animals
          for each row
          follows animal_trigger1
          begin
              insert into food(id, foodtype, remark, time_flag) values (4,'sausage', 'sdsdsdsd', now());
          end;
          /
--执行insert触发事件并检查触发结果
db_mysql=# insert into animals (id, name) values(1,'lion');
db_mysql=# select * from animals;
db_mysql=# select id, foodtype, remark from food;
--创建MySQL兼容PROCEDES触发器
db_mysql=# create trigger animal_trigger5
          after insert on animals
          for each row
          precedes animal_trigger3
          begin
              insert into food(id, foodtype, remark, time_flag) values (5,'milk', 'sdsds', now());
          end;
          /
db_mysql=# create trigger animal_trigger6
          after insert on animals
          for each row
          precedes animal_trigger2
          begin
              insert into food(id, foodtype, remark, time_flag) values (6,'strawberry', 'sdsds', now());
          end;
          /
--执行insert触发事件并检查触发结果
db_mysql=# insert into animals (id, name) values(2, 'dog');
db_mysql=# select * from animals;
db_mysql=# select id, foodtype, remark from food;
--创建MySQL兼容if not exists语法触发器
db_mysql=# create trigger if not exists animal_trigger1
          after insert on animals
          for each row
          begin
              insert into food(id, foodtype, remark, time_flag) values (1,'ice cream', 'sdsdsdsd', now());
          end;
          /
--mysql兼容删除触发器语法
db_mysql=# drop trigger animal_trigger1;
db_mysql=# drop trigger if exists animal_trigger1;
--在指定模式下创建、重命名、删除触发器语法，触发器的模式需要与表模式相同
create schema testscm;
create table food (id int, foodtype varchar(32), remark varchar(32), time_flag timestamp);
create table testscm.animals_scm (id int, name char(30));
-- 在指定模式下创建触发器
create trigger testscm.animals_trigger
after insert on testscm.animals_scm
for each row
begin
    insert into food(id, foodtype, remark, time_flag) values (1,'bamboo', 'healthy', now());
end;
/
create trigger if not exists testscm.animals_trigger
after insert on testscm.animals_scm
for each row
begin
    insert into food(id, foodtype, remark, time_flag) values (1,'bamboo', 'healthy', now());
end;
/
-- 重命名指定模式下的触发器
-- 由于重命名触发器不支持修改触发器所属模式，因此新触发器名不支持携带模式名
alter trigger testscm.animals_trigger on testscm.animals_scm rename to animals_trigger_new;
-- 删除指定模式下的触发器
drop trigger testscm.animals_trigger_new;
drop trigger if exists testscm.animals_trigger_new;
-- 当删除触发器不指定所在表时，若存在多个同名触发器，不支持通过指定触发器的模式名来确定所在表以及触发器，如下示例：
testdb_m=# create schema testscm;
CREATE SCHEMA
testdb_m=# create table food (id int, foodtype varchar(32), remark varchar(32), time_flag timestamp);
CREATE TABLE
testdb_m=# create table animals (id int, name char(30));
CREATE TABLE
testdb_m=# create table testscm.animals_scm (id int, name char(30));
CREATE TABLE
testdb_m=# create or replace function food_function() returns trigger as
testdb_m-# $$
testdb_m$# declare
testdb_m$# begin
testdb_m$#     insert into food(id, foodtype, remark, time_flag) values (1,'bamboo', 'healthy', now());
testdb_m$# return new;
testdb_m$# end
testdb_m$# $$ language plpgsql;
CREATE FUNCTION
testdb_m=# create trigger animals_trigger before insert on animals for each row execute procedure food_function();
CREATE TRIGGER
testdb_m=# create trigger testscm.animals_trigger before insert on testscm.animals_scm for each row execute procedure food_function();
CREATE TRIGGER
testdb_m=# drop TRIGGER testscm.animals_trigger;
ERROR:  trigger named "animals_trigger" has more than one trigger, please use drop trigger on syntax
```

## 相关链接

[ALTER TRIGGER](alter_trigger.md)，[DROP TRIGGER](drop_trigger.md)，[ALTER TABLE](alter_table.md)
