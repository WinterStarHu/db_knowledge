# Hierarchical Query Pseudocolumns

The hierarchical query pseudocolumns are valid only in hierarchical queries. The hierarchical query pseudocolumns are:
- CONNECT_BY_ISCYCLE Pseudocolumn
- CONNECT_BY_ISLEAF Pseudocolumn
- LEVEL Pseudocolumn
To define a hierarchical relationship in a query, you must use the `CONNECT` `BY` clause.
## CONNECT_BY_ISCYCLE Pseudocolumn
The `CONNECT_BY_ISCYCLE` pseudocolumn returns 1 if the current row has a child which is also its ancestor. Otherwise it returns 0.
You can specify `CONNECT_BY_ISCYCLE` only if you have specified the `NOCYCLE` parameter of the `CONNECT` `BY` clause. `NOCYCLE` enables Oracle to return the results of a query that would otherwise fail because of a `CONNECT` `BY` loop in the data.
**See Also:**   Hierarchical Queries for more information about the `NOCYCLE` parameter and Hierarchical Query Examples for an example that uses the `CONNECT_BY_ISCYCLE` pseudocolumn
## CONNECT_BY_ISLEAF Pseudocolumn
The `CONNECT_BY_ISLEAF` pseudocolumn returns 1 if the current row is a leaf of the tree defined by the `CONNECT` `BY` condition. Otherwise it returns 0. This information indicates whether a given row can be further expanded to show more of the hierarchy.
**CONNECT_BY_ISLEAF Example** The following example shows the first three levels of the `hr.employees` table, indicating for each row whether it is a leaf row (indicated by 1 in the `IsLeaf` column) or whether it has child rows (indicated by 0 in the `IsLeaf` column):
```
SELECT last_name "Employee", CONNECT_BY_ISLEAF "IsLeaf",
       LEVEL, SYS_CONNECT_BY_PATH(last_name, '/') "Path"
  FROM employees
  WHERE LEVEL <= 3 AND department_id = 80
  START WITH employee_id = 100
  CONNECT BY PRIOR employee_id = manager_id AND LEVEL <= 4
  ORDER BY "Employee", "IsLeaf";
Employee                      IsLeaf      LEVEL Path
------------------------- ---------- ---------- -------------------------
Abel                               1          3 /King/Zlotkey/Abel
Ande                               1          3 /King/Errazuriz/Ande
Banda                              1          3 /King/Errazuriz/Banda
Bates                              1          3 /King/Cambrault/Bates
Bernstein                          1          3 /King/Russell/Bernstein
Bloom                              1          3 /King/Cambrault/Bloom
Cambrault                          0          2 /King/Cambrault
Cambrault                          1          3 /King/Russell/Cambrault
Doran                              1          3 /King/Partners/Doran
Errazuriz                          0          2 /King/Errazuriz
Fox                                1          3 /King/Cambrault/Fox
. . .
```
**See Also:**   Hierarchical Queries and SYS_CONNECT_BY_PATH
## LEVEL Pseudocolumn
For each row returned by a hierarchical query, the `LEVEL` pseudocolumn returns 1 for a root row, 2 for a child of a root, and so on. A **root row** is the highest row within an inverted tree. A **child row** is any nonroot row. A **parent row** is any row that has children. A **leaf row** is any row without children. Figure 3-1 shows the nodes of an inverted tree with their `LEVEL` values.
Figure 1: Hierarchical Tree Description of the illustration sqlrf001.gif Description of the illustration sqlrf001.eps **See Also:**   Hierarchical Queries for information on hierarchical queries in general and IN Condition for restrictions on using the `LEVEL` pseudocolumn
