# PostgreSQL: Documentation: 18: Chapter 17. Installation from Source Code

PostgreSQL: Documentation: 18: Chapter 17. Installation from Source Code Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
Chapter 17. Installation from Source Code Prev Up Part III. Server Administration Home Next Chapter 17. Installation from Source Code Table of Contents
17.1. Requirements
17.2. Getting the Source
17.3. Building and Installation with Autoconf and Make
17.3.1. Short Version
17.3.2. Installation Procedure
17.3.3. configure Options
17.3.4. configure Environment Variables
17.4. Building and Installation with Meson
17.4.1. Short Version
17.4.2. Installation Procedure
17.4.3. meson setup Options
17.4.4. meson Build Targets
17.5. Post-Installation Setup
17.5.1. Shared Libraries
17.5.2. Environment Variables
17.6. Supported Platforms
17.7. Platform-Specific Notes
17.7.1. Cygwin
17.7.2. macOS
17.7.3. MinGW
17.7.4. Solaris
17.7.5. Visual Studio
This chapter describes the installation of PostgreSQL using the source code distribution. If you are installing a pre-packaged distribution, such as an RPM or Debian package, ignore this chapter and see Chapter 16 instead.
Prev Up Next Chapter 16. Installation from Binaries Home
17.1. Requirements
Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
