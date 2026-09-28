# PostgreSQL: Documentation: 18: DROP FUNCTION

PostgreSQL: Documentation: 18: DROP FUNCTION Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 / 15 / 14 Development Versions:
19 / devel Unsupported versions:
13 / 12 / 11 / 10 /
9.6
/
9.5
/
9.4
/
9.3
/
9.2
/
9.1
/
9.0
/
8.4
/
8.3
/
8.2
/
8.1
/
8.0
/
7.4
/
7.3
/
7.2
/
7.1
DROP FUNCTION Prev Up SQL Commands Home Next DROP FUNCTION DROP FUNCTION — remove a function Synopsis DROP FUNCTION [ IF EXISTS ] name [ ( [ [ argmode ] [ argname ] argtype [, ...] ] ) ] [, ...] [ CASCADE | RESTRICT ] Description DROP FUNCTION removes the definition of an existing function. To execute this command the user must be the owner of the function. The argument types to the function must be specified, since several different functions can exist with the same name and different argument lists.
Parameters IF EXISTS Do not throw an error if the function does not exist. A notice is issued in this case.
name The name (optionally schema-qualified) of an existing function. If no argument list is specified, the name must be unique in its schema.
argmode The mode of an argument: IN, OUT, INOUT, or VARIADIC. If omitted, the default is IN. Note that DROP FUNCTION does not actually pay any attention to OUT arguments, since only the input arguments are needed to determine the function's identity. So it is sufficient to list the IN, INOUT, and VARIADIC arguments.
argname The name of an argument. Note that DROP FUNCTION does not actually pay any attention to argument names, since only the argument data types are needed to determine the function's identity.
argtype The data type(s) of the function's arguments (optionally schema-qualified), if any.
CASCADE Automatically drop objects that depend on the function (such as operators or triggers), and in turn all objects that depend on those objects (see Section 5.15).
RESTRICT Refuse to drop the function if any objects depend on it. This is the default.
Examples This command removes the square root function:
DROP FUNCTION sqrt(integer);
Drop multiple functions in one command:
DROP FUNCTION sqrt(integer), sqrt(bigint);
If the function name is unique in its schema, it can be referred to without an argument list:
DROP FUNCTION update_employee_salaries;
Note that this is different from DROP FUNCTION update_employee_salaries();
which refers to a function with zero arguments, whereas the first variant can refer to a function with any number of arguments, including zero, as long as the name is unique.
Compatibility This command conforms to the SQL standard, with these PostgreSQL extensions:
The standard only allows one function to be dropped per command.
The IF EXISTS option The ability to specify argument modes and names See AlsoCREATE FUNCTION, ALTER FUNCTION, DROP PROCEDURE, DROP ROUTINE Prev Up Next DROP FOREIGN TABLE Home DROP GROUP Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
