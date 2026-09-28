# Purge CLI Records in Databases Upgraded from Oracle Database 12.1 or Earlier

In Oracle Database 12c release 12.1, the unified audit records used to reside in the common logging infrastructure (CLI) SGA back-end tables.
There is one CLI back-end table per GUID of the container and the correct GUID needs to be passed to purge audit records present in CLI table. When a pluggable database gets cloned, the unified audit tables get newly created in the new pluggable database with new GUID.
If the `container_guid` parameter is not passed during execution of the `CLEAN_AUDIT_TRAIL` procedure then the current GUID of the container will be used for purging and when the current GUID of the container is different from the old GUID, audit records do not get deleted from the CLI table.
To purge CLI records successfully in databases upgraded from Oracle Database release 12.1 or earlier: 1. Get GUIDs of CLI table by running the following command:
```
SQL&gt; SELECT DISTINCT guid FROM sys.cli_tab$;
If this command doesn't return any rows then you can skip the next step as there are no CLI tables in database.
```
  - Execute the CLEAN_AUDIT_TRAIL Procedure by passing each of these GUIDs one by one along with other parameters to ensure that you purge the unified audit records from these CLI back-end tables.
