# PostgreSQL: Documentation: 18: J.3. Building the Documentation with Make

PostgreSQL: Documentation: 18: J.3. Building the Documentation with Make Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
J.3. Building the Documentation with Make Prev Up Appendix J. Documentation Home Next J.3. Building the Documentation with Make # J.3.1. HTML J.3.2. Manpages J.3.3. PDF J.3.4. Syntax Check Once you have everything set up, change to the directory doc/src/sgml and run one of the commands described in the following subsections to build the documentation. (Remember to use GNU make.) J.3.1. HTML # To build the HTML version of the documentation:
doc/src/sgml$ make html This is also the default target. The output appears in the subdirectory html.
To produce HTML documentation with the stylesheet used on postgresql.org instead of the default simple style use:
doc/src/sgml$ make STYLE=website html If the STYLE=website option is used, the generated HTML files include references to stylesheets hosted on postgresql.org and require network access to view.
J.3.2. Manpages # We use the DocBook XSL stylesheets to convert DocBook refentry pages to *roff output suitable for man pages. To create the man pages, use the command:
doc/src/sgml$ make man J.3.3. PDF # To produce a PDF rendition of the documentation using FOP, you can use one of the following commands, depending on the preferred paper format:
For A4 format:
doc/src/sgml$ make postgres-A4.pdf For U.S. letter format:
doc/src/sgml$ make postgres-US.pdf Because the PostgreSQL documentation is fairly big, FOP will require a significant amount of memory. Because of that, on some systems, the build will fail with a memory-related error message. This can usually be fixed by configuring Java heap settings in the configuration file ~/.foprc, for example:
# FOP binary distribution
FOP_OPTS='-Xmx1500m'
# Debian
JAVA_ARGS='-Xmx1500m'
# Red Hat
ADDITIONAL_FLAGS='-Xmx1500m' There is a minimum amount of memory that is required, and to some extent more memory appears to make things a bit faster. On systems with very little memory (less than 1 GB), the build will either be very slow due to swapping or will not work at all.
In its default configuration FOP will emit an INFO message for each page. The log level can be changed via ~/.foprc:
LOGCHOICE=-Dorg.apache.commons.logging.Log=​org.apache.commons.logging.impl.SimpleLog LOGLEVEL=-Dorg.apache.commons.logging.simplelog.defaultlog=WARN Other XSL-FO processors can also be used manually, but the automated build process only supports FOP.
J.3.4. Syntax Check # Building the documentation can take very long. But there is a method to just check the correct syntax of the documentation files, which only takes a few seconds:
doc/src/sgml$ make check Prev Up Next J.2. Tool Sets Home J.4. Building the Documentation with Meson Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
