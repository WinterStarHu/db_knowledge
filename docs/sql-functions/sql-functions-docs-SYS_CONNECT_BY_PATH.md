# SYS_CONNECT_BY_PATH

## Syntax
Description of the illustration sys_connect_by_path.gif Description of the illustration sys_connect_by_path.eps
## Purpose
`SYS_CONNECT_BY_PATH` is valid only in hierarchical queries. It returns the path of a column value from root to node, with column values separated by *char* for each row returned by `CONNECT` `BY` condition.
Both *column* and *char* can be any of the data types `CHAR`, `VARCHAR2`, `NCHAR`, or `NVARCHAR2`. The string returned is of `VARCHAR2` data type and is in the same character set as *column*.
**See Also:**
````
- “Hierarchical Queries” for more information about hierarchical queries and CONNECT BY conditions
**
- in Oracle Database Globalization Support Guide for the collation derivation rules, which define the collation assigned to the character return value of SYS_CONNECT_BY_PATH
## Examples
The following example returns the path of employee names from employee `Kochhar` to all employees of `Kochhar` (and their employees):
```
SELECT LPAD(' ', 2*level-1)||SYS_CONNECT_BY_PATH(last_name, '/') "Path" FROM employees START WITH last_name = 'Kochhar' CONNECT BY PRIOR employee_id = manager_id;
Path
------------------------------
/Kochhar/Greenberg/Chen /Kochhar/Greenberg/Faviet /Kochhar/Greenberg/Popp /Kochhar/Greenberg/Sciarra /Kochhar/Greenberg/Urman /Kochhar/Higgins/Gietz /Kochhar/Baer /Kochhar/Greenberg /Kochhar/Higgins /Kochhar/Mavris /Kochhar/Whalen /Kochhar
```
