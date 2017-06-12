# Ethereum Docker

Get started creating Ethereum development and test single and multi-node clusters
rapidly using Docker.

We provide full Ethereum test nodes (using the [Ethereum Go client](https://github.com/ethereum/go-ethereum) with all APIs enabled by default as well as a monitoring dashboard (for the cluster version) provided
via [Netstats](https://github.com/cubedro/eth-netstats).

#### Alternative projects

TestRPC - [https://github.com/ethereumjs/testrpc](https://github.com/ethereumjs/testrpc)

# Getting started

## 1. Installing

### 1.1. Standalone Ethereum node

#### Prerequisites

Docker Toolbox installed. 
> To download and install Docker Toolbox for your environment please
follow [the Docker Toolbox instructions](https://www.docker.com/products/docker-toolbox). 

After Docker Toolbox has been installed, create a ```default``` machine to run Docker against.

#### Lets go

To run a single test Ethereum node run the following:

```
$ docker-compose -f docker-compose-standalone.yml up -d
```

If using docker-machine you should be able to get to the JSON RPC client by doing:

```
open http://$(docker-machine ip default):8545
```

Assuming you ran docker-compose against the ```default``` machine.

### 1.2. Ethereum Cluster with netstats monitoring

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
open http://$(docker-machine ip default):3000
```

#### Scaling the number of nodes/containers in the cluster

```
docker-compose scale eth=3
```

Will scale the number of Ethereum nodes upwards (replace 3 with however many nodes
you prefer). These nodes will connect to the P2P network (via the bootstrap node)
by default.

### 1.3. Test accounts ready for use

As part of the bootstrapping process we bootstrap 10 Ethereum accounts for use
pre-filled with 20 Ether for use in transactions by default.

If you want to change the amount of Ether for those accounts
See ```files/genesis.json```.

## 2. Interact with geth

If you want to start mining or stop mining you need to connect to the node via:
```
docker exec -it ethereumdocker_eth_1 geth attach ipc://root/.ethereum/devchain/geth.ipc
```
Replace ethereumdocker_geth_1 with the container name you wish to connect to.

### 2.1 Use existing DAG

To speed up the process, you can use a pre-generated DAG. All you need to do is add something like this
```
ADD dag/full-R23-0000000000000000 /root/.ethash/full-R23-0000000000000000
```
to the monitored-geth-client Dockerfile.
