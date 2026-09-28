---
description: 'Composable protocols allows more flexible configuration of TCP access
to the ClickHouse server.'
sidebarTitle: 'Composable protocols'
slug: /operations/settings/composable-protocols
title: 'Composable protocols'
doc_type: 'reference'
---

## Overview {#overview}

Composable protocols allow more flexible configuration of TCP access to the ClickHouse server. This configuration can co-exist alongside, or replace, conventional configuration.

## Configuring composable protocols {#composable-protocols-section-is-denoted-as-protocols-in-configuration-xml}

Composable protocols can be configured in an XML configuration file. The protocols section is denoted with `protocols` tags in the XML config file:

```xml

```

### Configuring protocol layers {#basic-modules-define-protocol-layers}

You can define protocol layers using basic modules. For example, to define an HTTP layer, you can add a new basic module to the `protocols` section:

```xml

http

```
Modules can be configured according to:

- `plain_http` - name which can be referred to by another layer
- `type` - denotes the protocol handler which will be instantiated to process data.
It has the following set of predefined protocol handlers:
  * `tcp` - native clickhouse protocol handler
  * `http` - HTTP clickhouse protocol handler
  * `tls` - TLS encryption layer
  * `proxy1` - PROXYv1 layer
  * `mysql` - MySQL compatibility protocol handler
  * `postgres` - PostgreSQL compatibility protocol handler
  * `prometheus` - Prometheus protocol handler
  * `interserver` - clickhouse interserver handler

### Configuring endpoints {#endpoint-ie-listening-port-is-denoted-by-port-and-optional-host-tags}

Endpoints (listening ports) are denoted by `` and optional `` tags.
For example, to configure an endpoint on the previously added HTTP layer we could modify our configuration as follows:

```xml

http
127.0.0.1
8123

```

If the `` tag is omitted, then the `` from the root config is used.

### Configuring layer sequences {#layers-sequence-is-defined-by-impl-tag-referencing-another-module}

Layers sequences are defined using the `` tag, and referencing another module. For example, to configure a TLS layer on top of our plain_http module we could further modify our configuration as follows:

```xml

http

tls
plain_http
127.0.0.1
8443

```

### Attaching endpoints to layers {#endpoint-can-be-attached-to-any-layer}

Endpoints can be attached to any layer. For example, we can define endpoints for HTTP (port 8123) and HTTPS (port 8443):

```xml

http
127.0.0.1
8123

tls
plain_http
127.0.0.1
8443

```

### Defining additional endpoints {#additional-endpoints-can-be-defined-by-referencing-any-module-and-omitting-type-tag}

Additional endpoints can be defined by referencing any module and omitting the `` tag. For example, we can define `another_http` endpoint for the `plain_http` module as follows:

```xml

http
127.0.0.1
8123

tls
plain_http
127.0.0.1
8443

plain_http
127.0.0.1
8223

```

### Custom HTTP handlers per endpoint {#custom-http-handlers-per-endpoint}

By default, all `type=http` protocol entries share the same `` configuration. You can override this by adding a `` tag that points to a different configuration section. This allows each HTTP port to serve a different set of HTTP routing rules.

For example, to run an alternative HTTP API on port 8124 with its own handlers:

```xml

http
127.0.0.1
8123

http
127.0.0.1
8124
http_handlers_alt

/custom
predefined_query_handler
SELECT 'custom_endpoint'
```

In this example, requests to port 8123 use the standard `` rules, while requests to port 8124 use the `` rules. If `` is omitted, the endpoint falls back to the default ``.

The custom handlers section follows the same format as [``](/reference/settings/server-settings/settings/http#http_handlers).
Changes to the custom handlers section are detected during config reload, and the corresponding endpoint is automatically restarted.

### Default session user per endpoint {#default-session-user-per-endpoint}

When a client connects without specifying a user name (for example, an HTTP request without the `user` parameter, or a native protocol `Hello` packet with an empty user name), the server authenticates it as the default session user - the `default_session_user` [server setting](/reference/settings/server-settings/settings), whose default value is `default`.

The `` tag overrides this setting for a single endpoint. This allows different listening ports to serve different anonymous users:

```xml

http
127.0.0.1
8123

plain_http
127.0.0.1
8124
readonly_user

```

In this example, requests without credentials on port 8123 are authenticated as the globally configured default session user, while those on port 8124 are authenticated as `readonly_user`. A client that passes a user name explicitly is not affected.

The tag is looked up from the endpoint's module towards the referenced (`impl`) modules, and the value closest to the endpoint wins. It applies to the `tcp`, `http`, `mysql` and `postgres` protocol handlers, and to the `prometheus` handlers that authenticate requests (`remote_write`, `remote_read`, `query` and `api_v1`); the metrics exposition endpoints (including Keeper metrics-only endpoints) are served without authentication and ignore the setting. Handlers with a fixed user (the `user` key inside `handler` of an `http_handlers` rule, or the `user` key inside `handler` of a `prometheus.handlers` rule) authenticate as their configured user and also ignore the setting - in particular, an empty `default_session_user` does not reject them. It cannot be used with the `interserver` protocol: interserver connections are authenticated by the cluster secret and the initial user and never use the default session user.

### Specifying additional layer parameters {#some-modules-can-contain-specific-for-its-layer-parameters}

Some modules can contain additional layer parameters. For example, the TLS layer allows a private key (`privateKeyFile`) and certificate files (`certificateFile`) to be specified as follows:

```xml

http
127.0.0.1
8123

tls
plain_http
127.0.0.1
8443
another_server.key
another_server.crt

```
