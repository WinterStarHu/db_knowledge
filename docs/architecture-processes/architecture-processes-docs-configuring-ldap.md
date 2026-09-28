---
sidebarTitle: 'Configuring LDAP'
slug: /guides/sre/configuring-ldap
title: 'Configuring ClickHouse to use LDAP for authentication and role mapping'
description: 'Describes how to configure ClickHouse to use LDAP for authentication and role mapping'
keywords: ['LDAP configuration', 'LDAP authentication', 'role mapping', 'user management', 'SRE guide']
doc_type: 'guide'
---

import SelfManaged from '/snippets/_self_managed_only_no_roadmap.mdx';

ClickHouse can be configured to use LDAP to authenticate ClickHouse database users. This guide provides a simple example of integrating ClickHouse with an LDAP system authenticating to a publicly available directory.

1. Test your connection to this public LDAP server:
    ```bash
    $ ldapsearch -x -b dc=example,dc=com -H ldap://ldap.forumsys.com
    ```

The reply will be something like this:
    ```response
    # extended LDIF
    #
    # LDAPv3
    # base  with scope subtree
    # filter: (objectclass=*)
    # requesting: ALL
    #

    # example.com
    dn: dc=example,dc=com
    objectClass: top
    objectClass: dcObject
    objectClass: organization
    o: example.com
    dc: example
    ...
    ```

2. Edit the `config.xml` file and add the following to configure LDAP:
    ```xml
ldap.forumsys.com
389
uid={user_name},dc=example,dc=com
never
    ```

These are the basic settings used above:

|Parameter |Description                   |Example              |
|----------|------------------------------|---------------------|
|host      |hostname or IP of LDAP server |ldap.forumsys.com    |
|port      |directory port for LDAP server|389                  |
|bind_dn   |template path to users        |`uid={user_name},dc=example,dc=com`|
|enable_tls|whether to use secure ldap    |no     |
|tls_require_cert |whether to require certificate for connection|never|

3. Add the `` section to `` section to configure the user role mapping. This section defines when a user is authenticated and what role the user will receive. In this basic example, any user authenticating to LDAP will receive the `scientists_role` which will be defined at a later step in ClickHouse. The section should look similar to this:
    ```xml
users.xml
/var/lib/clickhouse/access/
test_ldap_server
dc=example,dc=com
(&amp;(objectClass=groupOfUniqueNames)(uniqueMember={bind_dn}))
     ```

These are the basic settings used above:

|Parameter |Description                   |Example              |
|----------|------------------------------|---------------------|
|server    |label defined in the prior ldap_servers section|test_ldap_server|
|roles      |name of the roles defined in ClickHouse the users will be mapped to|scientists_role|
|base_dn   |base path to start search for groups with user        |dc=example,dc=com|
|search_filter|ldap search filter to identify groups to select for mapping users    |`(&(objectClass=groupOfUniqueNames)(uniqueMember={bind_dn}))`|
|attribute |which attribute name should value be returned from|cn|

4. Restart your ClickHouse server to apply the settings.

1. Create a role in clickhouse with the same name used in the role mapping section of the `config.xml` file
    ```sql
    CREATE ROLE scientists_role;
    ```

2. Grant needed privileges to the role. The following statement grants admin privileges to any user able to authenticate through LDAP:
    ```sql
    GRANT ALL ON *.* TO scientists_role;
    ```

1. Login using the ClickHouse client
    ```bash
    $ clickhouse-client --user einstein --password password
    ClickHouse client version 22.2.2.1.
    Connecting to localhost:9000 as user einstein.
    Connected to ClickHouse server version 22.2.2 revision 54455.

    chnode1 :)
    ```

2.  Test that the user was mapped correctly to the `scientists_role` role and has admin permissions
    ```sql
    SHOW DATABASES
    ```

    ```response
    Query id: 93b785ff-1482-4eda-95b0-b2d68b2c5e0f

    ┌─name───────────────┐
    │ INFORMATION_SCHEMA │
    │ db1_mysql          │
    │ db2                │
    │ db3                │
    │ db4_mysql          │
    │ db5_merge          │
    │ default            │
    │ information_schema │
    │ system             │
    └────────────────────┘

    9 rows in set. Elapsed: 0.004 sec.
    ```

## Summary {#summary}
This article demonstrated the basics of configuring ClickHouse to authenticate to an LDAP server and also to map to a role.  There are also options for configuring individual users in ClickHouse but having those users be authenticated by LDAP without configuring automated role mapping. The LDAP module can also be used to connect to Active Directory.
