# PostgreSQL: Documentation: 18: SET SESSION AUTHORIZATION

PostgreSQL: Documentation: 18: SET SESSION AUTHORIZATION Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
SET SESSION AUTHORIZATION Prev Up SQL Commands Home Next SET SESSION AUTHORIZATION SET SESSION AUTHORIZATION — set the session user identifier and the current user identifier of the current session Synopsis SET [ SESSION | LOCAL ] SESSION AUTHORIZATION user_name SET [ SESSION | LOCAL ] SESSION AUTHORIZATION DEFAULT RESET SESSION AUTHORIZATION Description This command sets the session user identifier and the current user identifier of the current SQL session to be user_name. The user name can be written as either an identifier or a string literal. Using this command, it is possible, for example, to temporarily become an unprivileged user and later switch back to being a superuser.
The session user identifier is initially set to be the (possibly authenticated) user name provided by the client. The current user identifier is normally equal to the session user identifier, but might change temporarily in the context of SECURITY DEFINER functions and similar mechanisms; it can also be changed by SET ROLE. The current user identifier is relevant for permission checking.
The session user identifier can be changed only if the initial session user (the authenticated user) has the superuser privilege. Otherwise, the command is accepted only if it specifies the authenticated user name.
The SESSION and LOCAL modifiers act the same as for the regular SET command.
The DEFAULT and RESET forms reset the session and current user identifiers to be the originally authenticated user name. These forms can be executed by any user.
Notes SET SESSION AUTHORIZATION cannot be used within a SECURITY DEFINER function.
Examples SELECT SESSION_USER, CURRENT_USER;
session_user | current_user
--------------+--------------
peter        | peter SET SESSION AUTHORIZATION 'paul';
SELECT SESSION_USER, CURRENT_USER;
session_user | current_user
--------------+--------------
paul         | paul Compatibility The SQL standard allows some other expressions to appear in place of the literal user_name, but these options are not important in practice. PostgreSQL allows identifier syntax ("username"), which SQL does not. SQL does not allow this command during a transaction; PostgreSQL does not make this restriction because there is no reason to. The SESSION and LOCAL modifiers are a PostgreSQL extension, as is the RESET syntax.
The privileges necessary to execute this command are left implementation-defined by the standard.
See AlsoSET ROLE Prev Up Next SET ROLE Home SET TRANSACTION Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
