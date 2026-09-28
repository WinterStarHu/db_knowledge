# Creating Roles and Managing Privileges Using Cloud Control

You can create new roles using privileges found in a privilege analysis report and then grant this role to users.
- Creating a Role from a Privilege Analysis Report in Cloud Control You can use the report summary to find the least number of privileges an application needs, and encapsulate these privileges into a role.
- Revoking and Regranting Roles and Privileges Using Cloud Control You can use Enterprise Manager Cloud Control to revoke and regrant roles and privileges to users.
- Generating a Revoke or Regrant Script Using Cloud Control You can generate a script that revokes or regrants privileges from and to users, based on the results of privilege analysis reports.
## Creating a Role from a Privilege Analysis Report in Cloud Control
You can use the report summary to find the least number of privileges an application needs, and encapsulate these privileges into a role.
````
- Log in to Cloud Control as a user who has been granted the CAPTURE_ADMIN role and the SELECT ANY DICTIONARY privilege. Oracle Database 2 Day DBA explains how to log in.
********
- On the Privilege Analysis page, select the policy name, and then from Actions menu, click Create Role.
****
  - Select the policy from which you would like to create a new role.
  - Enter a unique name for the new role that you want to create.
********
  - Select the Used or Unused check box, depending on what your role must encapsulate. The role can have used or unused system and object privileges and roles.
************
****
****
    - All system privileges, then all the used system privileges captured are included in the new role that you are creating.
****
    - None for role, then no role that is captured in the policy will be used in the new role.
****
    - Customize object privileges, then a list of available used objects privileges captured are displayed, you need to select the privileges from the list to assign to the role.
## Revoking and Regranting Roles and Privileges Using Cloud Control
You can use Enterprise Manager Cloud Control to revoke and regrant roles and privileges to users.
``````
- If Oracle Database Vault is enabled, then ensure that you are authorized as an owner of the Oracle System Privilege and Role Management realm. In SQL*Plus, a user who has been granted the DV_OWNER role can check the authorization by querying the DBA_DV_REALM_AUTH data dictionary view. To grant the user authorization, use the DBMS_MACADM.ADD_AUTH_TO_REALM procedure.
- Generate the privilege analysis report.
- In the Privilege Analysis page, select the policy on which you generated a report.
****
- Select View Reports.
****
- In the Privilege Analysis: Reports page, select the Summary tab.
********
- Under Search, ensure that the Policy and Grantee menu options are set.
````
- Under the Grantee area, expand the grantee options. For example, for a role privilege analysis report for a role called HR_ADMIN role, you would expand the HR_ADMIN role to show the privileges that are associated with it.
********
- Select each privilege to revoke and then click Revoke, or select Regrant to regrant the privilege to the role.
## Generating a Revoke or Regrant Script Using Cloud Control
You can generate a script that revokes or regrants privileges from and to users, based on the results of privilege analysis reports.
- About Generating Revoke and Regrant Scripts You can perform a bulk revoke of unused system and object privileges and roles by using scripts that you can download after you have generated the privilege analysis.
- Generating a Revoke Script You can use Enterprise Manager Cloud Control to generate a script that revokes privileges from users.
- Generating a Regrant Script You can use Enterprise Manager Cloud Control to generate a script that regrants privileges that have been revoked from users.
### About Generating Revoke and Regrant Scripts
You can perform a bulk revoke of unused system and object privileges and roles by using scripts that you can download after you have generated the privilege analysis.
Later on, if you want to regrant these privileges back to the user, you can generate a regrant script. In order to generate the regrant script, you must have a corresponding revoke script.
Execute the revoke scripts in a development or test environment. Be aware that you cannot revoke privileges and roles from Oracle-supplied accounts and roles.
### Generating a Revoke Script
You can use Enterprise Manager Cloud Control to generate a script that revokes privileges from users.
``````
- If Oracle Database Vault is enabled, then ensure that you are authorized as an owner of the Oracle System Privilege and Role Management realm. In SQL*Plus, a user who has been granted the DV_OWNER role can check the authorization by querying the DBA_DV_REALM_AUTH data dictionary view. To grant the user authorization, use the DBMS_MACADM.ADD_AUTH_TO_REALM procedure.
````
**
- In Enterprise Manager, access the target Database home page as a user who has been granted the CAPTURE_ADMIN role and the SELECT ANY DICTIONARY privilege. See Oracle Database 2 Day DBA for more information.
********
- From the Security menu, select Privilege Analysis.
- Ensure that the privilege analysis reports that you want have been generated.
********
- In the Privilege Analysis page, from the Actions menu, select Revoke Scripts.
****
- On the Revoke Scripts page, click Generate. The generate revoke script details wizard is displayed.
****
- In the Script Details page, do the following: select a policy name from the Policy Name menu against which the revoke script needs to be prepared.
********
********
- In the Script Name field, enter a unique name and for Description, a description for the script. For example, if you want to revoke all the unused privileges, select the All option for all the unused privileges and roles, and click Next. Based on your selection, and the available privileges, all the unused system privileges, object privileges, and roles that are going to be revoked are displayed on the respective pages.
************
- For Grantee (user/role), select All or Customize.
************************
- Select All, None, or Customize for the Unused System Privileges, Unused Object Privileges, and Unused Roles settings.
****
********************
- Click Next. The next pages that appear depend on your selections of All, None, or Customize. If you selected all, the page displays a listing of the privileges. If you selected None, the page is bypassed. If you selected Customize, then you can individually select the privileges to revoke. The last page that appears is the Review page.
****
- Click Save. The Revoke Scripts page appears.
****
****
- In the Revoke Scripts page, select the newly created SQL script, and then click Download Revoke Script to download this script, which contains REVOKE SQL statements for each privilege or role. To view the script, click the View Revoke Script button.
****
- To return to the Privilege Analysis page, click Return.
### Generating a Regrant Script
You can use Enterprise Manager Cloud Control to generate a script that regrants privileges that have been revoked from users.
``````
- If Oracle Database Vault is enabled, then ensure that you are authorized as an owner of the Oracle System Privilege and Role Management realm. In SQL*Plus, a user who has been granted the DV_OWNER role can check the authorization by querying the DBA_DV_REALM_AUTH data dictionary view. To grant the user authorization, use the DBMS_MACADM.ADD_AUTH_TO_REALM procedure.
````
**
- In Enterprise Manager, access the target Database home page as a user who has been granted the CAPTURE_ADMIN role and the SELECT ANY DICTIONARY privilege. See Oracle Database 2 Day DBA for more information.
********
- From the Security menu, select Privilege Analysis.
- Ensure that the reports you want have been generated. See Generating a Privilege Analysis Report Using Cloud Control for more information.
- In the Privilege Analysis page, select the policy on which the revoke script was based.
********
- From the Actions menu, select Revoke Scripts.
****
********
- In the Revoke Scripts page, select the policy name that you had created earlier, and then click Download Regrant Script to download this script. You can view the scripts that are associated with the policy by selecting the View Revoke Script and View Regrant Script buttons.
## Related Topics
  - Generating a Privilege Analysis Report Using Cloud Control
