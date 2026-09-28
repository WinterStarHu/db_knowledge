# About Stored Subprograms

A **stored subprogram** is a subprogram that is stored in the database. Because they are stored in the database, stored programs can be used as building blocks for many different database applications.
A **subprogram** is a PL/SQL unit that consists of SQL and PL/SQL statements that solve a specific problem or perform a set of related tasks. A subprogram can have parameters, whose values are supplied by the invoker. A subprogram can be either a procedure or a function. Typically, you use a procedure to perform an action and a function to compute and return a value.
Because stored subprograms are stored in the database, stored programs can be used as building blocks for many different database applications. A subprogram that is declared within another subprogram, or within an anonymous block, is called a **nested subprogram** or **local subprogram**. It cannot be invoked from outside the subprogram or block in which it is declared. An **anonymous block** is a block that is not stored in the database.
There are two kinds of stored subprograms.
****
- Standalone subprograms are created at schema level.
****
- Package subprograms are created inside a package.
Standalone subprograms are useful for testing pieces of program logic, but when you are sure that they work as intended, put them into packages.
**See Also:** **
- Oracle Database Concepts for general information about stored subprograms
**
- Oracle Database PL/SQL Language Reference for complete information about PL/SQL subprograms
