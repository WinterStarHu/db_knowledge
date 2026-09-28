---
description: 'Prometheus metrics endpoint in ClickHouse: expose server metrics on a dedicated port for scraping.'
sidebarTitle: 'Prometheus metrics endpoint'
slug: /interfaces/prometheus-metrics
title: 'Prometheus metrics endpoint'
doc_type: 'reference'
---

ClickHouse exposes its own metrics on a dedicated port in the Prometheus text format, so that a Prometheus server can scrape them.

To store Prometheus metrics in ClickHouse and query them with PromQL, see [Prometheus HTTP API and PromQL](/interfaces/prometheus) instead.

## Configure the metrics port {#configure-the-metrics-port}

Configure a dedicated port when a Prometheus server needs to scrape ClickHouse's own metrics:

```xml
9363
/metrics
true
true
true
true
true
true
```

## Configure extended handlers {#configure-extended-handlers}

Section `` can be used to make more extended handlers on the same port.
This section is similar to [``](/concepts/features/interfaces/http) but works for prometheus protocols:

```xml
9363
/metrics
expose_metrics
true
true
true
true
true
true
production
```

## Settings {#settings}

For the complete behavior of these settings, see the [Prometheus section](/reference/settings/server-settings/settings/other#prometheus) of the server settings reference.

| Name | Default | Description |
|---|---|---|
| `port` | none | Port that serves ClickHouse metrics. |
| `endpoint` | `/metrics` | HTTP endpoint for scraping metrics. It starts with `/`. Should not be used with the `` section. |
| `url` / `headers` / `method` | none | Filters used to find a matching handler for a request. Similar to the fields with the same names in the [``](/concepts/features/interfaces/http) section. |
| `info` | true | Exposes the `ClickHouse_Info` gauge with server identity labels (`name`, `version`, `version_describe`, `version_major`, `version_minor`, `version_patch`). |
| `metrics` | true | Exposes metrics from [`system.metrics`](/reference/system-tables/metrics). |
| `asynchronous_metrics` | true | Exposes metrics from [`system.asynchronous_metrics`](/reference/system-tables/asynchronous_metrics). |
| `events` | true | Exposes metrics from [`system.events`](/reference/system-tables/events). |
| `errors` | true | Exposes error counts from [`system.errors`](/reference/system-tables/errors). |
| `histograms` | true | Exposes metrics from [`system.histogram_metrics`](/reference/system-tables/histogram_metrics). |
| `dimensional_metrics` | true | Exposes metrics from [`system.dimensional_metrics`](/reference/system-tables/dimensional_metrics). |
| `labels` | none | Constant labels added to every exposed metric. Each child element defines one label: the element name is the label name (which must match `[a-zA-Z_][a-zA-Z0-9_]*`) and the element value is the label value. Label values support standard config substitutions such as the `from_env` attribute. A label name is rejected when it starts with `__` (reserved by Prometheus), or when it would collide with a label this endpoint already writes for one of its enabled sections. The reserved set therefore follows the endpoint's active export surface: `le` when `histograms` is enabled; the `ClickHouse_Info` labels (`name`, `version`, `version_describe`, `version_major`, `version_minor`, `version_patch`) when `info` is enabled; and any label used by an exposed histogram or dimensional metric family (for example, `group`, `direction`, or `operation_type`) when `histograms` or `dimensional_metrics` is enabled. Because it depends on what the endpoint actually exposes, a name can be valid on one endpoint but rejected on another. |

## Check the endpoint {#check-the-endpoint}

```bash
curl http://127.0.0.1:9363/metrics
```
