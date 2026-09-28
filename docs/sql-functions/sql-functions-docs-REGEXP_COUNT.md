# REGEXP_COUNT

## Syntax
Description of the illustration regexp_count.gif Description of the illustration regexp_count.eps
## Purpose
`REGEXP_COUNT` complements the functionality of the `REGEXP_INSTR` function by returning the number of times a pattern occurs in a source string. The function evaluates strings using characters as defined by the input character set. It returns an integer indicating the number of occurrences of *pattern*. If no match is found, then the function returns 0.
**````````````
- source_char is a character expression that serves as the search value. It is commonly a character column and can be of any of the data types CHAR, VARCHAR2, NCHAR, NVARCHAR2, CLOB, or NCLOB.
**````````******** **````**
- pattern is the regular expression. It is usually a text literal and can be of any of the data types CHAR, VARCHAR2, NCHAR, or NVARCHAR2. It can contain up to 512 bytes. If the data type of pattern is different from the data type of source_char, then Oracle Database converts pattern to the data type of source_char. REGEXP_COUNT ignores subexpression parentheses in pattern. For example, the pattern '(123(45))' is equivalent to '12345'. For a listing of the operators you can specify in pattern, refer to Oracle Regular Expression Support.
********
- position is a positive integer indicating the character of source_char where Oracle should begin the search. The default is 1, meaning that Oracle begins the search at the first character of source_char. After finding the first occurrence of pattern, the database searches for a second occurrence beginning with the first character following the first occurrence.
*match_param* is a character expression of the data type `VARCHAR2` or `CHAR` that lets you change the default matching behavior of the function.
The value of *match_param* can include one or more of the following characters:
- 'i' specifies case-insensitive matching, even if the determined collation of the condition is case-sensitive.
- 'c' specifies case-sensitive and accent-sensitive matching, even if the determined collation of the condition is case-insensitive or accent-insensitive.
- 'n' allows the period (.), which is the match-any-character character, to match the newline character. If you omit this parameter, then the period does not match the newline character.
``````
- 'm' treats the source string as multiple lines. Oracle interprets the caret ( ^) and dollar sign ($) as the start and end, respectively, of any line anywhere in the source string, rather than only at the start or end of the entire source string. If you omit this parameter, then Oracle treats the source string as a single line.
- 'x' ignores whitespace characters. By default, whitespace characters match themselves.
If the value of *match_param* contains multiple contradictory characters, then Oracle uses the last character. For example, if you specify `'ic'`, then Oracle uses case-sensitive and accent-sensitive matching. If the value contains a character other than those shown above, then Oracle returns an error.
If you omit *match_param*, then:
- The default case and accent sensitivity are determined by the determined collation of the REGEXP_COUNT function.
- A period (.) does not match the newline character.
- The source string is treated as a single line.
**See Also:**   in *Oracle Database Globalization Support Guide* for the collation determination rules, which define the collation `REGEXP_COUNT` uses to compare characters from *source_char* with characters from *pattern*
## Examples
The following example shows that subexpressions parentheses in pattern are ignored:
```
SELECT REGEXP_COUNT('123123123123123', '(12)3', 1, 'i') REGEXP_COUNT FROM DUAL;
REGEXP_COUNT
------------
5
```
In the following example, the function begins to evaluate the source string at the third character, so skips over the first occurrence of pattern:
```
SELECT REGEXP_COUNT('123123123123', '123', 3, 'i') COUNT FROM DUAL;
COUNT
----------
3
```
**REGEXP_COUNT simple matching: Examples**
In the following example, `REGEXP_COUNT` validates the supplied string for the given pattern and returns the number of alphabetic letters:
```
select regexp_count('ABC123', '[A-Z]'), regexp_count('A1B2C3', '[A-Z]') from dual;
REGEXP_COUNT('ABC123','[A-Z]') REGEXP_COUNT('A1B2C3','[A-Z]')
------------------------------ ------------------------------
3				    3
```
In the following example, `REGEXP_COUNT` validates the supplied string for the given pattern and returns the number of alphabetic letters followed by a single digit number:
```
select regexp_count('ABC123', '[A-Z][0-9]'), regexp_count('A1B2C3', '[A-Z][0-9]') from dual;
REGEXP_COUNT('ABC123','[A-Z][0-9]') REGEXP_COUNT('A1B2C3','[A-Z][0-9]')
----------------------------------- -----------------------------------
1				      3
```
In the following example, `REGEXP_COUNT` validates the supplied string for the given pattern and returns the number of alphabetic letters followed by a single digit number only at the beginning of the string:
```
select regexp_count('ABC123', '[A-Z][0-9]'), regexp_count('A1B2C3', '[A-Z][0-9]') from dual;
REGEXP_COUNT('ABC123','^[A-Z][0-9]') REGEXP_COUNT('A1B2C3','^[A-Z][0-9]')
------------------------------------ ------------------------------------
0					1
```
In the following example, `REGEXP_COUNT` validates the supplied string for the given pattern and returns the number of alphabetic letters followed by two digits of number only contained within the string:
```
select regexp_count('ABC123', '[A-Z][0-9]{2}'), regexp_count('A1B2C3', '[A-Z][0-9]{2}') from dual;
REGEXP_COUNT('ABC123','[A-Z][0-9]{2}') REGEXP_COUNT('A1B2C3','[A-Z][0-9]{2}')
-------------------------------------- --------------------------------------
1					    0
```
In the following example, `REGEXP_COUNT` validates the supplied string for the given pattern and returns the number of alphabetic letters followed by a single digit number within the first two occurrences from the beginning of the string:
```
select regexp_count('ABC123', '([A-Z][0-9]){2}'), regexp_count('A1B2C3', '([A-Z][0-9]){2}') from dual;
REGEXP_COUNT('ABC123','([A-Z][0-9]){2}') REGEXP_COUNT('A1B2C3','([A-Z][0-9]){2}')
---------------------------------------- ----------------------------------------
0                                        1
```
**Div:**
Live SQL:
View and run related examples on Oracle Live SQL at *REGEXP_COUNT simple matching*
**REGEXP_COUNT advanced matching: Examples**
In the following example, `REGEXP_COUNT` validates the supplied string for the given pattern and returns the number of alphabetic letters:
```
select regexp_count('ABC123', '[A-Z]') Match_char_ABC_count, regexp_count('A1B2C3', '[A-Z]') Match_char_ABC_count from dual;
MATCH_CHAR_ABC_COUNT MATCH_CHAR_ABC_COUNT
-------------------- --------------------
3			3
```
In the following example, `REGEXP_COUNT` validates the supplied string for the given pattern and returns the number of alphabetic letters followed by a single digit number:
```
select regexp_count('ABC123', '[A-Z][0-9]') Match_string_C1_count, regexp_count('A1B2C3', '[A-Z][0-9]')  Match_strings_A1_B2_C3_count from dual;
MATCH_STRING_C1_COUNT MATCH_STRINGS_A1_B2_C3_COUNT
--------------------- ----------------------------
1				 3
```
In the following example, `REGEXP_COUNT` validates the supplied string for the given pattern and returns the number of alphabetic letters followed by a single digit number only at the beginning of the string:
```
select regexp_count('ABC123A5', '^[A-Z][0-9]') Char_num_like_A1_at_start, regexp_count('A1B2C3', '^[A-Z][0-9]') Char_num_like_A1_at_start from dual;
CHAR_NUM_LIKE_A1_AT_START CHAR_NUM_LIKE_A1_AT_START
------------------------- -------------------------
0			  1
```
In the following example, `REGEXP_COUNT` validates the supplied string for the given pattern and returns the number of alphabetic letters followed by two digits of number only contained within the string:
```
select regexp_count('ABC123', '[A-Z][0-9]{2}') Char_num_like_A12_anywhere, regexp_count('A1B2C34', '[A-Z][0-9]{2}') Char_num_like_A12_anywhere from dual;
CHAR_NUM_LIKE_A12_ANYWHERE CHAR_NUM_LIKE_A12_ANYWHERE
-------------------------- --------------------------
1			    1
```
In the following example, `REGEXP_COUNT` validates the supplied string for the given pattern and returns the number of alphabetic letters followed by a single digit number within the first two occurrences from the beginning of the string:
```
select regexp_count('ABC12D3', '([A-Z][0-9]){2}') Char_num_within_2_places, regexp_count('A1B2C3', '([A-Z][0-9]){2}') Char_num_within_2_places from dual;
CHAR_NUM_WITHIN_2_PLACES CHAR_NUM_WITHIN_2_PLACES
------------------------ ------------------------
0			1
```
**Div:**
Live SQL:
View and run related examples on Oracle Live SQL at *REGEXP_COUNT advanced matching*
**REGEXP_COUNT case-sensitive matching: Examples**
The following statements create a table regexp_temp and insert values into it:
```
CREATE TABLE regexp_temp(empName varchar2(20));
INSERT INTO regexp_temp (empName) VALUES ('John Doe');
INSERT INTO regexp_temp (empName) VALUES ('Jane Doe');
```
In the following example, the statement queries the employee name column and searches for the lowercase of character ‘E’:
```
SELECT empName, REGEXP_COUNT(empName, 'e', 1, 'c') "CASE_SENSITIVE_E" From regexp_temp;
EMPNAME 	     CASE_SENSITIVE_E
-------------------- ----------------
John Doe			    1 Jane Doe			    2
```
In the following example, the statement queries the employee name column and searches for the lowercase of character ‘O’:
```
SELECT empName, REGEXP_COUNT(empName, 'o', 1, 'c') "CASE_SENSITIVE_O" From regexp_temp;
EMPNAME 	     CASE_SENSITIVE_O
-------------------- ----------------
John Doe			    2 Jane Doe			    1
```
In the following example, the statement queries the employee name column and searches for the lowercase or uppercase of character ‘E’:
```
SELECT empName, REGEXP_COUNT(empName, 'E', 1, 'i') "CASE_INSENSITIVE_E" From regexp_temp;
EMPNAME 	     CASE_INSENSITIVE_E
-------------------- ------------------
John Doe			      1 Jane Doe			      2
```
In the following example, the statement queries the employee name column and searches for the lowercase of string ‘DO’:
```
SELECT empName, REGEXP_COUNT(empName, 'do', 1, 'i') "CASE_INSENSITIVE_STRING" From regexp_temp;
EMPNAME 	     CASE_INSENSITIVE_STRING
-------------------- -----------------------
John Doe				   1 Jane Doe				   1
```
In the following example, the statement queries the employee name column and searches for the lowercase or uppercase of string ‘AN’:
```
SELECT empName, REGEXP_COUNT(empName, 'an', 1, 'c') "CASE_SENSITIVE_STRING" From regexp_temp;
EMPNAME 	     CASE_SENSITIVE_STRING
-------------------- ---------------------
John Doe				 0 Jane Doe				 1
```
**Div:**
Live SQL:
View and run related examples on Oracle Live SQL at *REGEXP_COUNT case-sensitive matching*
