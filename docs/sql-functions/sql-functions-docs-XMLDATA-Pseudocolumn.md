# XMLDATA Pseudocolumn

Oracle stores `XMLType` data either in LOB or object-relational columns, based on XMLSchema information and how you specify the storage clause. The `XMLDATA` pseudocolumn lets you access the underlying LOB or object relational column to specify additional storage clause parameters, constraints, indexes, and so forth.
## Example
The following statements illustrate the use of this pseudocolumn. Suppose you create a simple table of `XMLType` with one `CLOB` column:
```
CREATE TABLE xml_lob_tab of XMLTYPE
  XMLTYPE STORE AS CLOB;
```
To change the storage characteristics of the underlying LOB column, you can use the following statement:
```
ALTER TABLE xml_lob_tab
  MODIFY LOB (XMLDATA) (STORAGE (MAXSIZE 2G) CACHE);
```
Now suppose you have created an XMLSchema-based table like the `xwarehouses` table created in Using XML in SQL Statements. You could then use the `XMLDATA` column to set the properties of the underlying columns, as shown in the following statement:
```
ALTER TABLE xwarehouses
  ADD (UNIQUE(XMLDATA."WarehouseId"));
```
