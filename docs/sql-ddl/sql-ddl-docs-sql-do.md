# PostgreSQL: Documentation: 18: DO

PostgreSQL: Documentation: 18: DO Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
DO Prev Up SQL Commands Home Next DO DO — execute an anonymous code block Synopsis DO [ LANGUAGE lang_name ] code Description DO executes an anonymous code block, or in other words a transient anonymous function in a procedural language.
The code block is treated as though it were the body of a function with no parameters, returning void. It is parsed and executed a single time.
The optional LANGUAGE clause can be written either before or after the code block.
Parameters code The procedural language code to be executed. This must be specified as a string literal, just as in CREATE FUNCTION. Use of a dollar-quoted literal is recommended.
lang_name The name of the procedural language the code is written in. If omitted, the default is plpgsql.
Notes The procedural language to be used must already have been installed into the current database by means of CREATE EXTENSION. plpgsql is installed by default, but other languages are not.
The user must have USAGE privilege for the procedural language, or must be a superuser if the language is untrusted. This is the same privilege requirement as for creating a function in the language.
If DO is executed in a transaction block, then the procedure code cannot execute transaction control statements. Transaction control statements are only allowed if DO is executed in its own transaction.
Examples Grant all privileges on all views in schema public to role webuser:
DO $$DECLARE r record;
BEGIN FOR r IN SELECT table_schema, table_name FROM information_schema.tables WHERE table_type = 'VIEW' AND table_schema = 'public' LOOP EXECUTE 'GRANT ALL ON ' || quote_ident(r.table_schema) || '.' || quote_ident(r.table_name) || ' TO webuser';
END LOOP;
END$$;
Compatibility There is no DO statement in the SQL standard.
See AlsoCREATE LANGUAGE Prev Up Next DISCARD Home DROP ACCESS METHOD Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
