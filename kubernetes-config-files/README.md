# Kubernetes config files

These files have been updated to run las2peer 0.8

In principle, moving to Kubernetes instead of docker-compose is a good idea, since it’s more configurable in terms of scaling *pairs* of containers (since Docker Compose can’t do this, the generation scripts are used; this would no longer be required with Kubernetes).

Additionally, this setup allows deployment of multiple instances by leveraging the Kubernetes namespace functionality. 

# Target repository
Currently, the kubernetes config targets a personal repo for docker hub ([mslupczynski](https://hub.docker.com/u/mslupczynski)).


# File Structure
<pre>
 <strong># additional config files</strong>
 ┣ /advanced
 ┃ <strong># deploy eth and bootstrap separately</strong>
 ┃ ┣ <a href="advanced/las2peer-eth-separate-chain.yaml">las2peer-eth-separate-chain.yaml</a>
 ┃ ┗ <a href="advanced/las2peer-no-eth.yml">las2peer-no-eth.yml</a>
 <strong># las2peer services required for frontend-statusbar</strong>
 ┣ <em>/services</em>
 ┃ ┣ <a href="services/las2peer-contact-service.yaml">las2peer-contact-service.yaml</a>
 ┃ ┣ <a href="services/las2peer-file-service.yaml">las2peer-file-service.yaml</a>
 ┃ ┗ <a href="services/las2peer-userinformation-service.yaml">las2peer-userinformation-service.yaml</a>
 ┃ <strong># port configuration for pastry</strong>
 ┃ ┣ <a href="services/pastry-las2peer-contact-service.properties">pastry-las2peer-contact-service.properties</a>
 ┃ ┣ <a href="services/pastry-las2peer-file-service.properties">pastry-las2peer-file-service.properties</a>
 ┃ ┗ <a href="services/pastry-las2peer-userinformation-service.properties">pastry-las2peer-userinformation-service.properties</a>
 <strong># deploy ethereum blockchain and las2peer bootstrap, default option</strong>
 ┣ <a href="las2peer-eth-netstats.yml">las2peer-eth-netstats.yml</a>
</pre>

# Deployment configuration

The [las2peer-eth-netstats.yml](las2peer-eth-netstats.yml) file is structured in three parts:
1. **DEPLOYMENT**
    - Configuration of Pods (docker image, environment variables, mounted volumes etc.)
    - Assignment of Pods to Services
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: las2peer-bootstrap
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: las2peer-ethnet
```

2. **CLUSTER IP**
    - Configuration of Services (mapping between pod port and network port)
    - Description which ports can be reachable in the pods assigned to the respective services
```yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    io.kompose.service: las2peer-bootstrap
  name: las2peer-bootstrap
---
apiVersion: v1
kind: Service
metadata:
  labels:
    io.kompose.service: las2peer-ethnet
  name: las2peer-ethnet
```

3. **NODEPORT**
    - Configuration of External Ports (mapping between service port and cluster port)
    - Description which ports on the physical machine are linked to their respective service ports

```yaml
apiVersion: v1
kind: Service
metadata:
  labels:
    io.kompose.service: las2peer-p2p-ports
  name: las2peer-p2p-ports
---
apiVersion: v1
kind: Service
metadata:
  labels:
    io.kompose.service: las2peer-eth-netstats-ports
  name: las2peer-eth-netstats-ports
```

## Service reachability - fixed node assignment, fixed IP

Since all pods are configured to start on the ``master`` node in the rwth-acis kubernetes cluster due to the following:
```yaml
    spec:
      tolerations:
      - key: "node-role.kubernetes.io"
        operator: "Equal"
        value: "master"
        effect: "NoSchedule"
```
we can assume a [fixed IP](http://tech4comp.dbis.rwth-aachen.de) for the services running in the cluster.
This means we can reach the services via the ports described in the NodePort part of the configuration.


# Deploy and manage

The following command deploys the default las2peer bootstrap together with an ethereum blockchain. 
Working directory is assumed to be kubernetes-config-files.
```bash
kubectl apply -f .
```

Shutdown of the deployed services can conversely be acchieved by the following: 
```bash
kubectl delete -f .
```
**Warning**: the -f option always parses the current version of the file. If you have changed a service name in the yaml file without deleting the old service first, this command will not be able to shut down properly.


## Restart pod

```bash
kubectl delete pod $(kubectl get pods|grep bootstrap|awk '{print $1}')
```
kubectl delete pod always wants the full name, but since they are temporary deployments, their name gets randomised. `|grep bootstrap` looks for the las2peer bootstrap pod, while `awk '{print $1}'` takes only the first column of the output, i.e. the pod name. 

## Attach to [web3j interactive console](https://github.com/ethereum/go-ethereum/wiki/JavaScript-Console) (ethereum)

```bash
kubectl exec -it $(kubectl get pods|grep ethnet|awk '{print $1}') geth attach /root/.ethereum/devchain/geth.ipc
```

## Run custom code in web3j interactive console

[checkAllBalances()](https://ethereum.gitbooks.io/frontier-guide/listing_accounts.html)
```bash
kubectl exec -it $(kubectl get pods|grep ethnet|awk '{print $1}') /bin/bash
echo 'function checkAllBalances(){var e=0;eth.accounts.forEach(function(c){console.log("  eth.accounts["+e+"]: "+c+" \tbalance: "+web3.fromWei(eth.getBalance(c),"ether")+" ether"),e++})}'>/root/gethload.js
exit
kubectl exec -it $(kubectl get pods|grep ethnet|awk '{print $1}') geth attach /root/.ethereum/devchain/geth.ipc
loadScript("/root/gethload.js")
checkAllBalances();
```