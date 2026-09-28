# Using Associative Arrays

An associative array is a type of collection.
**See Also:** For more information about collections:
**
- Oracle Database Concepts
**
- Oracle Database PL/SQL Language Reference
## About Collections
A **collection** is a PL/SQL composite variable that stores elements of the same type in a specified order, similar to a one-dimensional array. The internal components of a collection are called **elements**. Each element has a unique subscript that identifies its position in the collection.
To access a collection element, you use **subscript notation** : collection_name(element_subscript).
You can treat collection elements like scalar variables. You can also pass entire collections as subprogram parameters (if neither the sending nor receiving subprogram is a standalone subprogram).
A **collection method** is a built-in PL/SQL subprogram that either returns information about a collection or operates on a collection. To invoke a collection method, you use **dot notation** : collection_name.method_name. For example, collection_name.COUNT returns the number of elements in the collection.
PL/SQL has three types of collections:
- Associative arrays (formerly called “PL/SQL tables” or “index-by tables”)
- Nested tables
- Variable arrays (varrays)
This document explains only associative arrays.
**See Also:** **
- Oracle Database PL/SQL Language Reference for more information about PL/SQL collection types
**
- Oracle Database PL/SQL Language Reference for more information about collection methods
## About Associative Arrays
An **associative array** is an unbounded set of key-value pairs. Each key is unique, and serves as the subscript of the element that holds the corresponding value. Therefore, you can access elements without knowing their positions in the array, and without traversing the array.
The data type of the key can be either PLS_INTEGER or VARCHAR2 (length).
If the data type of the key is PLS_INTEGER and the associative array is **indexed by integer** and is **dense** (that is, has no gaps between elements), then every element between the first and last element is defined and has a value (which can be NULL).
If the key type is VARCHAR2 (length), the associative array is **indexed by string** (of length characters) and is **sparse** ; that is, it might have gaps between elements.
When traversing a dense associative array, you need not beware of gaps between elements; when traversing a sparse associative array, you do.
To assign a value to an associative array element, you can use an assignment operator:
```
array_name(key) := value
```
If key is not in the array, then the assignment statement adds the key-value pair to the array. Otherwise, the statement changes the value of array_name(key) to value.
Associative arrays are useful for storing data temporarily. They do not use the disk space or network operations that tables require. However, because associative arrays are intended for temporary storage, you cannot manipulate them with DML statements.
If you declare an associative array in a package and assign values to the variable in the package body, then the associative array exists for the life of the database session. Otherwise, it exists for the life of the subprogram in which you declare it.
**See Also:**   *Oracle Database PL/SQL Language Reference* for more information about associative arrays
## Declaring Associative Arrays
To declare an associative array, you declare an associative array type and then declare a variable of that type.
The following code shows the simplest syntax:
```
TYPE array_type IS TABLE OF element_type INDEX BY key_type;
array_name  array_type;
```
An efficient way to declare an associative array is with a cursor, using the following procedure. The procedure uses each necessary statement in its simplest form, but provides references to its complete syntax.
**To use a cursor to declare an associative array:**
```
 CURSOR cursor_name IS query;
```
**
  - Declare the cursor: For complete declared cursor declaration syntax, see Oracle Database PL/SQL Language Reference.
```
 TYPE array_type IS TABLE OF cursor_name%ROWTYPE
   INDEX BY { PLS_INTEGER | VARCHAR2 length }
```
**
  - Declare the associative array type: For complete associative array type declaration syntax, see Oracle Database PL/SQL Language Reference.
```
 array_name  array_type;
```
**
  - Declare an associative array variable of that type: For complete variable declaration syntax, see Oracle Database PL/SQL Language Reference.
Example 5-9 uses the preceding procedure to declare two associative arrays, employees_jobs and jobs_, and then declares a third associative array, job_titles, without using a cursor. The first two arrays are indexed by integer; the third is indexed by string.
**Note:**   The ORDER BY clause in the declaration of employees_jobs_cursor determines the storage order of the elements of the associative array employee_jobs.
**Example 5-9 Declaring Associative Arrays**
```
DECLARE
  -- Declare cursor:
  CURSOR employees_jobs_cursor IS
    SELECT FIRST_NAME, LAST_NAME, JOB_ID
    FROM EMPLOYEES
    ORDER BY JOB_ID, LAST_NAME, FIRST_NAME;
  -- Declare associative array type:
  TYPE employees_jobs_type IS TABLE OF employees_jobs_cursor%ROWTYPE
    INDEX BY PLS_INTEGER;
  -- Declare associative array:
  employees_jobs  employees_jobs_type;
  -- Use same procedure to declare another associative array:
  CURSOR jobs_cursor IS
    SELECT JOB_ID, JOB_TITLE
    FROM JOBS;
  TYPE jobs_type IS TABLE OF jobs_cursor%ROWTYPE
    INDEX BY PLS_INTEGER;
  jobs_  jobs_type;
-- Declare associative array without using cursor:
  TYPE job_titles_type IS TABLE OF JOBS.JOB_TITLE%TYPE
    INDEX BY JOBS.JOB_ID%TYPE;  -- jobs.job_id%type is varchar2(10)
  job_titles  job_titles_type;
BEGIN
  NULL;
END;
/
```
**See Also:**
- “About Cursors”
**
- Oracle Database PL/SQL Language Reference for associative array declaration syntax
## Populating Associative Arrays
The most efficient way to populate a dense associative array is usually with a SELECT statement with a BULK COLLECT INTO clause.
**Note:**   If a dense associative array is so large that a SELECT statement would a return a result set too large to fit in memory, then do not use a SELECT statement. Instead, populate the array with a cursor and the FETCH statement with the clauses BULK COLLECT INTO and LIMIT. For information about using the FETCH statement with BULK COLLECT INTO clause, see *Oracle Database PL/SQL Language Reference*.
You cannot use a SELECT statement to populate a sparse associative array (such as job_titles in “Declaring Associative Arrays”). Instead, you must use an assignment statement inside a loop statement. For information about loop statements, see “Controlling Program Flow”.
Example 5-10 uses SELECT statements to populate the associative arrays employees_jobs and jobs_, which are indexed by integer. Then it uses an assignment statement inside a FOR LOOP statement to populate the associative array job_titles, which is indexed by string.
**Example 5-10 Populating Associative Arrays**
```
-- Declarative part from Example 5-9 goes here.
BEGIN
  -- Populate associative arrays indexed by integer:
SELECT FIRST_NAME, LAST_NAME, JOB_ID BULK COLLECT INTO employees_jobs
  FROM EMPLOYEES ORDER BY JOB_ID, LAST_NAME, FIRST_NAME;
SELECT JOB_ID, JOB_TITLE BULK COLLECT INTO jobs_ FROM JOBS;
  -- Populate associative array indexed by string:
  FOR i IN 1..jobs_.COUNT() LOOP
    job_titles(jobs_(i).job_id) := jobs_(i).job_title;
  END LOOP;
END;
/
```
**See Also:**   “About Cursors”
## Traversing Dense Associative Arrays
A **dense associative array** (indexed by integer) has no gaps between elements-every element between the first and last element is defined and has a value (which can be NULL).
You can traverse a dense array with a FOR LOOP statement, as in Example 5-11.
When inserted in the executable part of Example 5-10, after the code that populates the employees_jobs array, the FOR LOOP statement in Example 5-11 prints the elements of the employees_jobs array in the order in which they were stored. Their storage order was determined by the ORDER BY clause in the declaration of employees_jobs_cursor, which was used to declare employees_jobs (see Example 5-9).
The upper bound of the FOR LOOP statement, employees_jobs.COUNT, invokes a collection method that returns the number of elements in the array. For more information about COUNT, see *Oracle Database PL/SQL Language Reference*.
**Example 5-11 Traversing a Dense Associative Array**
```
-- Code that populates employees_jobs must precede this code:
FOR i IN 1..employees_jobs.COUNT LOOP
  DBMS_OUTPUT.PUT_LINE(
    RPAD(employees_jobs(i).first_name, 23) ||
    RPAD(employees_jobs(i).last_name,  28) ||     employees_jobs(i).job_id);
  END LOOP;
```
Result:
```
William                Gietz                       AC_ACCOUNT
Shelley                Higgins                     AC_MGR
Jennifer               Whalen                      AD_ASST
Steven                 King                        AD_PRES
Lex                    De Haan                     AD_VP
Neena                  Kochhar                     AD_VP
John                   Chen                        FI_ACCOUNT
...
Jose Manuel            Urman                       FI_ACCOUNT
Nancy                  Greenberg                   FI_MGR
Susan                  Mavris                      HR_REP
David                  Austin                      IT_PROG
...
Valli                  Pataballa                   IT_PROG
Michael                Hartstein                   MK_MAN
Pat                    Fay                         MK_REP
Hermann                Baer                        PR_REP
Shelli                 Baida                       PU_CLERK
...
Sigal                  Tobias                      PU_CLERK
Den                    Raphaely                    PU_MAN
Gerald                 Cambrault                   SA_MAN
...
Eleni                  Zlotkey                     SA_MAN
Ellen                  Abel                        SA_REP
...
Clara                  Vishney                     SA_REP
Sarah                  Bell                        SH_CLERK
...
Peter                  Vargas                      ST_CLERK
Adam                   Fripp                       ST_MAN
...
Matthew                Weiss                       ST_MAN
```
## Traversing Sparse Associative Arrays
A **sparse associative array** (indexed by string) might have gaps between elements.
You can traverse it with a WHILE LOOP statement, as in Example 5-12.
To run the code in Example 5-12, which prints the elements of the job_titles array, complete the following steps:
```
 i jobs.job_id%TYPE;
```
- At the end of the declarative part of Example 5-9, insert this variable declaration:
- In the executable part of Example 5-10, after the code that populates the job_titles array, insert the code from Example 5-12.
**Example 5-12 Traversing a Sparse Associative Array**
```
/* Declare this variable in declarative part:
   i jobs.job_id%TYPE;
   Add this code to the executable part,
   after code that populates job_titles:
*/
i := job_titles.FIRST;
WHILE i IS NOT NULL LOOP
  DBMS_OUTPUT.PUT_LINE(RPAD(i, 12) || job_titles(i));
  i := job_titles.NEXT(i);
END LOOP;
```
Result:
```
AC_ACCOUNT  Public Accountant
AC_MGR      Accounting Manager
AD_ASST     Administration Assistant
AD_PRES     President
AD_VP       Administration Vice President
FI_ACCOUNT  Accountant
FI_MGR      Finance Manager
HR_REP      Human Resources Representative
IT_PROG     Programmer
MK_MAN      Marketing Manager
MK_REP      Marketing Representative
PR_REP      Public Relations Representative
PU_CLERK    Purchasing Clerk
PU_MAN      Purchasing Manager
SA_MAN      Sales Manager
SA_REP      Sales Representative
SH_CLERK    Shipping Clerk
ST_CLERK    Stock Clerk
ST_MAN      Stock Manager
```
Example 5-12 includes two collection method invocations, job_titles.FIRST and job_titles.NEXT(i). job_titles.FIRST returns the first element of job_titles, and job_titles.NEXT(i) returns the subscript that succeeds `i`. For more information about FIRST, see *Oracle Database PL/SQL Language Reference*. For more information about NEXT, see *Oracle Database PL/SQL Language Reference*.
