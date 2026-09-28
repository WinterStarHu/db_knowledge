# USER

## Syntax
Description of the illustration user.gif Description of the illustration user.eps
## Purpose
`USER` returns the name of the session user (the user who logged on). This may change during the duration of a database session as Real Application Security sessions are attached or detached. For enterprise users, this function returns the schema. For other users, it returns the database user name. If a Real Application Security session is currently attached to the database session, then it returns user `XS$NULL`.
This function returns a `VARCHAR2` value.
Oracle Database compares values of this function with blank-padded comparison semantics.
In a distributed SQL statement, the `UID` and `USER` functions together identify the user on your local database. You cannot use these functions in the condition of a `CHECK` constraint.
**See Also:** **
- Oracle Database 2 Day + Security Guide for more information on user XS$NULL
**
- in Oracle Database Globalization Support Guide for the collation derivation rules, which define the collation assigned to the character return value of USER
## Examples
The following example returns the session user and the user’s UID:
```
SELECT USER, UID FROM DUAL;
```
