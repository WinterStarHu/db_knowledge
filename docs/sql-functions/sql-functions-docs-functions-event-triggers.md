# PostgreSQL: Documentation: 18: 9.30. Event Trigger Functions

PostgreSQL: Documentation: 18: 9.30. Event Trigger Functions Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
9.30. Event Trigger Functions
Prev Up Chapter 9. Functions and Operators Home Next
9.30. Event Trigger Functions #
9.30.1. Capturing Changes at Command End
9.30.2. Processing Objects Dropped by a DDL Command
9.30.3. Handling a Table Rewrite Event
PostgreSQL provides these helper functions to retrieve information from event triggers.
For more information about event triggers, see Chapter 38.
9.30.1. Capturing Changes at Command End #
pg_event_trigger_ddl_commands () → setof record pg_event_trigger_ddl_commands returns a list of DDL commands executed by each user action, when invoked in a function attached to a ddl_command_end event trigger. If called in any other context, an error is raised. pg_event_trigger_ddl_commands returns one row for each base command executed; some commands that are a single SQL sentence may return more than one row. This function returns the following columns:
Name Type Description classid oid OID of catalog the object belongs in objid oid OID of the object itself objsubid integer Sub-object ID (e.g., attribute number for a column) command_tag text Command tag object_type text Type of the object schema_name text Name of the schema the object belongs in, if any; otherwise NULL. No quoting is applied.
object_identity text Text rendering of the object identity, schema-qualified. Each identifier included in the identity is quoted if necessary.
in_extension boolean True if the command is part of an extension script command pg_ddl_command A complete representation of the command, in internal format. This cannot be output directly, but it can be passed to other functions to obtain different pieces of information about the command.
9.30.2. Processing Objects Dropped by a DDL Command #
pg_event_trigger_dropped_objects () → setof record pg_event_trigger_dropped_objects returns a list of all objects dropped by the command in whose sql_drop event it is called. If called in any other context, an error is raised. This function returns the following columns:
Name Type Description classid oid OID of catalog the object belonged in objid oid OID of the object itself objsubid integer Sub-object ID (e.g., attribute number for a column) original boolean True if this was one of the root object(s) of the deletion normal boolean True if there was a normal dependency relationship in the dependency graph leading to this object is_temporary boolean True if this was a temporary object object_type text Type of the object schema_name text Name of the schema the object belonged in, if any; otherwise NULL. No quoting is applied.
object_name text Name of the object, if the combination of schema and name can be used as a unique identifier for the object; otherwise NULL. No quoting is applied, and name is never schema-qualified.
object_identity text Text rendering of the object identity, schema-qualified. Each identifier included in the identity is quoted if necessary.
address_names text[] An array that, together with object_type and address_args, can be used by the pg_get_object_address function to recreate the object address in a remote server containing an identically named object of the same kind.
address_args text[] Complement for address_names The pg_event_trigger_dropped_objects function can be used in an event trigger like this:
CREATE FUNCTION test_event_trigger_for_drops() RETURNS event_trigger LANGUAGE plpgsql AS $$ DECLARE obj record;
BEGIN FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects() LOOP RAISE NOTICE '% dropped object: % %.% %', tg_tag, obj.object_type, obj.schema_name, obj.object_name, obj.object_identity;
END LOOP;
END;
$$;
CREATE EVENT TRIGGER test_event_trigger_for_drops ON sql_drop EXECUTE FUNCTION test_event_trigger_for_drops();
9.30.3. Handling a Table Rewrite Event #
The functions shown in Table 9.111 provide information about a table for which a table_rewrite event has just been called. If called in any other context, an error is raised.
Table 9.111. Table Rewrite Information Functions Function Description pg_event_trigger_table_rewrite_oid () → oid Returns the OID of the table about to be rewritten.
pg_event_trigger_table_rewrite_reason () → integer Returns a code explaining the reason(s) for rewriting. The value is a bitmap built from the following values: 1 (the table has changed its persistence), 2 (default value of a column has changed), 4 (a column has a new data type) and 8 (the table access method has changed).
These functions can be used in an event trigger like this:
CREATE FUNCTION test_event_trigger_table_rewrite_oid() RETURNS event_trigger LANGUAGE plpgsql AS $$ BEGIN RAISE NOTICE 'rewriting table % for reason %', pg_event_trigger_table_rewrite_oid()::regclass, pg_event_trigger_table_rewrite_reason();
END;
$$;
CREATE EVENT TRIGGER test_table_rewrite_oid ON table_rewrite EXECUTE FUNCTION test_event_trigger_table_rewrite_oid();
Prev Up Next
9.29. Trigger Functions
Home
9.31. Statistics Information Functions
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
