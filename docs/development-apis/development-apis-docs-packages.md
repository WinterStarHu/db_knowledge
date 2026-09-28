# About Packages

A **package** is a PL/SQL unit that consists of related subprograms and the declared cursors and variables that they use. Typically, you put your subprograms into packages.
Put your subprograms into packages for the following reasons:
- Packages allow you to hide implementation details from client programs. Hiding implementation details from client programs is a widely accepted best practice. Many Oracle customers follow this practice strictly, allowing client programs to access the database only by invoking PL/SQL subprograms. Some customers allow client programs to use SELECT statements to retrieve information from database tables, but require them to invoke PL/SQL subprograms for all business functions that change the database.
********
- Package subprograms must be qualified with package names when invoked from outside the package, which ensures that their names will always work when invoked from outside the package. For example, suppose that you developed a schema-level procedure named CONTINUE before Oracle Database 11g. Oracle Database 11g introduced the CONTINUE statement. Therefore, if you ported your code to Oracle Database 11g, it would no longer compile. However, if you had developed your procedure inside a package, your code would refer to the procedure as package_name.CONTINUE, so the code would still compile.
**Note:**   Oracle Database supplies many PL/SQL packages to extend database functionality and provide PL/SQL access to SQL features. You can use the supplied packages when creating your applications or for ideas in creating your own stored procedures. For information about these packages, see *Oracle Database PL/SQL Packages and Types Reference*.
**See Also:** **
- Oracle Database Concepts for general information about packages
**
- Oracle Database PL/SQL Language Reference for more reasons to use packages
**
- Oracle Database PL/SQL Language Reference for complete information about PL/SQL packages
**
- Oracle Database PL/SQL Packages and Types Reference for complete information about the PL/SQL packages that Oracle provides
