# CALL

## Purpose
Use the `CALL` statement to execute a **routine** (a standalone procedure or function, or a procedure or function defined within a type or package) from within SQL.
**Note:**   The restrictions on user-defined function expressions specified in “Function Expressions” apply to the `CALL` statement as well.
**See Also:**   *Oracle Database PL/SQL Language Reference* for information on creating such routine
## Prerequisites
You must have `EXECUTE` privilege on the standalone routine or on the type or package in which the routine is defined.
## Syntax
## *call*::=
Description of the illustration call.eps
## *routine_clause*::=
Description of the illustration routine_clause.eps
## *object_access_expression*::=
Description of the illustration object_access_expression.eps
## Semantics
You can execute a routine in two ways. You can issue a call to the routine itself by name, by using the *routine_clause*, or you can invoke a routine inside the type of an expression, by using an *object_access_expression*.
## *routine_clause*
Specify the name of the function or procedure being called, or a synonym that resolves to a function or procedure.
When you call a member function or procedure of a type, if the first argument (`SELF`) is a null `IN` `OUT` argument, then Oracle Database returns an error. If `SELF` is a null `IN` argument, then the database returns null. In both cases, the function or procedure is not invoked.
**Restriction on Functions** If the routine is a function, then the `INTO` clause is required.
***schema*** Specify the schema in which the standalone routine, or the package or type containing the routine, resides. If you do not specify *schema*, then Oracle Database assumes the routine is in your own schema.
***type*** **or** ***package*** Specify the type or package in which the routine is defined.
***@dblink*** In a distributed database system, specify the name of the database containing the standalone routine, or the package or function containing the routine. If you omit *dblink*, then Oracle Database looks in your local database.
**See Also:**   “Calling a Procedure: Example” for an example of calling a routine directly
## *object_access_expression*
If you have an expression of an object type, such as a type constructor or a bind variable, then you can use this form of expression to call a routine defined within the type. In this context, the *object_access_expression* is limited to method invocations.
**See Also:**   “Object Access Expressions” for syntax and semantics of this form of expression, and “Calling a Procedure Using an Expression of an Object Type: Example” for an example of calling a routine using an expression of an object type
## *argument*
Specify one or more arguments to the routine, if the routine takes arguments. You can use positional, named, or mixed notation for *argument*. For example, all of the following notations are correct:
```
CALL my_procedure(arg1 => 3, arg2 => 4)
```
```
CALL my_procedure(3, 4)
CALL my_procedure(3, arg2 => 4)
```
**Restrictions on Applying Arguments to Routines** The *argument* is subject to the following restrictions:
````
- The data types of the parameters passed by the CALL statement must be SQL data types. They cannot be PL/SQL-only data types such as BOOLEAN.
**````
- An argument cannot be a pseudocolumn or either of the object reference functions VALUE or REF.
**``````
- Any argument that is an IN OUT or OUT argument of the routine must correspond to a host variable expression.
- The number of arguments, including any return argument, is limited to 1000.
``````````````
- You cannot bind arguments of character and raw data types (CHAR, VARCHAR2, NCHAR, NVARCHAR2, RAW, LONG RAW) that are larger than 4K.
## INTO :*host_variable*
The `INTO` clause applies only to calls to functions. Specify which host variable will store the return value of the function.
## :*indicator_variable*
Specify the value or condition of the host variable.
**See Also:**   *Pro*C/C++ Programmer’s Guide*for more information on host variables and indicator variables
## Examples
**Calling a Procedure: Example** The following statement removes the Entertainment department (created in “Inserting Sequence Values: Example”) using uses the `remove_dept` procedure. See *Oracle Database PL/SQL Language Reference* for the example that creates this procedure.
```
CALL emp_mgmt.remove_dept(162);
```
**Calling a Procedure Using an Expression of an Object Type: Example** The following examples show how call a procedure by using an expression of an object type in the `CALL` statement. The example uses the `warehouse_typ` object type in the order entry sample schema `OE`:
```
ALTER TYPE warehouse_typ
      ADD MEMBER FUNCTION ret_name
      RETURN VARCHAR2
      CASCADE;
CREATE OR REPLACE TYPE BODY warehouse_typ
      AS MEMBER FUNCTION ret_name
      RETURN VARCHAR2
      IS
         BEGIN
            RETURN self.warehouse_name;
         END;
      END;
/
VARIABLE x VARCHAR2(25);
CALL warehouse_typ(456, 'Warehouse 456', 2236).ret_name()
   INTO :x;
PRINT x;
X
--------------------------------
Warehouse 456
```
The next example shows how to use an external function to achieve the same thing:
```
CREATE OR REPLACE FUNCTION ret_warehouse_typ(x warehouse_typ)
  RETURN warehouse_typ
  IS
    BEGIN
      RETURN x;
    END;
/
CALL ret_warehouse_typ(warehouse_typ(234, 'Warehouse 234',
   2235)).ret_name()
   INTO :x;
PRINT x;
X
--------------------------------
Warehouse 234
```
