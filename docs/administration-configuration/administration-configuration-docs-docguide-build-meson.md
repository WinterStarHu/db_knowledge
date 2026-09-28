# PostgreSQL: Documentation: 18: J.4. Building the Documentation with Meson

PostgreSQL: Documentation: 18: J.4. Building the Documentation with Meson Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
Documentation → PostgreSQL 18 Supported Versions:
Current (18) / 17 / 16 Development Versions:
19 / devel J.4. Building the Documentation with Meson Prev Up Appendix J. Documentation Home Next J.4. Building the Documentation with Meson # To build the documentation using Meson, change to the build directory before running one of these commands, or add -C build to the command.
To build just the HTML version of the documentation:
build$ ninja html For a list of other documentation targets see Section 17.4.4.3. The output appears in the subdirectory build/doc/src/sgml.
Prev Up Next J.3. Building the Documentation with Make Home J.5. Documentation Authoring Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
