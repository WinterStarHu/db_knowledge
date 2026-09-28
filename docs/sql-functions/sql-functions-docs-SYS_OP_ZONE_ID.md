# SYS_OP_ZONE_ID

## Syntax
Description of the illustration sys_op_zone_id.gif Description of the illustration sys_op_zone_id.eps
## Purpose
`SYS_OP_ZONE_ID` takes as its argument a rowid and returns a zone ID. The rowid identifies a row in a table. The zone ID identifies the set of contiguous disk blocks, called the zone, that contains the row. The function returns a `NUMBER` value.
The `SYS_OP_ZONE_ID` function is used when creating a zone map with the `CREATE` `MATERIALIZED` `ZONEMAP` statement. You must specify `SYS_OP_ZONE_ID` in the `SELECT` and `GROUP` `BY` clauses of the defining subquery of the zone map.
For *rowid*, specify the `ROWID` pseudocolumn of the fact table of the zone map.
Use *schema* and *table* to specify the schema and name of the fact table, or *t_alias* to specify the table alias for the fact table. The specification of these parameters depends on the `FROM` clause in the defining subquery of the zone map:
**
- If the FROM clause specifies a table alias for the fact table, then you must also specify the table alias (t_alias) in SYS_OP_ZONE_ID.
**********
- If the FROM clause does not specify a table alias for the fact table, then use table to specify the name of the fact table. You can use the schema qualifier if the fact table is in a schema other than your own. If you omit schema, then the database assumes the fact table is in your own schema. If the FROM clause specifies only one table (the fact table) then you need not specify schema or table.
The optional *scale* parameter represents the scale of the zone map. It is not necessary to specify this parameter because, by default, `SYS_OP_ZONE_ID` uses the scale of the zone map being created. If you do specify *scale*, then it must match the scale of the zone map being created. Refer to the SCALE clause of `CREATE` `MATERIALIZED` `ZONEMAP` for information on specifying the scale of a zone map.
**See Also:**   CREATE MATERIALIZED ZONEMAP for more information on creating zone maps
## Examples
The following example uses the `SYS_OP_ZONE_ID` function when creating a basic zone map that tracks the column `time_id` of the fact table `sales`. The scale of the zone map is the default value of 10. Therefore, the `SYS_OP_ZONE_ID` function will default to a scale value of 10.
```
CREATE MATERIALIZED ZONEMAP sales_zmap
AS
  SELECT SYS_OP_ZONE_ID(rowid), MIN(time_id), MAX(time_id)
  FROM sales
  GROUP BY SYS_OP_ZONE_ID(rowid);
```
The following example is similar to the previous example, except that the scale of the zone map being created is specified as 8. Therefore, the `SYS_OP_ZONE_ID` function will default to a scale value of 8.
```
CREATE MATERIALIZED ZONEMAP sales_zmap
SCALE 8
AS
  SELECT SYS_OP_ZONE_ID(rowid), MIN(time_id), MAX(time_id)
  FROM sales
  GROUP BY SYS_OP_ZONE_ID(rowid);
```
The following example returns an error because the scale of the zone map being created is specified as 8, which does not match the *scale* argument of 12 specified in the `SYS_OP_ZONE_ID` function.
```
CREATE MATERIALIZED ZONEMAP sales_zmap
SCALE 8
AS
  SELECT SYS_OP_ZONE_ID(rowid,12), MIN(time_id), MAX(time_id)
  FROM sales
  GROUP BY SYS_OP_ZONE_ID(rowid,12);
```
The following example creates a join zone map. The fact table is `sales` and the dimension tables are `products` and `customers`. Because the table alias `s` is specified for the fact table in the `FROM` clause, the table alias *s* is also specified in the `SYS_OP_ZONE_ID` function.
```
CREATE MATERIALIZED ZONEMAP sales_zmap
AS
  SELECT SYS_OP_ZONE_ID(s.rowid),
         MIN(prod_category), MAX(prod_category),
         MIN(country_id), MAX(country_id)
  FROM sales s, products p, customers c
  WHERE s.prod_id = p.prod_id(+) AND
        s.cust_id = c.cust_id(+)
  GROUP BY SYS_OP_ZONE_ID(s.rowid);
```
