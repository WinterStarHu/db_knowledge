# 处理结果集

## 设置结果集类型

不同类型的结果集有各自的应用场景，应用程序需要根据实际情况选择相应的结果集类型。在执行SQL语句过程中，都需要先创建相应的语句对象，而部分创建语句对象的方法提供了设置结果集类型的功能。具体的参数设置如[表1](#zh-cn_topic_0237120384_zh-cn_topic_0213179150_zh-cn_topic_0189250321_zh-cn_topic_0059778370_t600ecae93052471d819154e0f14d8fc3)所示。涉及的Connection的方法如下：

```
//创建一个Statement对象，该对象将生成具有给定类型和并发性的ResultSet对象。
createStatement(int resultSetType, int resultSetConcurrency);

//创建一个PreparedStatement对象，该对象将生成具有给定类型和并发性的ResultSet对象。
prepareStatement(String sql, int resultSetType, int resultSetConcurrency);

//创建一个CallableStatement对象，该对象将生成具有给定类型和并发性的ResultSet对象。
prepareCall(String sql, int resultSetType, int resultSetConcurrency);
```

**表 1**  结果集类型

resultSetType 表示结果集的类型，具体有三种类型： ResultSet.TYPE_FORWARD_ONLY：ResultSet只能向前移动。是缺省值。ResultSet.TYPE_SCROLL_SENSITIVE：在修改后重新滚动到修改所在行，可以看到修改后的结果。ResultSet.TYPE_SCROLL_INSENSITIVE：对可修改例程所做的编辑不进行显示。
resultSetConcurrency 表示结果集的并发，具体有两种类型： ResultSet.CONCUR_READ_ONLY：如果不从结果集中的数据建立一个新的更新语句，不能对结果集中的数据进行更新。ResultSet.CONCUR_UPDATEABLE：可改变的结果集。对于可滚动的结果集，可对结果集进行适当的改变。

## 在结果集中定位

ResultSet对象具有指向其当前数据行的光标。最初，光标被置于第一行之前。next方法将光标移动到下一行；因为该方法在ResultSet对象没有下一行时返回false，所以可以在while循环中使用它来迭代结果集。但对于可滚动的结果集，JDBC驱动程序提供更多的定位方法，使ResultSet指向特定的行。定位方法如[表2](#zh-cn_topic_0237120384_zh-cn_topic_0213179150_zh-cn_topic_0189250321_zh-cn_topic_0059778370_t0e427b4d1b1f4d67899fac4ad3df1049)所示。

**表 2**  在结果集中定位的方法

next() 把ResultSet向下移动一行。
previous() 把ResultSet向上移动一行。
beforeFirst() 把ResultSet定位到第一行之前。
afterLast() 把ResultSet定位到最后一行之后。
first() 把ResultSet定位到第一行。
last() 把ResultSet定位到最后一行。
absolute(int) 把ResultSet移动到参数指定的行数。
relative(int) 通过设置为1向前（设置为1，相当于next()）或者向后（设置为-1，相当于previous()）移动参数指定的行。

## 获取结果集中光标的位置

对于可滚动的结果集，可能会调用定位方法来改变光标的位置。JDBC驱动程序提供了获取结果集中光标所处位置的方法。获取光标位置的方法如[表3](#zh-cn_topic_0237120384_zh-cn_topic_0213179150_zh-cn_topic_0189250321_zh-cn_topic_0059778370_tfc10dffc5995480281e8065b4b03d370)所示。

**表 3**  获取结果集光标的位置

isFirst() 是否在一行。
isLast() 是否在最后一行。
isBeforeFirst() 是否在第一行之前。
isAfterLast() 是否在最后一行之后。
getRow() 获取当前在第几行。

## 获取结果集中的数据

ResultSet对象提供了丰富的方法，以获取结果集中的数据。获取数据常用的方法如[表4](#zh-cn_topic_0237120384_zh-cn_topic_0213179150_zh-cn_topic_0189250321_zh-cn_topic_0059778370_t92d6c213fa8b403796ae7da7e7cd6c46)所示，其他方法请参考JDK官方文档。

**表 4**  ResultSet对象的常用方法

int getInt(int columnIndex) 按列标获取int型数据。
int getInt(String columnLabel) 按列名获取int型数据。
String getString(int columnIndex) 按列标获取String型数据。
String getString(String columnLabel) 按列名获取String型数据。
Date getDate(int columnIndex) 按列标获取Date型数据。
Date getDate(String columnLabel) 按列名获取Date型数据。
