# PostgreSQL: Documentation: 18: 2.1. Introduction

PostgreSQL: Documentation: 18: 2.1. Introduction Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
2.1. Introduction
Prev Up Chapter 2. The SQL Language Home Next
2.1. Introduction #
This chapter provides an overview of how to use SQL to perform simple operations. This tutorial is only intended to give you an introduction and is in no way a complete tutorial on SQL. Numerous books have been written on SQL, including [melt93] and [date97]. You should be aware that some PostgreSQL language features are extensions to the standard.
In the examples that follow, we assume that you have created a database named mydb, as described in the previous chapter, and have been able to start psql.
Examples in this manual can also be found in the PostgreSQL source distribution in the directory src/tutorial/. (Binary distributions of PostgreSQL might not provide those files.) To use those files, first change to that directory and run make:
$ cd .../src/tutorial $ make This creates the scripts and compiles the C files containing user-defined functions and types. Then, to start the tutorial, do the following:
$ psql -s mydb ...
mydb=> \i basics.sql The \i command reads in commands from the specified file. psql's -s option puts you in single step mode which pauses before sending each statement to the server. The commands used in this section are in the file basics.sql.
Prev Up Next Chapter 2. The SQL Language Home
2.2. Concepts
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
