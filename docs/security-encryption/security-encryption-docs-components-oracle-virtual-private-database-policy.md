# Components of an Oracle Virtual Private Database Policy

A VPD policy uses a function to generate the dynamic `WHERE` clause, and a policy to attach the function to objects to protect.
- Function to Generate the Dynamic WHERE Clause The Oracle Virtual Private Database (VPD) function defines the restrictions that you want to enforce.
- Policies to Attach the Function to the Objects You Want to Protect The Oracle Virtual Private Database policy associates the VPD function with a table, view, or synonym.
## Function to Generate the Dynamic WHERE Clause
The Oracle Virtual Private Database (VPD) function defines the restrictions that you want to enforce.
To generate the Oracle Virtual Private Database (VPD) dynamic `WHERE` clause (predicate), you must create a function (not a procedure) that defines these restrictions. This function is a definer’s rights function. Oracle Database generates the predicate with the VPD policy function authorized by the owner but in the same current user session such that the PL/SQL global variables that are defined in the function will be used.
Usually, the security administrator creates this function in their own schema. For more complex behavior, such as including calls to other functions or adding checks to track failed logon attempts, create these functions within a package.
The function must have the following behavior:
****
- It must take as arguments a schema name and an object (table, view, or synonym) name as inputs. Define input parameters to hold this information, but do not specify the schema and object name themselves within the function. The policy that you create to attach the function to the objects that you want to protect, using the DBMS_RLS package, provides the names of the schema, and object to which the policy will apply. You must create the parameter for the schema first, followed by the parameter for the object.
****````
- It must provide a return value for the WHERE clause predicate that will be generated. The return value for the WHERE clause is always a VARCHAR2 data type.
****``````
- It must generate a valid WHERE clause. This code can be as simple in that it applies to every user who logs in the database instance, but in most cases, you may want to design the WHERE clause to be different for each user, each group of users, or each application that accesses the objects you want to protect. For example, if a manager logs in, the WHERE clause can be specific to the rights of that particular manager. You can do this by incorporating an application context, which accesses user session information, into the WHERE clause generation code. You can create Oracle Virtual Private Database functions that do not use an application context, but an application context creates a much stronger Oracle Virtual Private Database policy, by securely basing user access on the session attributes of that user, such as the user ID. In addition, you can embed C or Java calls to access operating system information or to return WHERE clauses from an operating system file or other source.
****
- It must not select from a table within the associated policy function. Although you can define a policy against a table, you cannot select that table from within the policy that was defined against the table.
********
- It must be a pure function. The VPD function must rely only on the application context and the arguments that are passed to the function to generate the WHERE clause. This function must not depend on the package variables. Note: If you plan to run the function across different editions, you can control the results of the function: whether the results are uniform across all editions, or specific to the edition in which the function is run.
## Policies to Attach the Function to the Objects You Want to Protect
The Oracle Virtual Private Database policy associates the VPD function with a table, view, or synonym.
You create the policy by using the `DBMS_RLS` package. If you are not `SYS`, then you must be granted `EXECUTE` privileges to use the `DBMS_RLS` package. This package contains procedures that enable you to manage the policy and set fine-grained access control. For example, to attach the policy to a table, you use the `DBMS_RLS.ADD_POLICY` procedure. Within this setting, you set fine-grained access control, such as setting the policy to go into effect when a user issues a `SELECT` or `UPDATE` statement on the table or view.
The combination of creating the function and then applying it to a table or view is referred to as creating the Oracle Virtual Private Database policy.
## Related Topics
  - Policies to Attach the Function to the Objects You Want to Protect
  - Tutorial: Creating a Simple Oracle Virtual Private Database Policy
  - Tutorial: Implementing a Session-Based Application Context Policy
  - Using Application Contexts to Retrieve User Information
  - How Editions Affects the Results of a Global Application Context PL/SQL Package
  - Configuration of Oracle Virtual Private Database Policies
  - Tutorials: Creating Oracle Virtual Private Database Policies
