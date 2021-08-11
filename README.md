# Service Based Networking with Consul

## Running

Install Shipyard version 0.3.25 or greater, https://shipyard.run/docs/installhttps://shipyard.run/docs/install  

Install Docker, Shipyard works best with a local Docker engine as files volumes can not be bound when using a remote docker engines  

Run the config and create the resources in Docker

```shell
LOG_LEVEL=debug shipyard run ./consul-vms/all
```

```shell
2021-08-10T19:11:59.901+0100 [DEBUG] Generating TLS Certificates for Ingress: path=/home/nicj/.shipyard/certs
2021-08-10T19:12:02.019+0100 [DEBUG] Starting Ingress
Running configuration from:  ./consul-vms/all

2021-08-10T19:12:02.019+0100 [DEBUG] Statefile does not exist
2021-08-10T19:12:02.025+0100 [INFO]  Creating resources from configuration: path=/home/nicj/go/src/github.com/hashicorp/service-based-networking/consul-vms/all
2021-08-10T19:12:02.025+0100 [DEBUG] Statefile does not exist
2021-08-10T19:12:02.030+0100 [INFO]  Creating Output: ref=CONSUL_HTTP_ADDR
2021-08-10T19:12:02.030+0100 [INFO]  Creating Output: ref=CONSUL_HTTP_TOKEN
2021-08-10T19:12:02.030+0100 [INFO]  Creating Output: ref=CONSUL_CLIENT_CERT
2021-08-10T19:12:02.030+0100 [INFO]  Remote executing command: ref=create_ca command=consul args=[tls, ca, create] image="&{consul:1.10.1  }"
2021-08-10T19:12:02.030+0100 [INFO]  Creating Output: ref=CONSUL_CLIENT_KEY
2021-08-10T19:12:02.030+0100 [INFO]  Creating Output: ref=CONSUL_CACERT
2021-08-10T19:12:02.030+0100 [INFO]  Creating Network: ref=dc1
2021-08-10T19:12:02.030+0100 [INFO]  Remote executing command: ref=create_gossip_key command=sh args=[-c, "consul keygen > /tokens/gossip.key"] image="&{consul:1.10.1  }"

#...

0.2 Consul Versions

Setting the variable consul_version will configure the version of Consul used
when creating resources. The version can be set by using the --var flag when
starting the blueprint.

┃ LOG_LEVEL=debug shipyard run --var="consul_version=1.10.1" ./all

Currently the following Consul versions are supported:
• 1.9.5 
• 1.10.1 - default

0.3 Cleanup

To destroy resources associated with this blueprint use the folowing command:

┃ shipyard destroy


This blueprint defines 5 output variables.

You can set output variables as environment variables for your current terminal session using the following command:

eval $(shipyard env)

To list output variables use the command:

shipyard output
```

### Running with different versions of Consul

Different Consul versions can be run by setting the `consul_version` Shipyard variable. NOTE: before
running a different version of Consul you must first destroy the previous version using the `shipyard destroy` command.

#### Consul 1.9.5

```
LOG_LEVEL=debug shipyard run --var="consul_version=1.9.5" ./consul-vms/all
```

#### Consul 1.10.1 - default

```
LOG_LEVEL=debug shipyard run --var="consul_version=1.10.1" ./consul-vms/all
```

## Removing resources

To remove all containers created by shipyard, run the following command

```
shipyard destroy
```

## Viewing logs

```
shipyard logs
```

```
[users-1]   Aug 10 18:16:55 users-1 consul[82]:     2021-08-10T18:16:55.176Z [WARN]  agent: Check is now critical: check=health
[server]   Aug 10 18:16:55 server consul[75]:     2021-08-10T18:16:55.124Z [WARN]  agent: Coordinate update blocked by ACLs: accessorID=00000000-0000-0000-0000-000000000002
[users-1]   Aug 10 18:16:56 users-1 consul[82]:     2021-08-10T18:16:56.876Z [DEBUG] agent.client.memberlist.lan: memberlist: Stream connection from=10.0.0.3:34148
[server]   Aug 10 18:16:56 server consul[75]:     2021-08-10T18:16:56.876Z [DEBUG] agent.server.memberlist.lan: memberlist: Initiating push/pull sync with: users-1 10.0.0.2:8301
[users-1]   Aug 10 18:17:04 users-1 consul[82]:     2021-08-10T18:17:04.966Z [WARN]  agent: Check socket connection failed: check=service:users-1-sidecar-proxy:1 error="dial tcp 127.0.0.1:21000: connect: connection refused"
[users-1]   Aug 10 18:17:04 users-1 consul[82]:     2021-08-10T18:17:04.966Z [WARN]  agent: Check is now critical: check=service:users-1-sidecar-proxy:1
[users-1]   Aug 10 18:17:05 users-1 consul[82]:     2021-08-10T18:17:05.177Z [WARN]  agent: Check is now critical: check=health
[users-1]   Aug 10 18:17:07 users-1 consul[82]:     2021-08-10T18:17:07.597Z [DEBUG] agent: Node info in sync
[users-1]   Aug 10 18:17:07 users-1 consul[82]:     2021-08-10T18:17:07.597Z [DEBUG] agent: Service in sync: service=users-1
[users-1]   Aug 10 18:17:07 users-1 consul[82]:     2021-08-10T18:17:07.597Z [DEBUG] agent: Service in sync: service=users-1-sidecar-proxy
[users-1]   Aug 10 18:17:07 users-1 consul[82]:     2021-08-10T18:17:07.597Z [DEBUG] agent: Check in sync: check=health
[users-1]   Aug 10 18:17:07 users-1 consul[82]:     2021-08-10T18:17:07.597Z [DEBUG] agent: Check in sync: check=service:users-1-sidecar-proxy:1
[users-1]   Aug 10 18:17:07 users-1 consul[82]:     2021-08-10T18:17:07.601Z [INFO]  agent: Synced check: check=service:users-1-sidecar-proxy:2
```

## Accessing the server or client

Either use the standard Docker command `docker exec -it container_id bash` or you can use the following Shipyard convenience methods

## Consul Client - Users Service
```
shipyard exec container.users-1 -- bash
```

## Consul Server

```
shipyard exec container.server -- bash
```