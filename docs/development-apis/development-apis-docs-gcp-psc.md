---
title: "GCP Private Service Connect for ClickPipes"
sidebarTitle: "GCP Private Service Connect"
icon: "/images/icons/cloud-providers/google-cloud-color.svg"
description: "Establish a secure connection between ClickPipes and a data source hosted on GCP using Private Service Connect (PSC)."
slug: "/integrations/clickpipes/networking/gcp-psc"
doc_type: "guide"
keywords: ["gcp psc", "private service connect", "ClickPipes security", "reverse private endpoint", "private connectivity"]
integration:
  - support_level: "core"
  - category: "clickpipes"
---

import { Image } from "/snippets/components/Image.jsx";

You can use GCP [Private Service Connect (PSC)](https://cloud.google.com/vpc/docs/private-service-connect) to establish a secure connection between ClickPipes and a data source hosted on GCP. ClickPipes creates a **reverse private endpoint (RPE)** in its VPC and points it at a private endpoint service published for your data source, so traffic is never exposed to the public internet.

ClickPipes supports **cross-region** PSC connectivity via [global access](https://docs.cloud.google.com/vpc/docs/about-accessing-vpc-hosted-services-endpoints#global-access). Global access is required for endpoints located in a different region than the region where the ClickPipes infrastructure runs. Check the [ClickPipes GCP region documentation](/integrations/clickpipes/networking/static-ips#google-cloud-static-nat-ips) for more details.

## Supported patterns {#supported-patterns}

| Pattern | When it applies | Service attachment |
| --- | --- | --- |
| **Native PSC** | Managed services that automatically publish a PSC service attachment (_e.g._ Google Cloud SQL, AlloyDB, Google Cloud Managed Service for Apache Kafka). | Automatically created when you enable PSC on the instance. |
| **Producer-owned PSC** | Data sources that don't publish a service attachment, such as Postgres on Compute Engine or a managed service reachable only by private IP. | Created and managed by you. |

## Prerequisites {#prerequisites}

- A ClickHouse Cloud service hosted on GCP. ClickPipes runs in the same region as your ClickHouse Cloud service (with [a few exceptions](/integrations/clickpipes/networking/static-ips#google-cloud-static-nat-ips)).
- IAM rights to enable PSC on your source and manage PSC service attachments (`roles/compute.networkAdmin`).
- The **ClickPipes consumer project** allowed to connect to your service attachment (`clickpipes-production`).
- If you're provisioning ClickPipes programmatically: a ClickHouse Cloud API key for the organization that owns the service.

## Create the reverse private endpoint {#create-rpe}

To create a RPE, you need the following information for your data source:

- **Service attachment URI**: `projects//regions//serviceAttachments/`, the PSC endpoint published in front of your data source.
- **Private DNS name**: the hostname your pipe connects to. A PSC endpoint gets a static internal IP with no DNS name attached, so ClickPipes resolves this hostname to that IP for you.

### Custom private DNS names {#custom-private-dns-rules}

Because GCP PSC does not propagate DNS, a custom private DNS mapping is required for every GCP PSC endpoint so ClickPipes can resolve it to the endpoint's static internal IP.

The standard ClickPipes [custom private DNS naming rules](/integrations/clickpipes/networking/aws-privatelink#custom-private-dns) apply: wildcard support, uniqueness across a service's reverse private endpoints, and reserved-suffix restrictions are enforced identically for every provider. Wildcards are especially useful, _e.g._ a single mapping such as `*...managedkafka..cloud.goog` fronts every broker of a Managed Kafka cluster.

For GCP PSC, only the mapping's `privateDnsName` is used. The `internalDNSName` field is not supported, because a PSC endpoint exposes a static IP with no DNS name to pin to — mappings always resolve to that IP.

## Approving producer-owned connections {#producer-owned}

For producer-owned PSC, append the ClickPipes consumer project (`clickpipes-production`) to the auto-accept list of the service attachment, so the connection is accepted automatically. If you skip that, the RPE sits in `PendingAcceptance` until you approve it manually.

To accept the connection, the consumer accept list of the service attachment needs the numeric ID-based URI of the endpoint (`projects//regions//forwardingRules/`). To get the `endpointWithId` value for the pending connection on the service attachment, run:

```bash
gcloud beta compute service-attachments describe  \
  --region= --project= \
  --format='json(connectedEndpoints)'
```

Take the `endpointWithId` of the entry whose `status` is `PENDING`, strip the `https://www.googleapis.com/compute/beta/` prefix, and pass the result to `--consumer-accept-list`:

`--consumer-accept-list` overwrites the accept list rather than appending the new consumer project to it. If the service attachment already accepts other projects or endpoints, pass all of them in the same command, or the ones you leave out lose access.

```bash
gcloud beta compute service-attachments update  \
  --region= --project= \
  --consumer-accept-list=projects//regions//forwardingRules/ \
  --reconcile-connections
```

Do not use the `endpoint_id` from the ClickPipes API/Terraform response here; that value is the forwarding-rule _name_, not the numeric ID GCP requires, so the accept list will not match. Always take the numeric ID from the pending `endpointWithId` of the service attachment .

## Managing reverse private endpoints {#managing-rpes}

You can manage existing reverse private endpoints in the ClickHouse Cloud service settings:

1. In the ClickHouse Cloud console sidebar, navigate to `Settings`.

Under `ClickPipe reverse private endpoints` , click on `Reverse private endpoints`.

Reverse private endpoint extended information is shown in the flyout. From this view, it's possible to delete RPEs: click the `×` on an endpoint and confirm to delete it. Deletion is \*\*permanent\*\* and will break any ClickPipe currently using that endpoint.

To change an endpoint's custom private DNS mappings, use the [Cloud API](/integrations/clickpipes/programmatic-access/openapi) or [Terraform](/integrations/clickpipes/programmatic-access/terraform). The update replaces the full list of mappings, rather than adding to it.

If an endpoint shows `Rejected` or `Failed`, read the message under its status: it distinguishes a connection the producer rejected from one that was closed or that needs attention. Both usually mean the accept list of the service attachment doesn't include the ClickPipes consumer project. To see the status GCP reports for the endpoint, describe the  `connectedEndpoints` for the service attachment.

## Known limitations {#limitations}

- A PSC service attachment can only be claimed by one ClickHouse Cloud service at a time; it cannot be reused across multiple services. To move a service attachment to a different service, [Contact ClickHouse support](https://clickhouse.com/support/program) to release the existing claim.
