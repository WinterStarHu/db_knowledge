# Database Object Names and Qualifiers

Some database objects are made up of parts that you can or must name, such as the columns in a table or view, index and table partitions and subpartitions, integrity constraints on a table, and objects that are stored within a package, including procedures and stored functions. This section provides:
- Rules for naming database objects and database object location qualifiers
****````
- Guidelines for naming database objects and qualifiers Note: Oracle uses system-generated names beginning with “SYS_” for implicitly generated database objects and subobjects, and names beginning with “ORA_” for some Oracle-supplied objects. Oracle discourages you from using these prefixes in the names you explicitly provide to your database objects and subobjects to avoid possible conflict in name resolution.
## Database Object Naming Rules
Every database object has a name. In a SQL statement, you represent the name of an object with a **quoted identifier** or a **nonquoted identifier**.
- A quoted identifier begins and ends with double quotation marks (“). If you name a schema object using a quoted identifier, then you must use the double quotation marks whenever you refer to that object.
- A nonquoted identifier is not surrounded by any punctuation.
You can use either quoted or nonquoted identifiers to name any database object. However, database names, global database names, database link names, disk group names, and pluggable database (PDB) names are always case insensitive and are stored as uppercase. If you specify such names as quoted identifiers, then the quotation marks are silently ignored.
**See Also:**   CREATE USER for additional rules for naming users and passwords **Note:**   Oracle does not recommend using quoted identifiers for database object names. These quoted identifiers are accepted by SQL*Plus, but they may not be valid when using other tools that manage database objects.
The following list of rules applies to both quoted and nonquoted identifiers unless otherwise indicated:
****
  - Names of databases are limited to 8 bytes.
  - Names of disk groups, pluggable databases (PDBs), rollback segments, tablespaces, and tablespace sets are limited to 30 bytes.
If an identifier includes multiple parts separated by periods, then each attribute can be up to 128 bytes long. Each period separator, as well as any surrounding double quotation marks, counts as one byte. For example, suppose you identify a column like this:
```
"schema"."table"."column"
```
```
  The schema name can be 128 bytes, the table name can be 128 bytes, and the column name can be 128 bytes. Each of the quotation marks and periods is a single-byte character, so the total length of the identifier in this example can be up to 392 bytes.
- **If COMPATIBLE is set to a value lower than 12.2,** then names must be from 1 to 30 bytes long with these exceptions:
  - Names of databases are limited to 8 bytes.
  - Names of database links can be as long as 128 bytes.
  If an identifier includes multiple parts separated by periods, then each attribute can be up to 30 bytes long. Each period separator, as well as any surrounding double quotation marks, counts as one byte. For example, suppose you identify a column like this:
```
```
"schema"."table"."column"
```
```
  The schema name can be 30 bytes, the table name can be 30 bytes, and the column name can be 30 bytes. Each of the quotation marks and periods is a single-byte character, so the total length of the identifier in this example can be up to 98 bytes.
```
****````````
- Nonquoted identifiers cannot be Oracle SQL reserved words. Quoted identifiers can be reserved words, although this is not recommended. Depending on the Oracle product you plan to use to access a database object, names might be further restricted by other product-specific reserved words. Note: The reserved word ROWID is an exception to this rule. You cannot use the uppercase word ROWID, either quoted or nonquoted, as a column name. However, you can use the uppercase word as a quoted identifier that is not a column name, and you can use the word with one or more lowercase letters (for example, “Rowid” or “rowid”) as any quoted identifier, including a column name.
```

```
``````````
````
****
  - Oracle SQL Keywords for information how to obtain a list of keywords
  - Data Types, About SQL Functions, and Selecting from the DUAL Table
- You should use characters from the ASCII repertoire in database names, global database names, and database link names, because these characters provide optimal compatibility across different platforms and operating systems. You must use only characters from the ASCII repertoire in the names of common users, common roles, and common profiles in a multitenant container database (CDB).
- You can include multibyte characters in passwords.
- Nonquoted identifiers must begin with an alphabetic character from your database character set. Quoted identifiers can begin with any character.
- Nonquoted identifiers can only contain alphanumeric characters from your database character set and the underscore (_), dollar sign ($), and pound sign (#). Database links can also contain periods (.) and “at” signs (@). Oracle strongly discourages you from using $ and # in nonquoted identifiers. Quoted identifiers can contain any characters and punctuations marks as well as spaces. However, neither quoted nor nonquoted identifiers can contain double quotation marks or the null character (\0).
  - Within a namespace, no two objects can have the same name. The following schema objects share one namespace: - Packages - Private synonyms - Sequences - Stand-alone procedures - Stand-alone stored functions - Tables - User-defined operators - User-defined types - Views Each of the following schema objects has its own namespace: - Clusters - Constraints - Database triggers - Dimensions - Indexes - Materialized views (When you create a materialized view, the database creates an internal table of the same name. This table has the same namespace as the other tables in the schema. Therefore, a schema cannot contain a table and a materialized view of the same name.) - Private database links Because tables and sequences are in the same namespace, a table and a sequence in the same schema cannot have the same name. However, tables and indexes are in different namespaces. Therefore, a table and an index in the same schema can have the same name. Each schema in the database has its own namespaces for the objects it contains. This means, for example, that two tables in different schemas are in different namespaces and can have the same name. Each of the following nonschema objects also has its own namespace: - Editions - Parameter files (`PFILE`s) and server parameter files (`SPFILE`s) - Profiles - Public database links - Public synonyms - Tablespaces - User roles Because the objects in these namespaces are not contained in schemas, these namespaces span the entire database.
- Nonquoted identifiers are not case sensitive. Oracle interprets them as uppercase. Quoted identifiers are case sensitive. By enclosing names in double quotation marks, you can give the following names to different objects in the same namespace:
```
"employees"
"Employees"
"EMPLOYEES"
```
```
Note that Oracle interprets the following names the same, so they cannot be used for different objects in the same namespace:
```
```
employees
EMPLOYEES
"EMPLOYEES"
```
``````
- When Oracle stores or compares identifiers in uppercase, the uppercase form of each character in the identifiers is determined by applying the uppercasing rules of the database character set. Language-specific rules determined by the session setting NLS_SORT are not considered. This behavior corresponds to applying the SQL function UPPER to the identifier rather than the function NLS_UPPER. The database character set uppercasing rules can yield results that are incorrect when viewed as being in a certain natural language. For example, small letter sharp s (“ß”), used in German, does not have an uppercase form according to the database character set uppercasing rules. It is not modified when an identifier is converted into uppercase, while the expected uppercase form in German is the sequence of two characters capital letter S (“SS”). Similarly, the uppercase form of small letter i, according to the database character set uppercasing rules, is capital letter I. However, the expected uppercase form in Turkish and Azerbaijani is capital letter I with dot above. The database character set uppercasing rules ensure that identifiers are interpreted the same in any linguistic configuration of a session. If you want an identifier to look correctly in a certain natural language, then you can quote it to preserve the lowercase form or you can use the linguistically correct uppercase form whenever you use that identifier.
- Columns in the same table or view cannot have the same name. However, columns in different tables or views can have the same name.
****
- Procedures or functions contained in the same package can have the same name, if their arguments are not of the same number and data types. Creating multiple procedures or functions with the same name in the same package with different arguments is called overloading the procedure or function.
- Tablespace names are case sensitive, unlike other identifiers that are limited to 30 bytes.
## Schema Object Naming Examples
The following examples are valid schema object names:
```
last_name horse hr.hire_date "EVEN THIS & THAT!" a_very_long_and_valid_name
```
All of these examples adhere to the rules listed in Database Object Naming Rules.
## Schema Object Naming Guidelines
Here are several helpful guidelines for naming objects and their parts:
- Use full, descriptive, pronounceable names (or well-known abbreviations).
- Use consistent naming rules.
- Use the same name to describe the same entity or attribute across tables.
When naming objects, balance the objective of keeping names short and easy to use with the objective of making names as descriptive as possible. When in doubt, choose the more descriptive name, because the objects in the database may be used by many people over a period of time. Your counterpart ten years from now may have difficulty understanding a table column with a name like `pmdd` instead of `payment_due_date`.
Using consistent naming rules helps users understand the part that each table plays in your application. One such rule might be to begin the names of all tables belonging to the `FINANCE` application with `fin_`.
Use the same names to describe the same things across tables. For example, the department number columns of the sample `employees` and `departments` tables are both named `department_id`.
