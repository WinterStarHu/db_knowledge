# PostgreSQL: Documentation: 18: 31.5. Test Coverage Examination

PostgreSQL: Documentation: 18: 31.5. Test Coverage Examination Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
31.5. Test Coverage Examination
Prev Up Chapter 31. Regression Tests Home Next
31.5. Test Coverage Examination #
31.5.1. Coverage with Autoconf and Make
31.5.2. Coverage with Meson
The PostgreSQL source code can be compiled with coverage testing instrumentation, so that it becomes possible to examine which parts of the code are covered by the regression tests or any other test suite that is run with the code. This is currently supported when compiling with GCC, and it requires the gcov and lcov packages.
31.5.1. Coverage with Autoconf and Make #
A typical workflow looks like this:
./configure --enable-coverage ... OTHER OPTIONS ...
make make check # or other test suite make coverage-html Then point your HTML browser to coverage/index.html.
If you don't have lcov or prefer text output over an HTML report, you can run make coverage instead of make coverage-html, which will produce .gcov output files for each source file relevant to the test. (make coverage and make coverage-html will overwrite each other's files, so mixing them might be confusing.) You can run several different tests before making the coverage report; the execution counts will accumulate. If you want to reset the execution counts between test runs, run:
make coverage-clean You can run the make coverage-html or make coverage command in a subdirectory if you want a coverage report for only a portion of the code tree.
Use make distclean to clean up when done.
31.5.2. Coverage with Meson #
A typical workflow looks like this:
meson setup -Db_coverage=true ... OTHER OPTIONS ... builddir/ meson compile -C builddir/ meson test -C builddir/ cd builddir/ ninja coverage-html Then point your HTML browser to ./meson-logs/coveragereport/index.html.
You can run several different tests before making the coverage report; the execution counts will accumulate.
Prev Up Next
31.4. TAP Tests
Home Part IV. Client Interfaces Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
