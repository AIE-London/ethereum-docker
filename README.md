# las2peer deployment scripts for Docker Compose

This repo contains Docker Compose config files (and scripts that generate those config files) that allow quickly deploying a network of las2peer nodes with Ethereum clients for the blockchain-based registry.
It also contains the Dockerfiles used to generate the required images.

These files were originally based on the `monitored-geth-client` and `eth-netstats` scripts in Capgemini’s [`ethereum-docker`](https://github.com/Capgemini-AIE/ethereum-docker).

This is meant as a testing environment, with preconfigured and funded accounts (which are unlocked and available over geth’s HTTP/WS APIs).
Additionally, the mining difficulty is currently fixed to a constant value (see the scripts in `fast-geth` and `monitored-geth-client`).

Because preconfigured, password-less accounts are used and geth’s APIs are exposed, this **not secure** and must not be used as-is for production setups.

## Build images and deploy

Enter the subdirectories of `docker-images` and execute `docker build -t SOMENAME .`. (If a README is present, read it.)
Optionally upload the resulting images to some container registry.
Edit the `image` entries in the config files accordingly.

The ACIS group may provide these images via Docker Hub, but if in doubt, build it yourself.

<!--
In the case of a Kubernetes cluster, deploy the `.yaml` files with `kubectl create -f` (comma separated), e.g.,

```sh
kubectl create -f bootstrap-pod.yaml,bootstrap-service.yaml,eth-pod.yaml,netstats-pod.yaml,netstats-service.yaml
```

`kube-dns` needs to be active so that the pods can reach each other via their hostnames.

-->

## Ports

If you want to be certain, actually look at the config file to see what ports are used (both internally and externally). But it should be these:

* bootstrap
    * 9000: las2peer DHT P2P
    * 8545: Ethereum HTTP JSON RPC
    * (8546: Ethereum Websockets JSON RPC – unused)
    * 30303: Ethereum P2P
    * 8080: WebConnector
    * 8001: config file for Registry `.ini`, so that it can be auto-configured by the peers
* netstats
    * 3000: Netstats Web interface
