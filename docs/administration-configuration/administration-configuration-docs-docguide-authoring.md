# PostgreSQL: Documentation: 18: J.5. Documentation Authoring

PostgreSQL: Documentation: 18: J.5. Documentation Authoring Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
J.5. Documentation Authoring Prev Up Appendix J. Documentation Home Next J.5. Documentation Authoring # J.5.1. Emacs The documentation sources are most conveniently modified with an editor that has a mode for editing XML, and even more so if it has some awareness of XML schema languages so that it can know about DocBook syntax specifically.
Note that for historical reasons the documentation source files are named with an extension .sgml even though they are now XML files. So you might need to adjust your editor configuration to set the correct mode.
J.5.1. Emacs # nXML Mode, which ships with Emacs, is the most common mode for editing XML documents with Emacs. It will allow you to use Emacs to insert tags and check markup consistency, and it supports DocBook out of the box. Check the nXML manual for detailed documentation.
src/tools/editors/emacs.samples contains recommended settings for this mode.
Prev Up Next J.4. Building the Documentation with Meson Home J.6. Style Guide Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
