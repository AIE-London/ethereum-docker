# las2peer / Ethereum deployment on Kubernetes clusters

> **Status**: Currently the docker compose files are used. Kubernetes files worked a while ago, but are not currently being updated.
> The description below is thus outdated.

This repo contains Dockerfiles and Kubernetes configuration files that allow quickly deploying a network of las2peer / Ethereum nodes.

Based on the `monitored-geth-client` and `eth-netstats` scripts in Capgemini’s [`ethereum-docker`](https://github.com/Capgemini-AIE/ethereum-docker).

This is meant as a testing environment, with preconfigured and funded accounts (which are unlocked and available over geth’s HTTP/WS APIs).
Additionally, the mining difficulty is currently fixed to a constant, low value.

## Build images and deploy

Enter the subdirectories of `docker-images` and execute `docker build -t SOMENAME .`.
Optionally upload the resulting images to some container registry.
Edit the `image` entries in the pod config files (`kubernetes-config-files/*-pod.yaml`) accordingly.

In the case of a Kubernetes cluster, deploy the `.yaml` files with `kubectl create -f` (comma separated), e.g.,

```sh
kubectl create -f bootstrap-pod.yaml,bootstrap-service.yaml,eth-pod.yaml,netstats-pod.yaml,netstats-service.yaml
```

`kube-dns` needs to be active so that the pods can reach each other via their hostnames.

## Ports

* bootstrap
    * 9000: las2peer
    * 8545: Ethereum HTTP JSON RPC
    * 8546: Ethereum Websockets JSON RPC
    * 30303: Ethereum
* netstats
    * 3000: Netstats Web interface
