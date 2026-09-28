# About Oracle Virtual Private Database

Oracle Virtual Private Database (VPD) provides important benefits for filtering user access to data.
- What Is Oracle Virtual Private Database? Oracle Virtual Private Database (VPD) creates security policies to control database access at the row and column level.
- Benefits of Using Oracle Virtual Private Database Policies Oracle Virtual Private Database policies provide the important benefits.
- Who Can Create Oracle Virtual Private Database Policies? The DBMS_RLS PL/SQL package enables you to create VPD policies.
- Privileges to Run Oracle Virtual Private Database Policy Functions You should be aware of the correct privileges for running Oracle Virtual Private Database (VPD) policy functions.
- Oracle Virtual Private Database Use with an Application Context You can use application contexts with Oracle Virtual Private Database policies.
- Oracle Virtual Private Database in a Multitenant Environment You can create Virtual Private Database policies in an application root for use throughout any associated application PDBs.
## What Is Oracle Virtual Private Database?
Oracle Virtual Private Database (VPD) creates security policies to control database access at the row and column level.
Starting with Oracle Database 19c, these security technologies in Standard Edition (SE) and Hyperscaler-based deployment environments are supported:
- Oracle Real Application Security (RAS)
- Oracle Virtual Private Database (VPD)
You can configure and use these features in supported cloud and Hyperscaler deployments as part of Oracle Database 19c security.
Oracle recommends that you review the latest licensing and deployment documentation for edition-specific restrictions, feature availability, and cloud service limitations.
Oracle Virtual Private Database adds a dynamic `WHERE` clause to a SQL statement that is issued against the table, view, or synonym to which an Oracle Virtual Private Database security policy was applied.
Oracle Virtual Private Database enforces security, to a fine level of granularity, directly on database tables, views, or synonyms. Because you attach security policies directly to these database objects, and the policies are automatically applied whenever a user accesses data, there is no way to bypass security.
When a user directly or indirectly accesses a table, view, or synonym that is protected with an Oracle Virtual Private Database policy, Oracle Database dynamically modifies the SQL statement of the user. This modification creates a `WHERE` condition (called a predicate) returned by a function implementing the security policy. Oracle Database modifies the statement dynamically, transparently to the user, using any condition that can be expressed in or returned by a function. You can apply Oracle Virtual Private Database policies to `SELECT`, `INSERT`, `UPDATE`, `INDEX`, and `DELETE` statements.
For example, suppose a user performs the following query:
```
SELECT * FROM OE.ORDERS;
```
The Oracle Virtual Private Database policy dynamically appends the statement with a `WHERE` clause. For example:
```
SELECT * FROM OE.ORDERS
 WHERE SALES_REP_ID = 159;
```
In this example, the user can only view orders by Sales Representative 159.
If you want to filter the user based on the session information of that user, such as the ID of the user, then you can create the `WHERE` clause to use an application context. For example:
```
SELECT * FROM OE.ORDERS
 WHERE SALES_REP_ID = SYS_CONTEXT('USERENV','SESSION_USER');
```
Note the following:
- Oracle Database release 12c introduced Real Application Security (RAS) to supersede VPD. Oracle recommends that you use RAS for new projects that require row and column level access controls for their applications.
````
- Oracle Database does not protect tables and views that have VPD policies against the SYS user and against users who have an out-of-the-box database administrator role. The Oracle Database-supplied DBA role has privileges that can alter and remove VPD policies, and hence can access table and view data.
````
- Oracle Virtual Private Database does not support filtering for DDLs, such as TRUNCATE or ALTER TABLE statements.
## Benefits of Using Oracle Virtual Private Database Policies
Oracle Virtual Private Database policies provide the important benefits.
- Security Policies Based on Database Objects Rather Than Applications Oracle Virtual Private Database provides benefits in security, simplicity, and flexibility.
- Control Over How Oracle Database Evaluates Policy Functions Running policy functions multiple times can affect performance.
### Security Policies Based on Database Objects Rather Than Applications
Oracle Virtual Private Database provides benefits in security, simplicity, and flexibility.
Attaching Oracle Virtual Private Database security policies to database tables, views, or synonyms, rather than implementing access controls in all your applications, provides the following benefits:
****
- Security. Associating a policy with a database table, view, or synonym can solve a potentially serious application security problem. Suppose a user is authorized to use an application, and then drawing on the privileges associated with that application, wrongfully modifies the database by using an ad hoc query tool, such as SQL*Plus. By attaching security policies directly to tables, views, or synonyms, fine-grained access control ensures that the same security is in force, no matter how a user accesses the data.
****
- Simplicity. You add the security policy to a table, view, or synonym only once, rather than repeatedly adding it to each of your table-based, view-based, or synonym-based applications.
****``````````````
- Flexibility. You can have one security policy for SELECT statements, another for INSERT statements, and still others for UPDATE and DELETE statements. For example, you might want to enable Human Resources clerks to have SELECT privileges for all employee records in their division, but to update only salaries for those employees in their division whose last names begin with A through F. Furthermore, you can create multiple policies for each table, view, or synonym.
### Control Over How Oracle Database Evaluates Policy Functions
Running policy functions multiple times can affect performance.
You can control the performance of policy functions by configuring how Oracle Database caches the Oracle Virtual Private Database predicates.
The following options are available:
- Evaluate the policy once for each query (static policies).
- Evaluate the policy only when an application context within the policy function changes (context-sensitive policies).
- Evaluate the policy each time it is run (dynamic policies).
## Who Can Create Oracle Virtual Private Database Policies?
The `DBMS_RLS` PL/SQL package enables you to create VPD policies.
Users who have been granted the `EXECUTE` privilege on the `DBMS_RLS` PL/SQL package can create Oracle Virtual Private Database policies. As with all privileges, only grant this privilege to trusted users. You can find the privileges that a user has been granted by querying the DBA_SYS_PRIVS data dictionary view.
## Privileges to Run Oracle Virtual Private Database Policy Functions
You should be aware of the correct privileges for running Oracle Virtual Private Database (VPD) policy functions.
For greater security, the Oracle Virtual Private Database policy function runs as if it had been declared with definer’s rights.
Do not declare it as invoker’s rights because this can confuse yourself and other users who maintain the code.
## Oracle Virtual Private Database Use with an Application Context
You can use application contexts with Oracle Virtual Private Database policies.
When you create an application context, it securely caches user information. Only the designated application package can set the cached environment. It cannot be changed by the user or outside the package. In addition, because the data is cached, performance is increased.
For example, suppose you want to base access to the `ORDERS_TAB` table on the customer ID number. Rather than querying the customer ID number for a logged-in user each time you need it, you could store the number in the application context. Then, the customer number is available in the session when you need it.
Application contexts are especially helpful if your security policy is based on multiple security attributes. For example, if a policy function bases a `WHERE` predicate on four attributes (such as employee number, cost center, position, spending limit), then multiple subqueries must execute to retrieve this information. Instead, if this data is available through an application context, then performance is much faster.
You can use an application context to return the correct security policy, enforced through a predicate. For example, consider an order entry application that enforces the following rules: customers only see their own orders, and clerks see all orders for all customers. These are two different policies. You could define an application context with a `position` attribute, and this attribute could be accessed within the policy function to return the correct predicate, depending on the value of the attribute. Thus, you can enable a user in the `clerk` position to retrieve all orders, but a user in the `customer` position can see only those records associated with that particular user.
To design a fine-grained access control policy that returns a specific predicate for an attribute, you need to access the application context within the function that implements the policy. For example, suppose you want to limit customers to seeing only their own records. The user performs the following query:
```
SELECT * FROM orders_tab
```
Fine-grained access control dynamically modifies this query to include the following `WHERE` predicate:
```
SELECT * FROM orders_tab
  WHERE custno = SYS_CONTEXT ('order_entry', 'cust_num');
```
Continuing with the preceding example, suppose you have 50,000 customers, and you do not want to have a different predicate returned for each customer. Customers all share the same `WHERE` predicate, which prescribes that they can only see their own orders. It is merely their customer numbers that are different.
Using application context, you can return one `WHERE` predicate within a policy function that applies to 50,000 customers. As a result, there is one shared cursor that executes differently for each customer, because the customer number is evaluated at execution time. This value is different for every customer. Use of application context in this case provides optimum performance, and at row-level security.
The `SYS_CONTEXT` function works much like a bind variable; only the `SYS_CONTEXT` arguments are constants.
## Oracle Virtual Private Database in a Multitenant Environment
You can create Virtual Private Database policies in an application root for use throughout any associated application PDBs.
The CDB restriction applies to shared context sensitive policies and views related to Virtual Private Database policies as well. You cannot create a Virtual Private Database policy for an entire multitenant environment.
With regard to application containers, you can create Virtual Private Database policies to protect application common objects by applying the common policy to all PDBs that belong to the application root. In other words, when you install an application in the application root, all the common Virtual Private Database policies that protect the common objects will be applied to and immediately enforced for all PDBs in the application container.
Note the following:
- You can only create the common Virtual Private Database policy and its associated PL/SQL function in the application root and only attach it to application common objects. If the function is not in the same location as the policy, then an error is raised at runtime.
- A Virtual Private Database policy that is applied to common objects is considered a common policy that will be automatically enforced in PDBs that belong to the application container when it accesses the application common objects from application PDBs.
- Application common Virtual Private Database policies can only protect application common objects.
````````````````
- A Virtual Private Database policy that is applied to application common objects in the application root and is applied to all application PDBs is considered a common Virtual Private Database policy. A policy that is applied to a local database table and enforced in one PDB is considered a local Virtual Private Database policy. For example, if policy VPD_P1 is applied to the application common table T1 in the application root, then it is a considered to be a common policy. It will be enforced in each application PDB. If a policy named VPD_P1 is applied to a local table called T1 in PDB1, then it is considered a local policy, which means that it affects only PDB1. If a policy called VPD_P1 is applied to a local table T1 in the application root, then it is still considered a local policy because it affects only the application root. This concept applies to other operations, such as enabling, disabling, and removing Virtual Private Database policies.
- Application common Virtual Private Database policies only protect application common objects, while local Virtual Private Database policies only protect local objects.
- If you are using application contexts, then ensure common database session-based application contexts and common global application context objects are used in the common Virtual Private Database configuration.
- Application container Virtual Private Database policies are stored in the application root. PDBs store only local policies. If you plug a PDB into the application container, then the common policies are not converted to local policies. Instead, Oracle Database loads them from the application root and enforces them in the local PDB when the policies access common objects in the local PDB.
## Related Topics
  - Auditing of Oracle Virtual Private Database Predicates
  - Optimizing Performance by Using Oracle Virtual Private Database Policy Types
  **- Oracle Database PL/SQL Language Reference for detailed information about definer’s rights
  - Using Application Contexts to Retrieve User Information
