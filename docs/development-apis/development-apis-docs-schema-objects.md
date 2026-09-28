# About Schema Objects

Every object in an Oracle Database belongs to only one schema, and has a unique name with that schema.
Some of the objects that schemas can contain include the following objects:
**** ****************
- Tables Tables are the basic units of data storage in Oracle Database. Tables hold all user-accessible data. Each table contains rows that represent individual data records. Rows are composed of columns that represent the fields of the records.
****
- Indexes Indexes are optional objects that can improve the performance of data retrieval from tables. Indexes are created on one or more columns of a table, and are automatically maintained in the database.
****
- Views You can create a view that combines information from several different tables into a single presentation. A view can rely on information from both tables and other views.
****
- Sequences When all records of a table must be distinct, you can use a sequence to generate a serial list of unique integers for numeric columns, each of which represents the ID of one record.
****
- Synonyms Synonyms are aliases for schema objects. You can use synonyms for security and convenience; for example, to hide the ownership of an object or to simplify SQL statements.
**** **** ****
- Stored subprograms Stored subprograms (also called schema-level subprograms) are procedures and functions that are stored in the database. They can be invoked from client applications that access the database. Triggers are stored subprograms that are automatically run by the database when specified events occur in a particular table or view. Triggers can restrict access to specific data and perform logging.
****
- Packages A package is a group of related subprograms, along with the explicit cursors and variables they use, stored in the database as a unit, for continued use. Like stored subprograms, package subprograms can be invoked from client applications that access the database.
Typically, the objects that an application uses belong to the same schema.
**See Also:** **
- Oracle Database Concepts for a comprehensive introduction to schema objects
- Creating and Managing Tables
- Managing Indexes
- Creating and Managing Views
- Creating and Managing Sequences
- Creating and Managing Synonyms
- Developing Stored Subprograms and Packages
- Using Triggers
