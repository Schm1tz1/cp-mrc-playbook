# Skupper.io
Skupper is an over-the-top, multi-platform application interconnect. Skupper makes it easy to deploy private application networks that span multiples sites and platforms.

- **Over-the-top** - Skupper operates at the application layer, on top of existing IP networks. Services connect across network boundaries without VPNs or special firewall rules.
- **Multi-platform** - Skupper works on Kubernetes, Docker, Podman, and Linux. It scales up to multi-tenant clusters and down to edge devices.
- **Application-centric** - Skupper creates isolated application-focused networks with logical service addresses that enable application portability.
- **Secure** - Skupper uses mutual TLS authentication and encryption to protect all communication. Application services are never exposed on the public internet.

(Source: https://skupper.io/index.html)

## Base installation for CP
* First, adapt `contexts.env` to your setup - this includes detination context, links and link directions
* Mote on sites here: https://skupper.io/resources/site.html#examples
* Deploy skupper infrastructure, set up sites and link them:
```shell
# Skupper deployment
./install_skupper.sh

# Link the sites according to the link configuration in contexts.env
./link_sites.sh

# Check status and validate link health
./check_status.sh
```

* For every service/port combination to be exposed in a differect Skupper network, we need to set up a connector (exposes local service) and a listener (remote endpoint that connects to a connector) that conect to each other according to routing keys. Also see https://github.com/skupperproject/skupper-example-kafka/tree/main for Kafka, more details on connectors here: https://skupperproject.github.io/refdog/resources/connector.html
* Example listener/connector deployment (WIP):
```shell
# This is WIP ...
```
