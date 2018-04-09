# Ethereum Docker

Get started creating Ethereum development and test single and multi-node clusters
rapidly using Docker.

## Motivation

Private Ethereum networks aren't terribly difficult to setup. However bootstrapping that network can be a little difficult and there is a nice monitoring addon to ensure everything is working as expected in your network.

1. Setting up initial "users" can be difficult, generating a wallet id, secret, etc.
1. Monitoring is more difficult than expected, test nodes need a "sidecar" type service that pushes their current status to a monitoring platform
1. A visual representation of the network is really cool to see.

We provide full Ethereum test nodes (using the [Ethereum Go client](https://github.com/ethereum/go-ethereum) with all APIs enabled by default as well as a monitoring dashboard (for the cluster version) provided
via [Netstats](https://github.com/cubedro/eth-netstats).

## Prerequisites

This service uses the very popular docker to run geth in a consistent environment: https://www.docker.com/get-docker

It also uses docker-compose to create our containers and orchestrate their deployment: https://docs.docker.com/compose/

## 1. Creating a Private Ethereum Network

### 1.1. Single-Node Ethereum Network

To run a single test Ethereum node run the following:

```
$ docker-compose -f docker-compose-standalone.yml up -d
```

You should be able to get to the JSON RPC client by browsing to:
```
http://localhost:8545 # See below if using Docker for Mac/Windows
```

### 1.2. Multi-Node Ethereum Network (with Monitoring)

To run an Ethereum Docker cluster run the following:

```
$ docker-compose up -d
```

By default this will create:

* 1 Ethereum Bootstrapped container
* 1 Ethereum container (which connects to the bootstrapped container on launch)
* 1 Netstats container (with a Web UI to view activity in the cluster)

To access the Netstats Web UI:

```
http://localhost:3000
```

### Scaling the number of nodes/containers in the cluster

You can scale the number of Ethereum nodes by running:

```
docker-compose scale eth=3
```

This will scale the number of Ethereum nodes **upwards** (replace 3 with however many nodes
you prefer). These nodes will connect to the P2P network (via the bootstrap node)
by default.

### 1.3. Test accounts ready for use

As part of the bootstrapping process we bootstrap 10 Ethereum accounts for use
pre-filled with 20 Ether for use in transactions by default.

If you want to change the amount of Ether for those accounts
See `files/genesis.json`.

## 2. Interact with geth

To get attached to the `geth` JavaScript console on the node you can run the following
```
docker exec -it ethereumdocker_eth_1 geth attach ipc://root/.ethereum/devchain/geth.ipc
```
Then you can `miner.start()`, and then check to see if it's mining by inspecting `web3.eth.mining`. 

See the [Javascript Runtime](https://github.com/ethereum/go-ethereum/wiki/JavaScript-Console) docs for more.

### 2.1 Use an existing DAG

To speed up the process, you can use a [pre-generated DAG](https://github.com/ethereum/wiki/wiki/Ethash-DAG). All you need to do is add something like this
```
ADD dag/full-R23-0000000000000000 /root/.ethash/full-R23-0000000000000000
```
to the `monitored-geth-client` Dockerfile.

## Docker on Mac/Window

Docker on Mac and Window actually requires a separate Linux kernel running in order run the docker containers. What that ends up being typically is a virtual machine with a different IP address than your `localhost` address. You can fetch the address and open are url by running, for example:
```
open http://$(docker-machine ip default):8545
```

#### Alternative projects

TestRPC - [https://github.com/ethereumjs/testrpc](https://github.com/ethereumjs/testrpc)
