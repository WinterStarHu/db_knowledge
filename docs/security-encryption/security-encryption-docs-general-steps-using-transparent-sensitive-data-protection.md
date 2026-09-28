# General Steps for Using Transparent Sensitive Data Protection

To use TSDP with Oracle Data Redaction, you must follow a set of general steps.
````
- Create a sensitive type to classify the types of columns that you want to protect. For example, you can create a sensitive type for classify all Social Security numbers or credit card numbers. To create the sensitive type, either use the DBMS_TSDP_MANAGE.ADD_SENSITIVE_TYPE PL/SQL procedure or use an Enterprise Manager Cloud Control Application Data Model. To add multiple sensitive types in one operation from an Application Data Model, you can use the DBMS_TSDP_MANAGE.IMPORT_SENSITIVE_TYPES procedure.
  - The DBMS_TSDP_MANAGE.ADD_SENSITIVE_COLUMN procedure individually identifies sensitive columns.
  - An Oracle Enterprise Manager Cloud Control Application Data Model enables you to identify a group of sensitive columns. It then prepares this list of sensitive columns in XML format, which you then import into your database.
- If you used an Application Data Model for Step 2, then import the list of sensitive columns from the Application Data Model into your database by using the DBMS_TSDP_MANAGE.IMPORT_DISCOVERY_RESULT procedure.
- Create the TSDP policy by using the DBMS_TSDP_PROTECT.ADD_POLICY procedure within an anonymous block that defines the Data Redaction or Virtual Private Database settings that you want to use.
- Associate the TSDP policy with one or more sensitive types by using the DBMS_TSDP_PROTECT.ASSOCIATE_POLICY procedure.
``````
- Enable the TSDP policy protections by using the DBMS_TSDP_PROTECT.ENABLE_PROTECTION_SOURCE, DBMS_TSDP_PROTECT.ENABLE_PROTECTION_COLUMN, or the DBMS_TSDP_PROTECT.ENABLE_PROTECTION_TYPE procedure.
- Optionally, export the TSDP policy to other databases by using Oracle Data Pump to perform a full database export. (You cannot individually export TSDP policies.)
