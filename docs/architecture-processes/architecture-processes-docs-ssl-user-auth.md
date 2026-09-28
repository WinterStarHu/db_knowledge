---
sidebarTitle: 'SSL user certificate authentication'
slug: /guides/sre/ssl-user-auth
title: 'Configuring SSL user certificate for authentication'
description: 'This guide provides simple and minimal settings to configure authentication with SSL user certificates.'
doc_type: 'guide'
keywords: ['ssl', 'authentication', 'security', 'certificates', 'user management']
---

import SelfManaged from '/snippets/_self_managed_only_no_roadmap.mdx';

This guide provides simple and minimal settings to configure authentication with SSL user certificates. The tutorial builds on the [Configuring TLS user guide](/concepts/features/security/tls/configuring-tls).

1. Generate a Certificate Signing Request (CSR) and key. The basic format is the following:
    ```bash
    openssl req -newkey rsa:2048 -nodes -subj "/CN=:"  -keyout .key -out .csr
    ```
In this example, we'll use this for the domain and user that will be used in this sample environment:
    ```bash
    openssl req -newkey rsa:2048 -nodes -subj "/CN=chnode1.marsnet.local:cert_user"  -keyout chnode1_cert_user.key -out chnode1_cert_user.csr
    ```

2.  Generate and sign the new user certificate that will be used for authentication. The basic format is the following:
    ```bash
    openssl x509 -req -in .csr -out .crt -CA .crt -CAkey .key -days 365
    ```
In this example, we'll use this for the domain and user that will be used in this sample environment:
    ```bash
    openssl x509 -req -in chnode1_cert_user.csr -out chnode1_cert_user.crt -CA marsnet_ca.crt -CAkey marsnet_ca.key -days 365
    ```

1. Create a SQL user defined to use the certificate authentication:
    ```sql
    CREATE USER cert_user IDENTIFIED WITH ssl_certificate CN 'chnode1.marsnet.local:cert_user';
    ```

2. Grant privileges to the new certificate user:
    ```sql
    GRANT ALL ON *.* TO cert_user WITH GRANT OPTION;
    ```

1. Copy the user certificate, user key and CA certificate to a remote node.

2. Configure OpenSSL in the ClickHouse [client config](/concepts/features/interfaces/client#configuration_files) with certificate and paths.

    ```xml
my_cert_name.crt
my_cert_name.key
my_ca_cert.crt
    ```

3. Run `clickhouse-client`.
    ```bash
    clickhouse-client --user  --query 'SHOW TABLES'
    ```

1. Copy the user certificate, user key and CA certificate to a remote node.

2. Use `curl` to test a sample SQL command. The basic format is:
    ```bash
    echo 'SHOW TABLES' | curl 'https://:8443' --cert .crt --key .key --cacert .crt -H "X-ClickHouse-SSL-Certificate-Auth: on" -H "X-ClickHouse-User: " --data-binary @-
    ```
For example:
    ```bash
    echo 'SHOW TABLES' | curl 'https://chnode1:8443' --cert chnode1_cert_user.crt --key chnode1_cert_user.key --cacert marsnet_ca.crt -H "X-ClickHouse-SSL-Certificate-Auth: on" -H "X-ClickHouse-User: cert_user" --data-binary @-
    ```
The output will be similar to the following:
    ```response
    INFORMATION_SCHEMA
    default
    information_schema
    system
    ```

## Summary {#summary}

This article showed the basics of creating and configuring a user for SSL certificate authentication. This method can be used with `clickhouse-client` or any clients which support the `https` interface and where HTTP headers can be set. The generated certificate and key should be kept private and with limited access since the certificate is used to authenticate and authorize the user for operations on the ClickHouse database. Treat the certificate and key as if they were passwords.
