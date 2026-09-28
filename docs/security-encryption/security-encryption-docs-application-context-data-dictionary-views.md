# Application Context Data Dictionary Views

Oracle Database provides data dictionary views that provide information about application contexts.
The following table lists these data dictionary views.

| View | Description |
|---|---|
| ALL_CONTEXT | Describes all context namespaces in the current session for which attributes and values were specified using the DBMS_SESSION.SET_CONTEXT procedure. It lists the namespace and its associated schema and PL/SQL package. |
| ALL_POLICY_CONTEXTS | Describes the driving contexts defined for the synonyms, tables, and views accessible to the current user. (A driving context is a context used in a Virtual Private Database policy.) |
| DBA_CONTEXT | Provides all context namespace information in the database. Its columns are the same as those in the ALL_CONTEXT view, except that it includes the TYPE column. The TYPE column describes how the application context is accessed or initialized. |
| DBA_OBJECTS | Provides the names of existing application contexts. Query the OBJECT_TYPE column of the DBA_OBJECTS view, as follows: SELECT OBJECT_NAME FROM DBA_OBJECTS WHERE OBJECT_TYPE ='CONTEXT'; |
| DBA_POLICY_CONTEXTS | Describes all driving contexts in the database that were added by the DBMS_RLS.ADD_POLICY_CONTEXT procedure. Its columns are the same as those in ALL_POLICY_CONTEXTS. |
| SESSION_CONTEXT | Describes the context attributes and their values set for the current session. |
| USER_POLICY_CONTEXTS | Describes the driving contexts defined for the synonyms, tables, and views owned by the current user. Its columns (except for OBJECT_OWNER) are the same as those in ALL_POLICY_CONTEXTS. |
| V$CONTEXT | Lists set attributes in the current PDB session. Users do not have access to this view unless you grant the user the SELECT privilege on it. |
| V$SESSION | Lists detailed information about each current PDB session. Users do not have access to this view unless you grant the user the SELECT privilege on it. |

**Tip:** In addition to these views, check the database trace file if you find errors when running applications that use application contexts. The `USER_DUMP_DEST` initialization parameter sets the directory location of the trace files. You can find the value of this parameter by issuing `SHOW PARAMETER USER_DUMP_DEST` in SQL*Plus.
## Related Topics
**- Oracle Database Reference **- Oracle Database SQL Tuning Guide
