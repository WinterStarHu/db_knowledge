# Creating a Password by Using the IDENTIFIED BY Clause

SQL statements that accept the `IDENTIFIED BY` clause also enable you to create passwords.
  ````````- To create passwords for users, use the CREATE USER, ALTER USER, GRANT CREATE SESSION, or CREATE DATABASE LINK SQL statement.
The following SQL statements create passwords with the `IDENTIFIED BY` clause.
```
CREATE USER psmith IDENTIFIED BY password;
GRANT CREATE SESSION TO psmith IDENTIFIED BY password;
ALTER USER psmith IDENTIFIED BY password;
CREATE DATABASE LINK AUTHENTICATED BY psmith IDENTIFIED BY password;
```
## Related Topics
  - About Password Complexity Verification
