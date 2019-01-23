#!/bin/bash
set -e
#set -o verbose # see commands as they are executed
#set -o xtrace # see even more, including variable assignments

GETH_VERBOSITY=${GETH_VERBOSITY:-"3"}

function waitForEndpoint {
    ~/wait-for-command/wait-for-command.sh -c "nc -z ${1} ${2:-80}" --time ${3:-10} --quiet
}
function host { echo ${1%%:*}; }
function port { echo ${1#*:}; }

if [ -n "$ETHEREUM_MONITOR" ]; then
    if waitForEndpoint $(host $ETHEREUM_MONITOR) $(port $ETHEREUM_MONITOR) 30; then
        echo Connecting to Ethereum network stats monitor ...
        cd /root/eth-net-intelligence-api
        perl -pi -e "s/XXXXXX/$(hostname)/g" app.json
        perl -pi -e "s/YYYYYY/$ETHEREUM_MONITOR/g" app.json
        /usr/bin/pm2 start --silent ./app.json
    else
        echo Ethereum network stats monitor specified but unreachable. Ignoring and continuing.
    fi
fi

echo Initializing blockchain from genesis file ...
geth --datadir=~/.ethereum/devchain init "/root/files/genesis.json"

COMMON_OPTS="--verbosity $GETH_VERBOSITY --datadir ~/.ethereum/devchain --networkid 456719 --rpc --rpcaddr 0.0.0.0 --rpcapi db,personal,eth,net,web3,miner --rpccorsdomain=* --rpcvhosts=* --ws --wsaddr 0.0.0.0 --wsapi db,personal,eth,net,web3,miner --wsorigins=* --unlock 0,1 --password /dev/null"

if [ -n "$ETHEREUM_BOOTSTRAP" ]; then
    echo Attempting to bootstrap Ethereum client ...
    if waitForEndpoint $(host $ETHEREUM_BOOTSTRAP) $(port $ETHEREUM_BOOTSTRAP) 120; then
        echo Bootstrap is up, connecting ...

        ETH_HOST=$(echo $ETHEREUM_BOOTSTRAP | cut -d':' -f1)
        ETH_PORT=$(echo $ETHEREUM_BOOTSTRAP | cut -d':' -f2)
        ETH_IP=$(getent hosts $ETH_HOST | awk '{ print $1 }')
         
        MINE_OPTS="$([ ${PEER_MINE:-"0"} -eq "1" ] && echo --mine --minerthreads 1)"
        geth $COMMON_OPTS $MINE_OPTS --bootnodes enode://288b97262895b1c7ec61cf314c2e2004407d0a5dc77566877aad1f2a36659c8b698f4b56fd06c4a0c0bf007b4cfb3e7122d907da3b005fa90e724441902eb19e@${ETH_IP}:${ETH_PORT}
    else
        echo Network connection to "$ETHEREUM_BOOTSTRAP" not possible, stopping.
        echo Double check that the bootstrap node is up and accessible.
    fi
else
    echo Starting new Ethereum network ...
    geth $COMMON_OPTS --nodekeyhex 091bd6067cb4612df85d9c1ff85cc47f259ced4d4cd99816b14f35650f59c322 --mine --minerthreads 1
fi
