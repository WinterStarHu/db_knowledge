# Version Query Pseudocolumns

The version query pseudocolumns are valid only in Oracle Flashback Version Query, which is a form of Oracle Flashback Query. The version query pseudocolumns are:
````````
- VERSIONS_STARTSCN and VERSIONS_STARTTIME: Starting System Change Number (SCN) or TIMESTAMP when the row version was created. This pseudocolumn identifies the time when the data first had the values reflected in the row version. Use this pseudocolumn to identify the past target time for Oracle Flashback Table or Oracle Flashback Query. If this pseudocolumn is NULL, then the row version was created before start.
``````````
- VERSIONS_ENDSCN and VERSIONS_ENDTIME: SCN or TIMESTAMP when the row version expired. If the pseudocolumn is NULL, then either the row version was current at the time of the query or the row corresponds to a DELETE operation.
````
- VERSIONS_XID: Identifier (a RAW number) of the transaction that created the row version.
``````````````
````````````
- VERSIONS_OPERATION: Operation performed by the transaction: I for insertion, D for deletion, or U for update. The version is that of the row that was inserted, deleted, or updated; that is, the row after an INSERT operation, the row before a DELETE operation, or the row affected by an UPDATE operation. For user updates of an index key, Oracle Flashback Version Query might treat an UPDATE operation as two operations, DELETE plus INSERT, represented as two version rows with a D followed by an I VERSIONS_OPERATION.
**See Also:**
**
- flashback_query_clause for more information on version queries
**
- Oracle Database Development Guide for more information on using Oracle Flashback Version Query
**
- in Oracle Database Globalization Support Guide for the collation derivation rules for values of the VERSIONS_OPERATION pseudocolumn
