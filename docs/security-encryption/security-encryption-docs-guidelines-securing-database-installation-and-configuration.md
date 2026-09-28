# Guidelines for Securing a Database Installation and Configuration

Oracle provides guidelines to secure the database installation and configuration.
Changes were made to the default configuration of Oracle Database to make it more secure. The recommendations in this section augment the new, secure default configuration.
**** **
- Before you begin an Oracle Database installation on UNIX systems, ensure that the umask value is 022 for the Oracle owner account. See Oracle Database Administrator’s Reference for Linux and UNIX-Based Operating Systems for more information about managing Oracle Database on Linux and UNIX systems.
**** **** ******
- Install only what is required. Options and Products: The Oracle Database CD pack contains products and options in addition to the database. Install additional products and options only as necessary. Use the Custom Installation feature to avoid installing unnecessary products, or perform a typical installation, and then deinstall options and products that are not required. There is no need to maintain additional products and options if they are not being used. They can always be properly installed, as required. Sample Schemas: Oracle Database provides sample schemas to provide a common platform for examples. If your database will be used in a production environment, then do not install the sample schema. If you have installed the sample schema on a test database, then before going to production, remove or relock the sample schema accounts. See Oracle Database Sample Schemas for more information about the sample schemas.
****
- During installation, when you are prompted for a password, create a secure password. Follow Guidelines 1, 6, and 7 in Guidelines for Securing Passwords.
****
- Immediately after installation, lock and expire default user accounts. See Guideline 1 in Guidelines for Securing User Accounts and Privileges.
