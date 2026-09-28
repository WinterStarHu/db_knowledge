# Configuring IAM for Oracle DBaaS

To configure IAM to work with the Oracle DBaaS instance, an IAM administrator may need to create an IAM policy and have users create an IAM database password.
- Creating an IAM Policy to Authorize Users Authenticating with Tokens To configure IAM to work with the Oracle DBaaS instance, an IAM administrator must create an IAM policy (if using IAM tokens), create IAM groups and manage group membership.
- Creating an IAM Database Password The IAM database password, different from the Oracle Cloud Infrastructure (OCI) console password, and set by the IAM user, is required for the Oracle DBaaS password verification process.
## Creating an IAM Policy to Authorize Users Authenticating with Tokens
To configure IAM to work with the Oracle DBaaS instance, an IAM administrator must create an IAM policy (if using IAM tokens), create IAM groups and manage group membership.
The IAM administrator should work with the database administrator to create the appropriate IAM groups for databases. Individual IAM users will need to create an IAM database password in their profile if they are using password verifiers.
You do not need to create a policy for users who are authenticating with password verifiers.
```
allow group DBUsers to use database-connections in tenancy
```
- Use the allow group command to create the policy. For example:
````
```
allow group DBUsers to use autonomous-database-family in compartment testing_compartment
```
- To create a policy that limits members of DBUsers group to access DBaaS instances in compartment testing_compartment only
```
allow group DBUsers to use autonomous-database-family in compartment testing_compartment where target.database.id = 'ocid1.autonomousdatabase.oc1.iad.aaaabbbbcccc'
```
- To create a policy that limits group access to a single database in a compartment:
Note the following:
````
- The database-connections resource type is included in the autonomous-database-family resource type. Either resource can be used, depending on your use case.
````
- The minimum verb to enable access to the database is use. You can also use the manage verb to enable access to the database.
- Dynamic group names are case sensitive when they are used in this policy. You must use the exact case for the dynamic group name when using it with this policy.
See Oracle Cloud Infrastructure Documentation for more information about the syntax of policy statements.
## Creating an IAM Database Password
The IAM database password, different from the Oracle Cloud Infrastructure (OCI) console password, and set by the IAM user, is required for the Oracle DBaaS password verification process.
The set of allowed characters for the OCI IAM database password is similar to the set of allowed characters for the OCI console password except that the double quotation mark character is not allowed for the OCI IAM database password. See Managing User Credentials for information about creating an IAM database password.
- Log in to the OCI console to your user page.
********
- Access My profile or User settings (top right in the navigation toolbar) depending on the IAM version that you are using.
****
- In your profile or settings, in the left, under Resources, click on the Database Passwords link.
****
- Click the Create Database Password button.
- Add a description and the password, ensuring that you apply the listed complexity rules.
****
- Click Create Database Password to save the password. After the password is created, its description and creation date are listed under Database Passwords.
