# java.sql.ResultSetMetaData

java.sql.ResultSetMetaData是对ResultSet对象相关信息的具体描述。

**表 1**  对java.sql.ResultSetMetaData的支持情况

方法名 返回值类型 支持JDBC 4 getCatalogName​(int column) String Yes getColumnClassName​(int column) String Yes getColumnCount() int Yes getColumnDisplaySize​(int column) int Yes getColumnLabel​(int column) String Yes getColumnName(int column) String Yes getColumnType(int column) int Yes getColumnTypeName(int column) String Yes getPrecision​(int column) int Yes getScale​(int column) int Yes getSchemaName​(int column) String Yes getTableName​(int column) String Yes isAutoIncrement​(int column) boolean Yes isCaseSensitive​(int column) boolean Yes isCurrency​(int column) boolean Yes isDefinitelyWritable​(int column) boolean Yes isNullable​(int column) int Yes isReadOnly​(int column) boolean Yes isSearchable​(int column) boolean Yes isSigned​(int column) boolean Yes isWritable​(int column) boolean Yes
