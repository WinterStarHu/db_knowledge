# Oracle Virtual Private Database Data Dictionary Views

Oracle Database provides data dictionary views that list information about Oracle Virtual Private Database policies.
The following table lists Virtual Private Database-specific views.

| View | Description |
|---|---|
| ALL_POLICIES | Describes all Oracle Virtual Private Database security policies for objects accessible to the current user. |
| ALL_POLICY_ATTRIBUTES | Describes all the application context namespaces, attributes, and Virtual Private Database policy associations where the logged in user is the owner of the VPD policy or the VPD policy belongs to PUBLIC. |
| ALL_POLICY_CONTEXTS | Describes the driving contexts defined for the synonyms, tables, and views accessible to the current user. A driving context is an application context used in an Oracle Virtual Private Database policy. |
| ALL_POLICY_GROUPS | Describes the Oracle Virtual Private Database policy groups defined for the synonyms, tables, and views accessible to the current user |
| ALL_SEC_RELEVANT_COLS | Describes the security relevant columns of the security policies for the tables and views accessible to the current user |
| DBA_POLICIES | Describes all Oracle Virtual Private Database security policies in the database. |
| DBA_POLICY_ATTRIBUTES | Describes all the application context namespaces, attributes, and Virtual Private Database policy associations for context-sensitive and shared context-sensitive Virtual Private Database policies |
| DBA_POLICY_GROUPS | Describes all policy groups in the database. |
| DBA_POLICY_CONTEXTS | Describes all driving contexts in the database. Its columns are the same as those in ALL_POLICY_CONTEXTS. |
| DBA_SEC_RELEVANT_COLS | Describes the security relevant columns of all security policies in the database |
| UNIFIED_AUDIT_TRAIL | Captures the VPD predicates in the RLS_INFO column, for unified auditing and fine-grained auditing |
| USER_POLICIES | Describes all Oracle Virtual Private Database security policies associated with objects owned by the current user. This view does not display the OBJECT_OWNER column. |
| USER_POLICY_ATTRIBUTES | Describes all the application context namespaces, attributes, and Virtual Private Database policy associations where the owner of the Virtual Private Database policy is the current user |
| USER_POLICY_CONTEXTS | Describes the driving contexts defined for the synonyms, tables, and views owned by the current user. Its columns (except for OBJECT_OWNER) are the same as those in ALL_POLICY_CONTEXTS. |
| USER_SEC_RELEVANT_COLS | Describes the security relevant columns of the security policies for the tables and views owned by the current user. Its columns (except for OBJECT_OWNER) are the same as those in ALL_SEC_RELEVANT_COLS. |
| USER_POLICY_GROUPS | Describes the policy groups defined for the synonyms, tables, and views owned by the current user. This view does not display the OBJECT_OWNER column. |
| V$VPD_POLICY | For the current PDB, displays all the fine-grained security policies and predicates associated with the cursors currently in the library cache. This view is useful for finding the policies that were applied to a SQL statement. |

**Tip:** In addition to these views, check the database trace file if you find errors in application that use Virtual Private Database policies. The `USER_DUMP_DEST` initialization parameter specifies the current location of the trace files. You can find the value of this parameter by issuing `SHOW PARAMETER USER_DUMP_DEST` in SQL*Plus.
## Related Topics
**- Oracle Database Reference **- Oracle Database SQL Tuning Guide
