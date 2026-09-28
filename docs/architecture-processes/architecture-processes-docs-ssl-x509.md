---
description: 'Documentation for Ssl X509'
slug: /operations/external-authenticators/ssl-x509
title: 'SSL X.509 certificate authentication'
doc_type: 'reference'
---

import SelfManaged from '/snippets/_self_managed_only_no_roadmap.mdx';

[SSL 'strict' option](/reference/settings/server-settings/settings/other#openssl) enables mandatory certificate validation for the incoming connections. In this case, only connections with trusted certificates can be established. Connections with untrusted certificates will be rejected. Thus, certificate validation allows to uniquely authenticate an incoming connection. `Common Name` or `subjectAltName extension` field of the certificate is used to identify the connected user. `subjectAltName extension` supports the usage of one wildcard '*' in the server configuration. This allows to associate multiple certificates with the same user. Additionally, reissuing and revoking of the certificates does not affect the ClickHouse configuration.

To enable SSL certificate authentication, a list of `Common Name`'s or `Subject Alt Name`'s for each ClickHouse user must be specified in the settings file `users.xml `:

**Example**
```xml

host.domain.com:example_user
host.domain.com:example_user_dev
DNS:host.domain.com
URI:spiffe://foo.com/*/bar
```

For the SSL [`chain of trust`](https://en.wikipedia.org/wiki/Chain_of_trust) to work correctly, it is also important to make sure that the [`caConfig`](/reference/settings/server-settings/settings/other#openssl) parameter is configured properly.
