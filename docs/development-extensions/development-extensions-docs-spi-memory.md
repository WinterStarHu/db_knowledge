# PostgreSQL: Documentation: 18: 45.3. Memory Management

PostgreSQL: Documentation: 18: 45.3. Memory Management Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
/
8.1
/
8.0
/
7.4
/
7.3
/
7.2
/
7.1
45.3. Memory Management
Prev Up Chapter 45. Server Programming Interface Home Next
45.3. Memory Management #
SPI_palloc — allocate memory in the upper executor context SPI_repalloc — reallocate memory in the upper executor context SPI_pfree — free memory in the upper executor context SPI_copytuple — make a copy of a row in the upper executor context SPI_returntuple — prepare to return a tuple as a Datum SPI_modifytuple — create a row by replacing selected fields of a given row SPI_freetuple — free a row allocated in the upper executor context SPI_freetuptable — free a row set created by SPI_execute or a similar function SPI_freeplan — free a previously saved prepared statement PostgreSQL allocates memory within memory contexts, which provide a convenient method of managing allocations made in many different places that need to live for differing amounts of time. Destroying a context releases all the memory that was allocated in it. Thus, it is not necessary to keep track of individual objects to avoid memory leaks; instead only a relatively small number of contexts have to be managed. palloc and related functions allocate memory from the “current” context.
SPI_connect creates a new memory context and makes it current. SPI_finish restores the previous current memory context and destroys the context created by SPI_connect. These actions ensure that transient memory allocations made inside your C function are reclaimed at C function exit, avoiding memory leakage.
However, if your C function needs to return an object in allocated memory (such as a value of a pass-by-reference data type), you cannot allocate that memory using palloc, at least not while you are connected to SPI. If you try, the object will be deallocated by SPI_finish, and your C function will not work reliably. To solve this problem, use SPI_palloc to allocate memory for your return object. SPI_palloc allocates memory in the “upper executor context”, that is, the memory context that was current when SPI_connect was called, which is precisely the right context for a value returned from your C function. Several of the other utility functions described in this section also return objects created in the upper executor context.
When SPI_connect is called, the private context of the C function, which is created by SPI_connect, is made the current context. All allocations made by palloc, repalloc, or SPI utility functions (except as described in this section) are made in this context. When a C function disconnects from the SPI manager (via SPI_finish) the current context is restored to the upper executor context, and all allocations made in the C function memory context are freed and cannot be used any more.
Prev Up Next SPI_result_code_string Home SPI_palloc Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
