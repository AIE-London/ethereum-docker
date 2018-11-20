#!/bin/bash
set -e

ETH_PROPS_DIR=/root/las2peer/etc/
ETH_PROPS=i5.las2peer.registryGateway.Registry.properties

if [ -n "$LAS2PEER_BOOTSTRAP" ]; then
    echo Getting ethereum config from bootstrap node ...
    L2P_BOOTSTRAP_HOST=$(echo $LAS2PEER_BOOTSTRAP | cut -d':' -f 1)
    wget "http://$L2P_BOOTSTRAP_HOST:8001/${ETH_PROPS}" -O "${ETH_PROPS_DIR}${ETH_PROPS}"
    echo done.
fi

if [ -n "$LAS2PEER_ETH_HOST" ]; then
    echo Replacing Ethereum client host in config files ...
    sed -i "s|^endpoint.*$|endpoint = http://${LAS2PEER_ETH_HOST}:8545|" "${ETH_PROPS_DIR}${ETH_PROPS}"
    sed -i "s/eth-bootstrap/${LAS2PEER_ETH_HOST}/" /root/las2peer-registry-contracts/truffle.js
    echo done.
fi

if [ -n "$LAS2PEER_BOOTSTRAP" ]; then
    echo Skipping migration, contracts should already be deployed
else
    echo Waiting a bit before contract migration to ensure geth is up ...
    # TODO: find okay timing
    sleep 10
    echo Starting truffle migration ...
    cd /root/las2peer-registry-contracts
    ./node_modules/.bin/truffle migrate --network docker_boot 2>&1 | tee migration.log
    echo done. Setting contract addresses in config file ...
    cat migration.log | grep '^  \w*: 0x\w*$' | sed -e 's/:/Address =/;s/^  \(.\)/\L\1/' | tail -n 3 >> "${ETH_PROPS_DIR}${ETH_PROPS}"
    echo done. Serving config files at :8001 ...
    cd /root/las2peer/
    pm2 start http-server -- ./etc -p 8001
fi

echo Starting las2peer node ...
cd /root/las2peer
java -cp "registrygateway/src/main/resources/:core/export/jars/*:registrygateway/export/jars/*:restmapper/export/jars/*:webconnector/export/jars/*:core/lib/*:registrygateway/lib/*:restmapper/lib/*:webconnector/lib/*" i5.las2peer.tools.L2pNodeLauncher --port $LAS2PEER_PORT $([ -n "$LAS2PEER_BOOTSTRAP" ] && echo "--bootstrap $LAS2PEER_BOOTSTRAP") --node-id-seed $RANDOM startWebConnector interactive
#exec /bin/sh -c "trap : TERM INT; (while true; do sleep 1000; done) & wait"
