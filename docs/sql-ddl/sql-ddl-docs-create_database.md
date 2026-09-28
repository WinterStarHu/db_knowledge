# CREATE DATABASE

## 功能描述

创建一个新的数据库。缺省情况下新数据库将通过复制标准系统数据库template0来创建，且仅支持使用template0来创建。

## 注意事项

- 只有拥有CREATEDB权限的用户才可以创建新数据库，系统管理员默认拥有此权限。
- 不能在事务块中执行创建数据库语句。
- 在创建数据库过程中，出现类似“Permission denied”的错误提示，可能是由于文件系统上数据目录的权限不足。出现类似“No space left on device”的错误提示，可能是由于磁盘满引起的。

## 语法格式

```
CREATE DATABASE [IF NOT EXISTS] database_name
    [ [ WITH ] { [ OWNER [=] user_name ] |
               [ TEMPLATE [=] template ] |
               [ ENCODING [=] encoding ] |
               [ LC_COLLATE [=] lc_collate ] |
               [ LC_CTYPE [=] lc_ctype ] |
               [ DBCOMPATIBILITY [=] compatibilty_type ] |
               [ TABLESPACE [=] tablespace_name ] |
               [ CONNECTION LIMIT [=] connlimit ]}[...] ];
```

## 参数说明

- **database\_name**

数据库名称。

取值范围：字符串，要符合标识符的命名规范。

- **OWNER \[ = \] user\_name**

数据库所有者。缺省时，新数据库的所有者是当前用户。

取值范围：已存在的用户名。

- **TEMPLATE \[ = \] template**

模板名。即从哪个模板创建新数据库。openGauss采用从模板数据库复制的方式来创建新的数据库。初始时，openGauss包含两个模板数据库template0、template1，以及一个默认的用户数据库postgres。

取值范围：仅template0。

- **ENCODING \[ = \] encoding**

指定数据库使用的字符编码，可以是字符串（如'SQL\_ASCII'）、整数编号。

不指定时，默认使用模版数据库的编码。模板数据库template0和template1的编码默认与操作系统环境相关。template1不允许修改字符编码，因此若要变更编码，请使用template0创建数据库。

常用取值：GBK、UTF8、Latin1、GB10830等，具体支持的字符集如下：

**表 1**  openGauss字符集

是否服务器端？
ICU?
字节/字符 BIG5 Big Five 繁体中文 1-2 WIN950，Windows950 EUC_CN 扩展UNIX编码-中国 简体中文 1-3 EUC_JP 扩展UNIX编码-日本 1-3 EUC_JIS_2004 扩展UNIX编码-日本, JIS X 0213 1-3 EUC_KR 扩展UNIX编码-韩国 1-3 EUC_TW 扩展UNIX编码-中国台湾 繁体中文 1-3 GB18030 国家标准 1-4

GB18030_2022 国家标准 1-4

GBK 扩展国家标准 简体中文 1-2 WIN936，Windows936 ISO_8859_5 ISO 8859-5, ECMA 113 拉丁语/西里尔语 ISO_8859_6 ISO 8859-6, ECMA 114 拉丁语/阿拉伯语 ISO_8859_7 ISO 8859-7, ECMA 118 拉丁语/希腊语 ISO_8859_8 ISO 8859-8, ECMA 121 拉丁语/希伯来语 JOHAB JOHAB 1-3 KOI8R KOI8-R 西里尔语（俄语） KOI8 KOI8U KOI8-U 西里尔语（乌克兰语） LATIN1 ISO 8859-1, ECMA 94 ISO88591 LATIN2 ISO 8859-2, ECMA 94 ISO88592 LATIN3 ISO 8859-3, ECMA 94 ISO88593 LATIN4 ISO 8859-4, ECMA 94 ISO88594 LATIN5 ISO 8859-9, ECMA 128 土耳其语 ISO88599 LATIN6 ISO 8859-10, ECMA 144 日耳曼语 ISO885910 LATIN7 ISO 8859-13 波罗的海 ISO885913 LATIN8 ISO 8859-14 凯尔特语 ISO885914 LATIN9 ISO 8859-15 带欧罗巴和口音的LATIN1 ISO885915 LATIN10 ISO 8859-16, ASRO SR 14111 罗马尼亚语 ISO885916 MULE_INTERNAL Mule内部编码 多语种编辑器 1-4 SJIS Shift JIS 1-2 Mskanji，ShiftJIS，WIN932，Windows932 SHIFT_JIS_2004 Shift JIS, JIS X 0213 1-2 SQL_ASCII 未指定（见文本） UHC 统一韩语编码 1-2 WIN949，Windows949 UTF8 Unicode, 8-bit 1-4 Unicode WIN866 Windows CP866 西里尔语 ALT WIN874 Windows CP874 WIN1250 Windows CP1250 WIN1251 Windows CP1251 西里尔语 WIN WIN1252 Windows CP1252 WIN1253 Windows CP1253 希腊语 WIN1254 Windows CP1254 土耳其语 WIN1255 Windows CP1255 希伯来语 WIN1256 Windows CP1256 阿拉伯语 WIN1257 Windows CP1257 波罗的海 WIN1258 Windows CP1258 越南语 ABC, TCVN，TCVN5712，VSCII

  >[!WARNING]注意
  >
  >需要注意并非所有的客户端API都支持上面列出的字符集。
  >SQL\_ASCII设置与其他设置表现得相当不同。如果服务器字符集是SQL\_ASCII，服务器把字节值0-127根据 ASCII标准解释，而字节值128-255则当作无法解析的字符。如果设置为SQL\_ASCII，就不会有编码转换。因此，这个设置基本不是用来声明所使用的指定编码， 因为这个声明会忽略编码。在大多数情况下，如果你使用了任何非ASCII数据，那么使用 SQL\_ASCII设置都是不明智的，因为openGauss将无法帮助你转换或者校验非ASCII字符。

  >[!TIP]须知
  >
  >- 指定新的数据库字符集编码必须与所选择的本地环境中（LC\_COLLATE和LC\_CTYPE）的设置兼容。
  >- 当指定的字符编码集为GBK时，部分中文生僻字无法直接作为对象名。这是因为GBK第二个字节的编码范围在0x40-0x7E之间时，字节编码与ASCII字符@A-Z\[\\\]^\_\`a-z\{|\}重叠。其中@\[\\\]^\_'\{|\}是数据库中的操作符，直接作为对象名时，会语法报错。例如“侤”字，GBK16进制编码为0x8240，第二个字节为0x40，与ASCII“@”符号编码相同，因此无法直接作为对象名使用。如果确实要使用，可以在创建和访问对象时，通过增加双引号来规避这个问题。
  >- 若客户端编码为A，服务器端编码为B，则需要满足数据库中存在编码格式A与B的转换。数据库能够支持的所有的编码格式转换详见系统表[PG_CONVERSION](../database_reference/pg_conversion.md)（若无法转换，则建议客户端编码与服务器端编码保持一致，客户端编码可通过GUC参数client_encoding修改）。
  >- 若要指定数据库字符集编码为GB18030_2022，且客户端编码也要设置为GB18030时，必须确保客户端操作系统支持的GB18030字符集为2022版本，否则由于GB18030字符集自身的各版本间存在不完全兼容，可能导致数据的不一致性。同时，涉及到历史数据切换为GB18030_2022数据库时应当遵循切库流程，进行数据迁移操作。

- **LC\_COLLATE \[ = \] lc\_collate**

指定新数据库使用的字符集。例如，通过lc\_collate = 'zh\_CN.gbk'设定该参数。

该参数的使用会影响到对字符串的排序顺序（如使用ORDER BY执行，以及在文本列上使用索引的顺序）。默认是使用模板数据库的排序顺序。

取值范围：操作系统支持的字符集。

- **LC\_CTYPE \[ = \] lc\_ctype**

指定新数据库使用的字符分类。例如，通过lc\_ctype = 'zh\_CN.gbk'设定该参数。该参数的使用会影响到字符的分类，如大写、小写和数字。默认是使用模板数据库的字符分类。

取值范围：操作系统支持的字符分类。
>[!NOTE]说明
>
>- 对于lc_collate和lc_ctype参数的取值范围，取决于本地环境支持的字符集。
>- 当指定的字符编码集为GB18030_2022时，其LC_COLLATE和LC_CTYPE的取值范围与GB18030保持一致。
> 例如：在Linux操作系统上，可通过locale -a命令获取操作系统支持的字符集列表，在应用lc_collate和lc_ctype参数时可从中选择用户需要的字符集和字符分类。

- **DBCOMPATIBILITY \[ = \] compatibility\_type**

指定兼容的数据库的类型，默认兼容O。

取值范围：A、B、C、PG、D。分别表示兼容O、MY、TD、POSTGRES和S数据库。在B兼容性场景下，必须加载dolphin插件才允许被连接。详见[dolphin限制](https://docs.opengauss.org/zh/docs/latest/extension_reference/dolphin.html)。

  >[!NOTE]说明
  >
  >- A兼容性下，数据库将空字符串作为NULL处理，数据类型DATE会被替换为TIMESTAMP\(0\) WITHOUT TIME ZONE。
  >- 将字符串转换成整数类型时，如果输入不合法，B兼容性会将输入转换为0，而其它兼容性则会报错。
  >- B和PG兼容性下，CHAR和VARCHAR以字符为计数单位，其它兼容性以字节为计数单位。例如，对于UTF-8字符集，CHAR\(3\)在B和PG兼容性下能存放3个中文字符，而在其它兼容性下只能存放1个中文字符。

- **TABLESPACE \[ = \] tablespace\_name**

指定数据库对应的表空间。

取值范围：已存在表空间名。

- **CONNECTION LIMIT \[ = \] connlimit**

数据库可以接受的并发连接数。

>[!TIP]须知
>
>- 系统管理员不受此参数的限制。
>- connlimit数据库主节点单独统计，openGauss整体的连接数 = connlimit \* 当前正常数据库主节点个数。

取值范围：\>=-1的整数。默认值为-1，表示没有限制。

有关字符编码的一些限制：

- 若区域设置为C（或POSIX），则允许所有的编码类型，但是对于其他的区域设置，字符编码必须和区域设置相同。
- 若字符编码方式是SQL\_ASCII，并且修改者为管理员用户时，则字符编码可以和区域设置不相同。
- 编码和区域设置必须匹配模板数据库，除了将template0当作模板。 因为其他数据库可能会包含不匹配指定编码的数据，或者可能包含排序顺序受LC\_COLLATE和LC\_CTYPE影响的索引。复制这些数据会导致在新数据库中的索引失效。template0是不包含任何会受到影响的数据或者索引。

## 示例

```
--创建jim和tom用户。
openGauss=# CREATE USER jim PASSWORD 'xxxxxxxxx';
openGauss=# CREATE USER tom PASSWORD 'xxxxxxxxx';

--创建一个GBK编码的数据库music（本地环境的编码格式必须也为GBK）。
openGauss=# CREATE DATABASE music ENCODING 'GBK' template = template0;

--创建数据库music2，并指定所有者为jim。
openGauss=# CREATE DATABASE music2 OWNER jim;

--用模板template0创建数据库music3，并指定所有者为jim。
openGauss=# CREATE DATABASE music3 OWNER jim TEMPLATE template0;

--设置music数据库的连接数为10。
openGauss=# ALTER DATABASE music CONNECTION LIMIT= 10;

--将music名称改为music4。
openGauss=# ALTER DATABASE music RENAME TO music4;

--将数据库music2的所属者改为tom。
openGauss=# ALTER DATABASE music2 OWNER TO tom;

--设置music3的表空间为PG_DEFAULT。
openGauss=# ALTER DATABASE music3 SET TABLESPACE PG_DEFAULT;

--关闭在数据库music3上缺省的索引扫描。
openGauss=# ALTER DATABASE music3 SET enable_indexscan TO off;

--重置enable_indexscan参数。
openGauss=# ALTER DATABASE music3 RESET enable_indexscan;

--删除数据库。
openGauss=# DROP DATABASE music2;
openGauss=# DROP DATABASE music3;
openGauss=# DROP DATABASE music4;

--删除jim和tom用户。
openGauss=# DROP USER jim;
openGauss=# DROP USER tom;

--创建兼容TD格式的数据库。
openGauss=# CREATE DATABASE td_compatible_db DBCOMPATIBILITY 'C';

--创建兼容A格式的数据库。
openGauss=# CREATE DATABASE ora_compatible_db DBCOMPATIBILITY 'A';

--删除兼容TD、A格式的数据库。
openGauss=# DROP DATABASE td_compatible_db;
openGauss=# DROP DATABASE ora_compatible_db;
```

## 相关链接

[ALTER DATABASE](alter_database.md)，[DROP DATABASE](drop_database.md)
