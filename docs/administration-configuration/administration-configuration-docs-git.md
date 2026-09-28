# PostgreSQL: Documentation: 18: I.1. Getting the Source via Git

PostgreSQL: Documentation: 18: I.1. Getting the Source via Git Home About Download Documentation Community Developers Support Donate Your account August 13, 2026: PostgreSQL 18.6, 17.11, 16.15, 15.19, 14.24 and 19 Beta 3 Released!
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
I.1. Getting the Source via Git Prev Up Appendix I. The Source Code Repository Home Next I.1. Getting the Source via Git # With Git you will make a copy of the entire code repository on your local machine, so you will have access to all history and branches offline. This is the fastest and most flexible way to develop or test patches.
Git You will need an installed version of Git, which you can get from https://git-scm.com. Many systems already have a recent version of Git installed by default, or available in their package distribution system.
To begin using the Git repository, make a clone of the official mirror:
git clone https://git.postgresql.org/git/postgresql.git This will copy the full repository to your local machine, so it may take a while to complete, especially if you have a slow Internet connection. The files will be placed in a new subdirectory postgresql of your current directory.
Whenever you want to get the latest updates in the system, cd into the repository, and run:
git fetch Git can do a lot more things than just fetch the source. For more information, consult the Git man pages, or see the website at https://git-scm.com.
Prev Up Next Appendix I. The Source Code Repository Home Appendix J. Documentation Submit correction If you see anything in the documentation that is not correct, does not match your experience with the particular feature or requires further clarification, please use this form to report a documentation issue.
Policies | Code of Conduct | About PostgreSQL | Contact Copyright © 1996-2026 The PostgreSQL Global Development Group
