# Configuration of Oracle Virtual Private Database Policies

The script content on this page is for navigation purposes only and does not alter the content in any way.
The `DBMS_RLS` PL/SQL package can configure Oracle Virtual Private Database (VPD) policies.
- About Oracle Virtual Private Database Policies The Oracle Virtual Private Database policy associates the VPD function with a database table, view, or synonym.
- Attaching a Policy to a Database Table, View, or Synonym The DBMS_RLS PL/SQL package can attach a policy to a table, view, or synonym.
- Example: Attaching a Simple Oracle Virtual Private Database Policy to a Table The DBMS_RLS.ADD_POLICY procedure can attach an Oracle Virtual Private Database (VPD) policy to a table, view, or synomym.
``````````
- Enforcing Policies on Specific SQL Statement Types You can enforce Oracle Virtual Private Database policies for SELECT, INSERT, UPDATE, INDEX, and DELETE statements.
````````
- Example: Specifying SQL Statement Types with DBMS_RLS.ADD_POLICY The DBMS_RLS.ADD_POLICY procedure statement_types parameter can specify the SELECT and INDEX statements for a policy.
- Control of the Display of Column Data with Policies You can create policies that enforce row-level security when a security-relevant column is referenced in a query.
- Oracle Virtual Private Database Policy Groups An Oracle Virtual Private Database policy group is a named collection of VPD policies that can be applied to an application.
- Optimizing Performance by Using Oracle Virtual Private Database Policy Types You can optimize performance by using the Oracle Virtual Private Database (VPD) the dynamic, static, or shared policy types.
## About Oracle Virtual Private Database Policies
The Oracle Virtual Private Database policy associates the VPD function with a database table, view, or synonym.
This function defines the actions of the Oracle Virtual Private Database `WHERE` clause. You must then associate this function with the database table to which the Oracle Virtual Private Database (VPD) action applies.
You can do this by configuring an Oracle Virtual Private Database policy. The policy itself is a mechanism for managing the Virtual Private Database function. The policy also enables you to add fine-grained access control, such as specifying the types of SQL statements or particular table columns the policy affects. When a user tries to access the data in this database object, the policy goes into effect automatically.
The following table lists the procedures in the `DBMS_RLS` package.

| Procedure | Description |
|---|---|
| For Handling Individual Policies | - |
| DBMS_RLS.ADD_POLICY | Adds a policy to a table, view, or synonym |
| DBMS_RLS.ENABLE_POLICY | Enables (or disables) a policy you previously added to a table, view, or synonym |
| DBMS_RLS.ALTER_POLICY | Alters an existing policy to associate or disassociate attributes with the policy |
| DBMS_RLS.REFRESH_POLICY | Invalidates cursors associated with nonstatic policies |
| DBMS_RLS.DROP_POLICY | To drop a policy from a table, view, or synonym |
| For Handling Grouped Policies | - |
| DBMS_RLS.CREATE_POLICY_GROUP | Creates a policy group |
| DBMS_RLS.ALTER_GROUPED_POLICY | Alters a policy group |
| DBMS_RLS.DELETE_POLICY_GROUP | Drops a policy group |
| DBMS_RLS.ADD_GROUPED_POLICY | Adds a policy to the specified policy group |
| DBMS_RLS.ENABLE_GROUPED_POLICY | Enables a policy within a group |
| DBMS_RLS.REFRESH_GROUPED_POLICY | Parses again the SQL statements associated with a refreshed policy |
| DBMS_RLS.DISABLE_GROUPED_POLICY | Disables a policy within a group |
| DBMS_RLS.DROP_GROUPED_POLICY | Drops a policy that is a member of the specified group |
| For Handling Application Contexts | - |
| DBMS_RLS.ADD_POLICY_CONTEXT | Adds the context for the active application |
| DBMS_RLS.DROP_POLICY_CONTEXT | Drops the context for the application |

## Attaching a Policy to a Database Table, View, or Synonym
The `DBMS_RLS` PL/SQL package can attach a policy to a table, view, or synonym.
  - To attach a policy to a database table, view, or synonym, use the DBMS_RLS.ADD_POLICY procedure.
You must specify the table, view, or synonym to which you are adding a policy, and a name for the policy. You can also specify other information, such as the types of statements the policy controls (`SELECT`, `INSERT`, `UPDATE`, `DELETE`, `CREATE INDEX`, or `ALTER INDEX`).
Follow these guidelines:
- If a view has been created as an extended data-linked object, then Oracle recommends that you apply the same VPD policy on this type of view as you would on the underlying objects of the view.
- Determine if the base object to which you want to add the VPD policy has dependent objects. If it does have dependent objects, then these objects will become invalid when the VPD policy is added to the base object, and these objects will be recompiled automatically when they are used. Alternatively, you can proactively recompile them yourself by using an ALTER ... COMPILE statement. Be aware that invalidating dependent objects (by adding a VPD policy on their base object) and causing them to need to be recompiled can decrease performance in the overall system. Oracle recommends that you only add a VPD policy to an object that has dependent objects during off-peak hours or during a scheduled downtime.
- Be aware that the maximum number of policies that can be created for a single object is 255.
## Example: Attaching a Simple Oracle Virtual Private Database Policy to a Table
The `DBMS_RLS.ADD_POLICY` procedure can attach an Oracle Virtual Private Database (VPD) policy to a table, view, or synomym.
Example 14-1 shows how to use `DBMS_RLS.ADD_POLICY` to attach an Oracle Virtual Private Database policy called `secure_update` to the `HR.EMPLOYEES` table. The function attached to the policy is `check_updates`.
Example 14-1 Attaching a Simple Oracle Virtual Private Database Policy to a Table
```
BEGIN
 DBMS_RLS.ADD_POLICY(
  object_schema   => 'hr',
  object_name     => 'employees',
  policy_name     => 'secure_update',
  policy_function => 'check_updates',
...
```
If the function was created inside a package, include the package name. For example:
```
 policy_function => 'pkg.check_updates',
...
```
Although you can define a policy against a table, you cannot select that table from within the policy that was defined against the table.
## Enforcing Policies on Specific SQL Statement Types
You can enforce Oracle Virtual Private Database policies for `SELECT`, `INSERT`, `UPDATE`, `INDEX`, and `DELETE` statements.
  ````- To specify a SQL statement type for the policy, use the statement_types parameter in the DBMS_RLS.ADD_POLICY procedure. If you want to specify more than one, separate each with a comma. Enclose the list in a pair of single quotation marks.
If you do not specify a statement type, then by default, Oracle Database specifies `SELECT`, `INSERT`, `UPDATE`, and `DELETE`, but not `INDEX`. You can enter any combination of these statement types.
When you specify the `statement_types` parameter, be aware of the following functionality:
****``````````
- The application code affected by the Virtual Private Database policy can include the MERGE INTO statement. However, in the Virtual Private Database policy, you must ensure that the statement_types parameter includes all three of the INSERT, UPDATE, and DELETE statements for the policy to succeed. Alternatively, you can omit the statement_types parameter.
****````
- Be aware that a user who has privileges to maintain an index can see all the row data, even if the user does not have full table access under a regular query such as SELECT. For example, a user can create a function-based index that contains a user-defined function with column values as its arguments. During index creation, Oracle Database passes column values of every row into the user function, making the row data available to the user who creates the index. You can enforce Oracle Virtual Private Database policies on index maintenance operations by specifying INDEX with the statement_types parameter.
## Example: Specifying SQL Statement Types with DBMS_RLS.ADD_POLICY
The `DBMS_RLS.ADD_POLICY` procedure `statement_types` parameter can specify the `SELECT` and `INDEX` statements for a policy.
Example 14-2 shows an how this works.
Example 14-2 Specifying SQL Statement Types with DBMS_RLS.ADD_POLICY
```
BEGIN DBMS_RLS.ADD_POLICY( object_schema   => 'hr', object_name     => 'employees', policy_name     => 'secure_update', policy_function => 'check_updates', **statement_types => 'SELECT,INDEX'**);
END;
/
```
## Control of the Display of Column Data with Policies
You can create policies that enforce row-level security when a security-relevant column is referenced in a query.
- Policies for Column-Level Oracle Virtual Private Database Column-level policies enforce row-level security when a query references a security-relevant column.
- Example: Creating a Column-Level Oracle Virtual Private Database Policy The CREATE FUNCTION statement and the DBMS_RLS.ADD_POLICY procedure can configure a column-level Oracle Virtual Private Database policy.
- Display of Only the Column Rows Relevant to the Query Be default, column-level Oracle Virtual Private Database restricts the number of rows a query returns that references columns containing sensitive information.
- Column Masking to Display Sensitive Columns as NULL Values If a query references a sensitive column, then by default column-level Oracle Virtual Private Database restricts the number of rows returned.
- Example: Adding Column Masking to an Oracle Virtual Private Database Policy The DBMS_RLS.ADD_POLICY procedure can configure column-level Oracle Virtual Private Database column masking.
### Policies for Column-Level Oracle Virtual Private Database
Column-level policies enforce row-level security when a query references a security-relevant column.
You can apply a column-level Oracle Virtual Private Database policy to tables and views, but not to synonyms. To apply the policy to a column, specify the security-relevant column by using the `SEC_RELEVANT_COLS` parameter of the `DBMS_RLS.ADD_POLICY` procedure. This parameter applies the security policy whenever the column is referenced, explicitly or implicitly, in a query.
For example, users who are not in a Human Resources department typically are allowed to view only their own Social Security numbers. A sales clerk initiates the following query:
```
SELECT fname, lname, ssn FROM emp;
```
The function implementing the security policy returns the predicate `ssn='my_ssn`’. Oracle Database rewrites the query and executes the following:
```
SELECT fname, lname, ssn FROM emp WHERE ssn = 'my_ssn';
```
### Example: Creating a Column-Level Oracle Virtual Private Database Policy
The CREATE FUNCTION statement and the DBMS_RLS.ADD_POLICY procedure can configure a column-level Oracle Virtual Private Database policy.
Example 14-3 shows an Oracle Virtual Private Database policy in which sales department users cannot see the salaries of people outside the department (department number 30) of the sales department users. The relevant columns for this policy are `sal` and `comm`. First, the Oracle Virtual Private Database policy function is created, and then it is added by using the `DBMS_RLS` PL/SQL package.
Example 14-3 Creating a Column-Level Oracle Virtual Private Database Policy
```
CREATE OR REPLACE FUNCTION hide_sal_comm ( v_schema IN VARCHAR2, v_objname IN VARCHAR2) RETURN VARCHAR2 AS con VARCHAR2 (200);
BEGIN con := 'deptno=30';
RETURN (con);
END hide_sal_comm;
```
Then you configure the policy with the `DBMS_RLS.ADD_POLICY` procedure as follows:
```
BEGIN DBMS_RLS.ADD_POLICY ( object_schema     => 'scott', object_name       => 'emp', policy_name       => 'hide_sal_policy', policy_function   => 'hide_sal_comm', **sec_relevant_cols => 'sal,comm');** END;
```
### Display of Only the Column Rows Relevant to the Query
Be default, column-level Oracle Virtual Private Database restricts the number of rows a query returns that references columns containing sensitive information.
You specify these security-relevant columns by using the `SEC_RELEVANT_COLUMNS` parameter of the `DBMS_RLS.ADD_POLICY` procedure, as shown in Example 14-3.
For example, consider sales department users with the `SELECT` privilege on the `emp` table, which is protected with the column-level Oracle Virtual Private Database policy created in Example 14-3. The user (for example, user `SCOTT`) runs the following query:
```
SELECT ENAME, d.dname, JOB, SAL, COMM FROM emp e, dept d WHERE d.deptno = e.deptno;
```
The database returns the following rows:
```
ENAME      DNAME          JOB              SAL       COMM
---------- -------------- --------- ---------- ----------
ALLEN      SALES          SALESMAN        1600        300 WARD       SALES          SALESMAN        1250        500 MARTIN     SALES          SALESMAN        1250       1400 BLAKE      SALES          MANAGER         2850 TURNER     SALES          SALESMAN        1500          0 JAMES      SALES          CLERK            950 6 rows selected.
```
The only rows that are displayed are those that the user has privileges to access all columns in the row.
### Column Masking to Display Sensitive Columns as NULL Values
If a query references a sensitive column, then by default column-level Oracle Virtual Private Database restricts the number of rows returned.
With column-masking behavior, all rows display, even those that reference sensitive columns. However, the sensitive columns display as `NULL` values. To enable column-masking, set the `SEC_RELEVANT_COLS_opt` parameter of the `DBMS_RLS.ADD_POLICY` procedure.
For example, consider the results of the sales clerk query, described in the previous example. If column-masking is used, then instead of seeing only the row containing the details and Social Security number of the sales clerk, the clerk would see all rows from the `emp` table, but the `ssn` column values would be returned as `NULL`. Note that this behavior is fundamentally different from all other types of Oracle Virtual Private Database policies, which return only a subset of rows.
In contrast to the default action of column-level Oracle Virtual Private Database, column-masking displays all rows, but returns sensitive column values as `NULL`. To include column-masking in your policy, set the `SEC_RELEVANT_COLS_OPT` parameter of the `DBMS_RLS.ADD_POLICY` procedure to `DBMS_RLS.ALL_ROWS`.
The following considerations apply to column masking:
- Column-masking applies only to SELECT statements.
- Column-masking conditions generated by the policy function must be simple Boolean expressions, unlike regular Oracle Virtual Private Database predicates.
``````
- For applications that perform calculations, or do not expect NULL values, use standard column-level Oracle Virtual Private Database, specifying SEC_RELEVANT_COLS rather than the SEC_RELEVANT_COLS_OPT column-masking option.
``````
- Do not include columns of the object data type (including the XMLtype) in the sec_relevant_cols setting. This column type is not supported for the sec_relevant_cols setting.
- Column-masking used with UPDATE AS SELECT updates only the columns that users are allowed to see.
- For some queries, column-masking may prevent some rows from displaying. For example:
```
SELECT * FROM emp WHERE sal = 10;
```
Because the column-masking option was set, this query may not return rows if the `salary` column returns a `NULL` value.
### Example: Adding Column Masking to an Oracle Virtual Private Database Policy
The DBMS_RLS.ADD_POLICY procedure can configure column-level Oracle Virtual Private Database column masking.
Example 14-4 shows column-level Oracle Virtual Private Database column masking. It uses the same VPD policy as Example: Creating a Column-Level Oracle Virtual Private Database Policy, but with `sec_relevant_cols_opt` specified as `DBMS_RLS.ALL_ROWS`.
Example 14-4 Adding Column Masking to an Oracle Virtual Private Database Policy
```
BEGIN DBMS_RLS.ADD_POLICY( object_schema         => 'scott', object_name           => 'emp', policy_name           => 'hide_sal_policy', policy_function       => 'hide_sal_comm', sec_relevant_cols     =>' sal,comm', sec_relevant_cols_opt => dbms_rls.ALL_ROWS);
END;
```
Assume that a sales department user with `SELECT` privilege on the `emp` table (such as user `SCOTT`) runs the following query:
```
SELECT ENAME, d.dname, job, sal, comm FROM emp e, dept d WHERE d.deptno = e.deptno;
```
The database returns all rows specified in the query, but with certain values masked because of the Oracle Virtual Private Database policy:
```
ENAME      DNAME          JOB              SAL       COMM
---------- -------------- --------- ---------- ----------
CLARK      ACCOUNTING     MANAGER KING       ACCOUNTING     PRESIDENT MILLER     ACCOUNTING     CLERK JONES      RESEARCH       MANAGER FORD       RESEARCH       ANALYST ADAMS      RESEARCH       CLERK SMITH      RESEARCH       CLERK SCOTT      RESEARCH       ANALYST WARD       SALES          SALESMAN        1250        500 TURNER     SALES          SALESMAN        1500          0 ALLEN      SALES          SALESMAN        1600        300 JAMES      SALES          CLERK            950 BLAKE      SALES          MANAGER         2850 MARTIN     SALES          SALESMAN        1250       1400 14 rows selected.
```
The column-masking returned all rows requested by the sales user query, but made the `sal` and `comm` columns `NULL` for employees outside the sales department.
## Oracle Virtual Private Database Policy Groups
An Oracle Virtual Private Database policy group is a named collection of VPD policies that can be applied to an application.
- About Oracle Virtual Private Database Policy Groups You can group multiple security policies together, and apply them to an application.
- Creation of a New Oracle Virtual Private Database Policy Group The DBMS_RLS.ADD_GROUPED_POLICY procedure adds a VPD policy to a VPD policy group.
- Default Policy Group with the SYS_DEFAULT Policy Group Within a group of security policies, you can designate one security policy to be the default security policy.
- Multiple Policies for Each Table, View, or Synonym You can establish several policies for the same table, view, or synonym.
- Validation of the Application Used to Connect to the Database The package implementing the driving context must correctly validate the application that is being used to connect to the database.
### About Oracle Virtual Private Database Policy Groups
You can group multiple security policies together, and apply them to an application.
A policy group is a set of security policies that belong to an application. You can designate an application context (known as a *driving context* or *policy context*) to indicate the policy group in effect. Then, when a user accesses the table, view, or synonym column, Oracle Database looks up the driving context to determine the policy group in effect. It enforces all the associated policies that belong to the policy group.
Policy groups are useful for situations where multiple applications with multiple security policies share the same table, view, or synonym. This enables you to identify those policies that should be in effect when the table, view, or synonym is accessed.
For example, in a hosting environment, Company A can host the `BENEFIT` table for Company B and Company C. The table is accessed by two different applications, Human Resources and Finance, with two different security policies. The Human Resources application authorizes users based on ranking in the company, and the Finance application authorizes users based on department. Integrating these two policies into the `BENEFIT` table requires joint development of policies between the two companies, which is not a feasible option. By defining an application context to drive the enforcement of a particular set of policies to the base objects, each application can implement a private set of security policies.
To do this, you organize security policies into groups. By referring to the application context, Oracle Database determines which group of policies should be in effect at run time. The server enforces all the policies that belong to that policy group.
### Creation of a New Oracle Virtual Private Database Policy Group
The `DBMS_RLS.ADD_GROUPED_POLICY` procedure adds a VPD policy to a VPD policy group.
To specify which policies will be effective, you can add a driving context using the `DBMS_RLS.ADD_POLICY_CONTEXT` procedure. If the driving context returns an unknown policy group, then an error is returned.
If the driving context is not defined, then Oracle Database runs all policies. Likewise, if the driving context is `NULL`, then policies from all policy groups are enforced. An application accessing the data cannot bypass the security setup module (which sets up application context) to avoid any applicable policies.
You can apply multiple driving contexts to the same table, view, or synonym, and each of them will be processed individually. This enables you to configure multiple active sets of policies to be enforced.
Consider, for example, a hosting company that hosts Benefits and Financial applications, which share some database objects. Both applications are striped for hosting using a `SUBSCRIBER` policy in the `SYS_DEFAULT` policy group. Data access is partitioned first by subscriber ID, then by whether the user is accessing the Benefits or Financial applications (determined by a driving context). Suppose that Company A, which uses the hosting services, wants to apply a custom policy that relates only to its own data access. You could add an additional driving context (such as `COMPANY A SPECIAL`) to ensure that the additional, special policy group is applied for data access for Company A only. You would not apply this under the `SUBSCRIBER` policy, because the policy relates only to Company A, and it is more efficient to segregate the basic hosting policy from other policies.
### Default Policy Group with the SYS_DEFAULT Policy Group
Within a group of security policies, you can designate one security policy to be the default security policy.
This is useful in situations where you partition security policies by application, so that they will be always be in effect. Default security policies enable developers to base security enforcement under all conditions, while partitioning security policies by application (using security groups) enables layering of additional, application-specific security on top of default security policies. To implement default security policies, you add the policy to the `SYS_DEFAULT` policy group.
Policies defined in this group for a particular table, view, or synonym are run with the policy group specified by the driving context. As described earlier, a driving context is an application context that indicates the policy group in effect. The `SYS_DEFAULT` policy group may or may not contain policies. You cannot to drop the `SYS_DEFAULT` policy group. If you do, then Oracle Database displays an error.
If, to the `SYS_DEFAULT` policy group, you add policies associated with two or more objects, then each object will have a separate `SYS_DEFAULT` policy group associated with it. For example, the `emp` table in the `scott` schema has one `SYS_DEFAULT` policy group, and the `dept` table in the `scott` schema has a different `SYS_DEFAULT` policy group associated with it. Think of them as being organized in the tree structure as follows:
```
SYS_DEFAULT
  - policy1 (scott/emp)
  - policy3 (scott/emp)
SYS_DEFAULT
  - policy2 (scott/dept)
```
You can create policy groups with identical names. When you select a particular policy group, its associated schema and object name are displayed in the property sheet on the right side of the screen.
### Multiple Policies for Each Table, View, or Synonym
You can establish several policies for the same table, view, or synonym.
Suppose, for example, you have a base application for Order Entry, and each division of your company has its own rules for data access. You can add a division-specific policy function to a table without having to rewrite the policy function of the base application.
All policies applied to a table are enforced with `AND` syntax. If you have three policies applied to the `CUSTOMERS` table, then each policy is applied to the table. You can use policy groups and an application context to partition fine-grained access control enforcement so that different policies apply, depending upon which application is accessing data. This eliminates the requirement for development groups to collaborate on policies, and simplifies application development. You can also have a default policy group that is always applicable (for example, to enforce data separated by subscriber in a hosting environment).
### Validation of the Application Used to Connect to the Database
The package implementing the driving context must correctly validate the application that is being used to connect to the database.
Although Oracle Database checks the call stack to ensure that the package implementing the driving context sets context attributes, inadequate validation can still occur within the package. For example, in applications where database users or enterprise users are known to the database, the user needs the `EXECUTE` privilege on the package that sets the driving context. Consider a user who knows that the `BENEFITS` application enables more liberal access than the `HR` application. The `setctx` procedure (which sets the correct policy group within the driving context) does not perform any validation to determine which application is actually connecting. That is, the procedure does not check either the IP address of the incoming connection (for a three-tier system) or the `proxy_user` attribute of the user session.
This user could pass to the driving context package an argument setting the context to the more liberal `BENEFITS` policy group, and then access the `HR` application instead. Because the `setctx` does no further validation of the application, this user bypasses the more restrictive HR security policy.
By contrast, if you implement proxy authentication with Oracle Virtual Private Database, then you can determine the identity of the middle tier (and the application) that is connecting to the database on behalf of a user. The correct policy will be applied for each application to mediate data access.
For example, a developer using the proxy authentication feature could determine that the application (the middle tier) connecting to the database is `HRAPPSERVER`. The package that implements the driving context can thus verify whether the `proxy_user `in the user session is `HRAPPSERVER`. If so, then it can set the driving context to use the `HR` policy group. If `proxy_user `is not `HRAPPSERVER`, then it can deny access.
In this case, the following query is executed:
```
SELECT * FROM apps.benefit;
```
Oracle Database picks up policies from the default policy group (`SYS_DEFAULT`) and active namespace `HR`. The query is internally rewritten as follows:
```
SELECT * FROM apps.benefit WHERE company = SYS_CONTEXT('ID','MY_COMPANY') AND SYS_CONTEXT('ID','TITLE') = 'MANAGER';
```
## Optimizing Performance by Using Oracle Virtual Private Database Policy Types
You can optimize performance by using the Oracle Virtual Private Database (VPD) the dynamic, static, or shared policy types.
- About Oracle Virtual Private Database Policy Types Specifying a policy type for your policies can optimize performance each the Oracle Virtual Private Database policy runs.
- Dynamic Policy Type to Automatically Rerun Policy Functions The DYNAMIC policy type runs the policy function each time a user accesses the Virtual Private Database-protected database objects.
- Example: Creating a DYNAMIC Policy with DBMS_RLS.ADD_POLICY The DBMS_RLS.ADD_POLICY procedure can create a dynamic Oracle Virtual Private Database policy.
- Static Policy to Prevent Policy Functions from Rerunning for Each Query The static policy type enforces the same predicate for all users in the instance.
- Example: Creating a Static Policy with DBMS_RLS.ADD_POLICY The DBMS_RLS.ADD_POLICY procedure can create a static Oracle Virtual Private Database (VPD) policy.
- Example: Shared Static Policy to Share a Policy with Multiple Objects The DBMS_RLS.ADD_POLICY procedure can create a shared static Oracle Virtual Private Database policy to share the policy with multiple objects.
- When to Use Static and Shared Static Policies Static policies are ideal when every query requires the same predicate and fast performance is essential, such as hosting environments.
- Context-Sensitive Policy for Application Context Attributes That Change Context-sensitive policies are useful when different predicates must be applied depending on which predicate executes the query.
- Example: Creating a Context-Sensitive Policy with DBMS_RLS.ADD_POLICY The DBMS_RLS.ADD_POLICY procedure can create an Oracle Virtual Private Database context-sensitive policy.
- Example: Refreshing Cached Statements for a VPD Context-Sensitive Policy The DBMS_RLS.REFRESH_POLICY statement can refresh cached statements for Oracle Virtual Private Database context-sensitive policies.
- Example: Altering an Existing Context-Sensitive Policy The DBMS_RLS.ALTER_POLICY procedure can modify an Oracle Virtual Private Database policy.
- Example: Using a Shared Context Sensitive Policy to Share a Policy with Multiple Objects The DBMS_RLS.ADD_POLICY procedure can create a shared context-sensitive Oracle Virtual Private Database to share a policy that has multiple objects.
- When to Use Context-Sensitive and Shared Context-Sensitive Policies Use context-sensitive policies when a predicate does not need to change for a user session, but the policy must enforce multiple predicates for different users or groups.
- Summary of the Five Oracle Virtual Private Database Policy Types Oracle Virtual Private Database provides five policy types, based on user needs such as hosting environments.
### About Oracle Virtual Private Database Policy Types
Specifying a policy type for your policies can optimize performance each the Oracle Virtual Private Database policy runs.
Policy types control how Oracle Database caches Oracle Virtual Private Database policy predicates. Consider setting a policy type for your policies, because the execution of policy functions can use a significant amount of system resources. Minimizing the number of times that a policy function can run optimizes database performance.
You can choose from five policy types: `DYNAMIC`, `STATIC`, `SHARED_STATIC`, `CONTEXT_SENSITIVE`, and `SHARED_CONTEXT_SENSITIVE`. These enable you to precisely specify how often a policy predicate should change. To specify the policy type, set the `policy_type` parameter of the `DBMS_RLS.ADD POLICY` procedure.
### Dynamic Policy Type to Automatically Rerun Policy Functions
The `DYNAMIC` policy type runs the policy function each time a user accesses the Virtual Private Database-protected database objects.
If you do not specify a policy type in the `DBMS_RLS.ADD_POLICY` procedure, then, by default, your policy will be dynamic. You can specifically configure a policy to be dynamic by setting the `policy_type` parameter of the `DBMS_RLS.ADD_POLICY` procedure to `DYNAMIC`.
This policy type does not optimize database performance as the static and context sensitive policy types do. However, Oracle recommends that before you set policies as either static or context-sensitive, you should first test them as `DYNAMIC` policy types, which run every time. Testing policy functions as `DYNAMIC` policies first enables you to observe how the policy function affects each query, because nothing is cached. This ensures that the functions work properly before you enable them as static or context-sensitive policy types to optimize performance.
You can use the `DBMS_UTILITY.GET_TIME` function to measure the start and end times for a statement to execute. For example:
```
**-- 1. Get the start time:** SELECT DBMS_UTILITY.GET_TIME FROM DUAL;
GET_TIME
----------
2312721 **-- 2. Run the statement:** SELECT COUNT(*) FROM HR.EMPLOYEES;
COUNT(*)
----------
107 **-- 3. Get the end time:** SELECT DBMS_UTILITY.GET_TIME FROM DUAL;
GET_TIME
----------
2314319
```
### Example: Creating a DYNAMIC Policy with DBMS_RLS.ADD_POLICY
The `DBMS_RLS.ADD_POLICY` procedure can create a dynamic Oracle Virtual Private Database policy.
Example 14-5 shows how to create the `DYNAMIC` policy type.
Example 14-5 Creating a DYNAMIC Policy with DBMS_RLS.ADD_POLICY
```
BEGIN DBMS_RLS.ADD_POLICY( object_schema   => 'hr', object_name     => 'employees', policy_name     => 'secure_update', policy_function => 'hide_fin', policy_type     => dbms_rls.DYNAMIC);
END;
/
```
### Static Policy to Prevent Policy Functions from Rerunning for Each Query
The static policy type enforces the same predicate for all users in the instance.
Oracle Database stores static policy predicates in SGA, so policy functions do not rerun for each query. This results in faster performance.
You can enable static policies by setting the `policy_type` parameter of the `DBMS_RLS.ADD_POLICY` procedure to either `STATIC` or `SHARED_STATIC`, depending on whether or not you want the policy to be shared across multiple objects.
Each execution of the same cursor could produce a different row set for the same predicate, because the predicate may filter the data differently based on attributes such as `SYS_CONTEXT` or `SYSDATE`.
For example, suppose you enable a policy as either a `STATIC` or `SHARED_STATIC` policy type, which appends the following predicate to all queries made against policy protected database objects:
```
WHERE dept = SYS_CONTEXT ('hr_app','deptno')
```
Although the predicate does not change for each query, it applies to the query based on session attributes of the `SYS_CONTEXT`. In the case of the preceding example, the predicate returns only those rows where the department number matches the `deptno` attribute of the `SYS_CONTEXT`, which is the department number of the user who is querying the policy-protected database object.
  **Note:**   When using shared static policies, ensure that the policy predicate does not contain attributes that are specific to a particular database object, such as a column name.
### Example: Creating a Static Policy with DBMS_RLS.ADD_POLICY
The `DBMS_RLS.ADD_POLICY` procedure can create a static Oracle Virtual Private Database (VPD) policy.
Example 14-6 shows how to create the `STATIC` policy type.
Example 14-6 Creating a Static Policy with DBMS_RLS.ADD_POLICY
```
BEGIN DBMS_RLS.ADD_POLICY( object_schema   => 'hr', object_name     => 'employees', policy_name     => 'secure_update', policy_function => 'hide_fin', policy_type     => DBMS_RLS.STATIC);
END;
/
```
### Example: Shared Static Policy to Share a Policy with Multiple Objects
The `DBMS_RLS.ADD_POLICY` procedure can create a shared static Oracle Virtual Private Database policy to share the policy with multiple objects.
If, for example, you wanted to apply the static policy that was created earlier to a second table in the `HR` schema that may contain financial data that you want to hide, you could use the `SHARED_STATIC` setting for both tables.
Example 14-7 shows how to set the `SHARED_STATIC` policy type for two tables that share the same policy.
Example 14-7 Creating a Shared Static Policy to Share a Policy with Multiple Objects
```
**--
1. Create a policy for the first table, employees:**
BEGIN DBMS_RLS.ADD_POLICY( object_schema   => 'hr', object_name     => 'employees', policy_name     => 'secure_update', policy_function => 'hide_fin', policy_type     => dbms_rls.SHARED_STATIC);
END;
/ **-- 2. Create a policy for the second table, fin_data:** BEGIN DBMS_RLS.ADD_POLICY( object_schema   => 'hr', object_name     => 'fin_data', policy_name     => 'secure_update', policy_function => 'hide_fin', policy_type     => dbms_rls.SHARED_STATIC);
END;
/
```
### When to Use Static and Shared Static Policies
Static policies are ideal when every query requires the same predicate and fast performance is essential, such as hosting environments.
For these situations when the policy function appends the same predicate to every query, rerunning the policy function each time adds unnecessary overhead to the system. For example, consider a data warehouse that contains market research data for customer organizations that are competitors. The warehouse must enforce the policy that each organization can see only their own market research, which is expressed by the following predicate:
```
WHERE subscriber_id = SYS_CONTEXT('customer', 'cust_num')
```
Using `SYS_CONTEXT` for the application context enables the database to dynamically change the rows that are returned. You do not need to rerun the function, so the predicate can be cached in the SGA, thus conserving system resources and improving performance.
### Context-Sensitive Policy for Application Context Attributes That Change
Context-sensitive policies are useful when different predicates must be applied depending on which predicate executes the query.
For example, consider the case where managers should have the predicate `WHERE group` set to `managers`, and employees should have the predicate `WHERE empno_ctx` set to `emp_id`. A context-sensitive policy will enable you to present only the information that the managers must see when the managers log in, and only the information that the employees must see when they log in. The policy uses application contexts to determine which predicate to use.
In contrast to static policies, context-sensitive policies do not always cache the predicate. With context-sensitive policies, the database assumes that the predicate will change after statement parse time. But if there is no change in the local application context, then Oracle Database does not rerun the policy function within the user session. If there is a change in any attribute of any application context during the user session, then by default the database re-executes the policy function to ensure that it captures all changes to the predicate since the initial parsing. This results in unnecessary re-executions of the policy function if none of the associated attributes have changed. You can restrict the evaluation to a specific application context by including both the `namespace` and `attribute` parameters.
If you plan to use the `namespace` and `attribute` parameters in your policy, then follow these guidelines:
````
- Ensure that you specify both namespace and attribute parameters, not just one.
``````````
- Ensure that your policy has the policy_type argument set to DBMS_RLS.CONTEXT_SENSITIVE or SHARED_CONTEXT_SENSITIVE. You cannot use the namespace and attribute parameters in static or dynamic policies.
If there are no attributes associated with the Virtual Private Database policy function, then Oracle Database evaluates the context-sensitive function for any application context changes.
Shared context-sensitive policies operate in the same way as regular context-sensitive policies, except they can be shared across multiple database objects. For this policy type, all objects can share the policy function from the UGA, where the predicate is cached until the local session context changes.
### Example: Creating a Context-Sensitive Policy with DBMS_RLS.ADD_POLICY
The `DBMS_RLS.ADD_POLICY` procedure can create an Oracle Virtual Private Database context-sensitive policy.
Example 14-8 shows how to create a `CONTEXT_SENSITIVE` policy in which the policy is evaluated only for changes to the `empno_ctx` namespace and `emp_id` attribute.
Example 14-8 Creating a Context-Sensitive Policy with DBMS_RLS.ADD_POLICY
```
BEGIN DBMS_RLS.ADD_POLICY( object_schema   => 'hr', object_name     => 'employees', policy_name     => 'secure_update', policy_function => 'hide_fin', policy_type     => dbms_rls.CONTEXT_SENSITIVE, namespace       => 'empno_ctx', attribute       => 'emp_id');
END;
/
```
### Example: Refreshing Cached Statements for a VPD Context-Sensitive Policy
The DBMS_RLS.REFRESH_POLICY statement can refresh cached statements for Oracle Virtual Private Database context-sensitive policies.
Example 14-9 shows you can manually refresh all the cached statements that are associated with a Virtual Private Database context-sensitive policy by running the `DBMS_RLS.REFRESH_POLICY` procedure.
Example 14-9 Refreshing Cached Statements for a VPD Context-Sensitive Policy
```
BEGIN DBMS_RLS.REFRESH_POLICY( object_schema   => 'hr', object_name     => 'employees', policy_name     => 'secure_update');
END;
/
```
### Example: Altering an Existing Context-Sensitive Policy
The `DBMS_RLS.ALTER_POLICY` procedure can modify an Oracle Virtual Private Database policy.
Example 14-10 shows how you can use the `DBMS_RLS.ALTER_POLICY` statement to alter an existing context-sensitive policy so that the `order_update_pol` policy function is executed only if the relevant context attributes change.
Example 14-10 Altering an Existing Context-Sensitive Policy
```
BEGIN DBMS_RLS.ALTER_POLICY( object_schema   => 'oe', object_name     => 'orders', policy_name     => 'order_update_pol', alter_option    =>  DBMS_RLS.ADD_ATTRIBUTE_ASSOCIATION, namespace       => 'empno_ctx', attribute       => 'emp_role');
END;
/
```
### Example: Using a Shared Context Sensitive Policy to Share a Policy with Multiple Objects
The `DBMS_RLS.ADD_POLICY` procedure can create a shared context-sensitive Oracle Virtual Private Database to share a policy that has multiple objects.
Example 14-11 shows how to create two shared context sensitive policies that share a policy with multiple tables, and how to restrict the evaluation only for changes to the `empno_ctx` namespace and `emp_id` attribute.
Example 14-11 Shared Context-Sensitive Policy with DBMS_RLS.ADD_POLICY
```
**-- 1. Create a policy for the first table, employees:** BEGIN DBMS_RLS.ADD_POLICY( object_schema   => 'hr', object_name     => 'employees', policy_name     => 'secure_update', policy_function => 'hide_fin', policy_type     => dbms_rls.SHARED_CONTEXT_SENSITIVE, namespace       => 'empno_ctx', attribute       => 'emp_id');
END;
/ **--2. Create a policy for the second table, fin_data:** BEGIN DBMS_RLS.ADD_POLICY( object_schema   => 'hr', object_name     => 'fin_data', policy_name     => 'secure_update', policy_function => 'hide_fin', policy_type     => dbms_rls.SHARED_CONTEXT_SENSITIVE, namespace       => 'empno_ctx', attribute       => 'emp_id');
END;
/
```
Note the following:
- When using shared context-sensitive policies, ensure that the policy predicate does not contain attributes that are specific to a particular database object, such as a column name.
- To manually refresh all the cached statements that are associated with a Virtual Private Database shared context-sensitive policy, run the DBMS_RLS.REFRESH_GROUPED_POLICY procedure.
### When to Use Context-Sensitive and Shared Context-Sensitive Policies
Use context-sensitive policies when a predicate does not need to change for a user session, but the policy must enforce multiple predicates for different users or groups.
For example, consider a `sales_history` table with a single policy. This policy states that analysts can see only their own products and regional employees can see only their own region. In this case, the database must rerun the policy function each time the type of user changes. The performance gain is realized when a user can log in and issue several DML statements against the protected object without causing the server to rerun the policy function.
  **Note:**   For session pooling where multiple clients share a database session, the middle tier must reset the context during client switches.
### Summary of the Five Oracle Virtual Private Database Policy Types
Oracle Virtual Private Database provides five policy types, based on user needs such as hosting environments.
The following table summarizes the types of policy types available.

| Policy Types | When the Policy Function Executes | Usage Example | Shared Across Multiple Objects? |
|---|---|---|---|
| DYNAMIC | Policy function re-executes every time a policy-protected database object is accessed. | Applications where policy predicates must be generated for each query, such as time-dependent policies where users are denied access to database objects at certain times during the day | No |
| STATIC | Once, then the predicate is cached in the SGA1 | View replacement | No |
| SHARED_STATIC | Same as STATIC | Hosting environments, such as data warehouses where the same predicate must be applied to multiple database objects | Yes |
| CONTEXT_SENSITIVE | At statement parse time and at statement execution time when the local application context changed since the last use of the cursor | Three-tier, session pooling applications where policies enforce two or more predicates for different users or groups | No |
| SHARED_CONTEXT_SENSITIVE | First time the object is reference in a database session. Predicates are cached in the private session memory UGA so policy functions can be shared among objects. | Same as CONTEXT_SENSITIVE, but multiple objects can share the policy function from the session UGA | Yes |

## Related Topics
  - Components of an Oracle Virtual Private Database Policy
  - Using Application Contexts to Retrieve User Information
  - Auditing Functions, Procedures, Packages, and Triggers
  - Example: Using a Shared Context Sensitive Policy to Share a Policy with Multiple Objects
  - Example: Using a Shared Context Sensitive Policy to Share a Policy with Multiple Objects
  - Tutorial: Implementing a Session-Based Application Context Policy
  - Tutorial: Implementing an Oracle Virtual Private Database Policy Group
````
- Each execution of the same cursor could produce a different row set for the same predicate because the predicate may filter the data differently based on attributes such as SYS_CONTEXT or SYSDATE. ↩
