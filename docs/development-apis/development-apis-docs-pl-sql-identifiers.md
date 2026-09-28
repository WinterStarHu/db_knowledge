# About PL/SQL Identifiers

Every PL/SQL subprogram, package, parameter, variable, constant, exception, and declared cursor has a name, which is a PL/SQL identifier.
The minimum length of an identifier is one character; the maximum length is 30 characters. The first character must be a letter, but each later character can be either a letter, numeral, dollar sign ($), underscore (_), or number sign (#). For example, these are acceptable identifiers:
```
X
t2
phone#
credit_limit
LastName
oracle$number
money$$$tree
SN##
try_again_
```
PL/SQL is not case-sensitive for identifiers. For example, PL/SQL considers these to be the same:
```
lastname
LastName
LASTNAME
```
You cannot use a PL/SQL reserved word as an identifier. You can use a PL/SQL keyword as an identifier, but it is not recommended. For lists of PL/SQL reserved words and keywords, see *Oracle Database PL/SQL Language Reference*.
**See Also:** **
- Oracle Database PL/SQL Language Reference for additional general information about PL/SQL identifiers
**
- Oracle Database PL/SQL Language Reference for additional information about PL/SQL naming conventions
**
- Oracle Database PL/SQL Language Reference for information about the scope and visibility of PL/SQL identifiers
**
- Oracle Database PL/SQL Language Reference for information how to collect data on PL/SQL identifiers
**
- Oracle Database PL/SQL Language Reference for information about how PL/SQL resolves identifier names
