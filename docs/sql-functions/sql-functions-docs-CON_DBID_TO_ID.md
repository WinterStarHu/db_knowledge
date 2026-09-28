# CON_DBID_TO_ID

## Syntax
Description of the illustration con_dbid_to_id.gif Description of the illustration con_dbid_to_id.eps
## Purpose
`CON_DBID_TO_ID` takes as its argument a container DBID and returns the container ID. For *container_dbid*, specify a `NUMBER` value or any value that can be implicitly converted to `NUMBER`. The function returns a `NUMBER` value.
This function is useful in a multitenant container database (CDB). If you use this function in a non-CDB, then it returns 0.
## Example
The following query displays the ID and DBID for all containers in a CDB. The sample output shown is for the purpose of this example.
```
SELECT CON_ID, DBID
  FROM V$CONTAINERS;
    CON_ID       DBID
---------- ----------
         1 1930093401
         2 4054529501
         4 2256797992
```
The following statement returns the ID for the container with DBID 2256797992:
```
SELECT CON_DBID_TO_ID(2256797992) "Container ID"
  FROM DUAL;
Container ID
------------
           4
```
