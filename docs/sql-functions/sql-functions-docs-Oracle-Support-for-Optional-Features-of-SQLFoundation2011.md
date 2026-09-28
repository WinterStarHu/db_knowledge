# Oracle Support for Optional Features of SQL/Foundation

Oracle’s support for optional features of SQL/Foundation is listed in Table C-2:
Table 2 Oracle Support for Optional Features of SQL/Foundation

| T326, Table functions | Oracle provides equivalents for the following elements of this feature: is supported using CAST (MULTISET () AS ) is supported using the TABLE operator in the FROM clause with a varray or nested table as the argument is equivalent to an Oracle expression resulting in a varray or nested table is equivalent to a PL/SQL function that returns a nested table |
|---|---|
| T331, Basic roles | Oracle supports this feature, except for REVOKE ADMIN OPTION FOR . |
| T341, Overloading of SQL-invoked functions and procedures | Oracle supports overloading of functions and procedures. However, the rules for handling certain data type combinations are not the same as the standard. For example, the standard permits the coexistence of two functions of the same name differing only in the numeric types of the arguments, whereas Oracle does not permit this. |
| T351, Bracketed comments | Oracle fully supports this feature. |
| T431, Extended grouping capabilities | Oracle fully supports this feature. |
| T432, Nested and concatenated GROUPING SETS | Oracle supports concatenated GROUPING SETS, but not nested GROUPING SETS. |
| T433, Multiargument function GROUPING | The Oracle GROUP_ID function can be used to conveniently distinguish groups in a grouped query, serving the same purpose as the standard multiargument GROUPING function. |
| T441, ABS and MOD functions | Oracle supports the ABS function. Oracle’s MOD function is similar to the standard, though the behavior is different if the two arguments are of opposite sign. |
| T471, Result sets return value | PL/SQL ref cursors provide all the functionality of the standard’s result set cursors. |
| T491, LATERAL derived tables | Oracle fully supports this feature. |
| T501, Enhanced EXISTS predicate | Oracle fully supports this feature. |
| T511, Transaction counts | Oracle supports the count of transactions committed and rolled back via the system views V$STATNAME and V$SESSTAT. |
| T521, Named arguments in CALL statement | Oracle fully supports this feature. |
| T522, Default values for IN parameters of SQL-invoked procedures | Oracle fully supports this feature. |
| T524, Named arguments in routine invocations other than a CALL statement | Oracle fully supports this feature. |
| T525, Default values for parameters of SQL-invoked functions | Oracle fully supports this feature. |
| T571, Array-returning external SQL-invoked function | Oracle table functions returning a varray can be defined in external programming languages. When declaring such functions in SQL, use the CREATE FUNCTION command with the PIPELINED USING clause. |
| T572, Multiset-returning external SQL-invoked function | Oracle table functions returning a nested table can be defined in external programming languages. When declaring such functions in SQL, use the CREATE FUNCTION command with the PIPELINED USING clause. In the body of the function, use the OCITable interface. The function must be invoked within the TABLE operator in the FROM clause. |
| T581, Regular expressions substring functions | Oracle provides the REGEXP_SUBSTR function to perform substring operations using regular expression matching. |
| T591, UNIQUE constraints of possibly null columns | Oracle permits a UNIQUE constraint on one or more nullable columns. If the UNIQUE constraint is on a single column, then the semantics are the same as the standard (the constraint permits any number of rows that are null in the designated column). If the UNIQUE constraint is on two or more columns, then the semantics are nonstandard. Oracle permits any number of rows that are null in all the designated columns. Unlike the standard, if a row is non-null in at least one of the designated columns, then another row having the same values in the non-null columns of the constraint is a constraint violation and not permitted. |
| T611, Elementary OLAP operations | Oracle fully supports this feature, except that DISTINCT is only supported in conjunction with window partitioning but not with window framing. |
| T612, Advanced OLAP operations | Oracle supports the following elements of this feature: PERCENT_RANK, CUME_DIST, WIDTH_BUCKET, hypothetical set functions, PERCENTILE_CONT, PERCENTILE_DISC, and ROW_NUMBER.Oracle does not support the following element of this feature: ROW_NUMBER without ORDER BY |
| T613, Sampling | Oracle uses the keyword SAMPLE instead of the standard’s keyword, TABLESAMPLE. Oracle uses the keyword BLOCK instead of the standard’s keyword, SYSTEM. Oracle uses the absence of the keyword BLOCK to indicate a Bernoulli sampling of rows, indicated in the standard by the keyword BERNOULLI. Oracle does not support sampling of derived tables or views that are not key-preserving. Oracle does not permit sampling in a subquery of a DELETE, UPDATE or MERGE statement. |
| T614, NTILE function | Oracle fully supports this feature. |
| T615, LEAD and LAG functions | Oracle fully supports this feature. |
| T616, Null treatment option for LEAD and LAG functions | Oracle fully supports this feature. |
| T617, FIRST_VALUE and LAST_VALUE functions | Oracle fully supports this feature. |
| T618, NTH_VALUE function | Oracle fully supports this feature. |
| T621, Enhanced numeric functions | Oracle fully supports this feature, except for the alternate spelling CEILING of the CEIL function. |
| T622, Trigonometric functions | Oracle fully supports this feature. |
| T623, General logarithm function | Oracle fully supports this feature. |
| T625, LISTAGG | Oracle fully supports this feature. |
| T641, Multiple column assignment | The standard syntax to assign to multiple columns is supported if the assignment source is a subquery. |
| T652, SQL-dynamic statements in SQL routines. | PL/SQL supports dynamic SQL. |
| T654, SQL-dynamic statements in external routines | Oracle supports dynamic SQL in embedded C, which may be used to create an external routine. |
| T655, Cyclically dependent routines | PL/SQL supports recursion. |
| T811, Basic SQL/JSON constructor functions | Oracle fully supports this feature, except for the JSON_ARRAY constructor by query. |
| T812, SQL/JSON: JSON_OBJECTAGG | Oracle fully supports this feature. |
| T813, SQL/JSON: JSON_ARRAYAGG with ORDER BY | Oracle fully supports this feature. |
| T821, Basic SQL/JSON query operators | Oracle fully supports this feature. |
| T822, SQL/JSON: IS JSON WITH UNIQUE KEYS predicate | Oracle fully supports this feature. |
| T823, SQL/JSON: PASSING clause | Oracle supports the PASSING clause in JSON_EXISTS. |
| T825, SQL/JSON: ON EMPTY and ON ERROR clauses | Oracle fully supports this feature, except that: The ON ERROR clause for JSON_EXISTS does not support UNKNOWN. JSON_TABLE does not support a column-level ON EMPTY clause. |
| T828, JSON_QUERY | Oracle fully supports this feature. |
| T829, JSON_QUERY: array wrapper options | Oracle fully supports this feature. |
| T832, SQL/JSON path language: item method | Oracle fully supports the following item methods: absceilingdoublefloorOracle provides the following comparable support: date and timestamp are comparable to the standard's datetimeOracle extends this feature by supporting the following item methods: lengthlowernumberstringupper |
| T833, SQL/JSON path language: multiple subscripts | Oracle fully supports this feature, except that subscripts have to be specified in strictly monotonically increasing order. |
| T834, SQL/JSON path language: wildcard member accessor | Oracle fully supports this feature. |
| T835, SQL/JSON path language: filter expression | Oracle supports the filter expression as the last step of the SQL/JSON path expression in JSON_EXISTS. |
| T839, Formatted cast of datetimes to/from character strings | Oracle supports this feature with a minor syntactic difference: Oracle uses a comma instead of the keyword FORMAT. |
