# Creating and Managing Sequences

Sequences are schema objects from which you can generate unique sequential values, which are very useful when you need unique primary keys. Sequences are used through the pseudocolumns CURRVAL and NEXTVAL, which return the current and next values of the sequence, respectively.
After creating a sequence, you must initialize it by using NEXTVAL to get its first value. Only after you initialize a sequence does CURRVAL return its current value.
The HR schema has three sequences: DEPARTMENTS_SEQUENCE, EMPLOYEES_SEQUENCE, and LOCATIONS_SEQUENCE.
**Tip:**   When you plan to use a sequence to populate the primary key of a table, give the sequence a name that reflects this purpose. (This topic uses the naming convention *TABLE_NAME*_SEQUENCE.) **See Also:** **
- Oracle Database Concepts for an overview of sequences
**
- Oracle Database SQL Language Reference for more information about the CURRVAL and NEXTVAL pseudocolumns
**
- Oracle Database Administrator’s Guide for information about managing sequences
- “Editing Installation Scripts that Create Sequences”
- “About Sequences and Concurrency”
## Tutorial: Creating a Sequence
This tutorial shows how to use the Create Database Sequence tool to create a sequence to use to generate primary keys for the EVALUATIONS table.
The EVALUATIONS table was created in Example 4-1.
To create a sequence, use either the SQL Developer tool Create Sequence or the DDL statement CREATE SEQUENCE. The equivalent DDL statement is:
```
CREATE SEQUENCE evaluations_sequence
INCREMENT BY 1
START WITH 1 ORDER;
```
**Steps to create EVALUATIONS_SEQUENCE using the Create Database Sequence tool:** ****
- In the Connections frame, expand hr_conn.
****
- In the list of schema object types, right-click Sequences.
****
- In the list of choices, click New Sequence.
- In the Create Sequence window, in the Name field, type EVALUATIONS_SEQUENCE over the default value “SEQUENCE1”.
****
- If the Properties pane does not show, click the tab Properties.
  - In the field Increment, type 1.
  - In the field Start with, type 1.
  - For the remaining fields, accept the default values.
****
  - Click OK. The sequence EVALUATIONS_SEQUENCE is created. Its name appears under Sequences in the Connections frame.
**See Also:** **
- Oracle SQL Developer User’s Guide for more information about using SQL Developer to create a sequence
**
- Oracle Database SQL Language Reference for information about the CREATE SEQUENCE statement
- “Tutorial: Creating a Trigger that Generates a Primary Key for a Row Before It Is Inserted” to learn how to create a trigger that inserts the primary keys created by EVALUATIONS_SEQUENCE into the EVALUATIONS table
## Dropping Sequences
To drop a sequence, use either the SQL Developer Connections frame and Drop tool, or the DDL statement DROP SEQUENCE.
This statement drops the sequence EVALUATIONS_SEQUENCE:
```
DROP SEQUENCE EVALUATIONS_SEQUENCE;
```
**Caution:**   Do not drop the sequence `EVALUATIONS_SEQUENCE`—you need it for Example 5-3. If you want to practice dropping sequences, create others and then drop them.
**Steps to drop a sequence using the Drop tool:** ****
- In the Connections frame, expand hr_conn.
****
- In the list of schema object types, expand Sequences.
- In the list of sequences, right-click the name of the sequence to drop.
****
- In the list of choices, click Drop.
****
- In the Drop window, click Apply.
****
- In the Confirmation window, click OK.
**See Also:**   *Oracle Database SQL Language Reference* for information about the DROP SEQUENCE statement
