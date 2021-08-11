---
title: Consul Service Mesh with VMs
author: Nic Jackson
slug: consul_vms
browser_windows: https://server.container.shipyard.run:8501
#shipyard_version: ">= 0.3.25"
---

This blueprint create a simple Consul server and agent setup in simulated Ubuntu virtual machines.

## Viewing the UI
The Consul UI can be accessed at "https://server.container.shipayard.run:8501", this uses a self signed TLS cert,
you will need to press the advanced button and allow insecure content in the browser window to allow the display of this UI.

To log into the UI you can use the following ACL token: `00000000-0000-0000-0000-000000000000`

## Consul Versions
Setting the variable `consul_version` will configure the version of Consul used when creating resources.
The version can be set by using the `--var` flag when starting the blueprint.

```
LOG_LEVEL=debug shipyard run --var="consul_version=1.10.1" ./all
```

Currently the following Consul versions are supported:
* 1.9.5 - default
* 1.10.1

## Cleanup
To destroy resources associated with this blueprint use the folowing command:

```
shipyard destroy
```