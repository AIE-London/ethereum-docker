#!/bin/bash
set -e

cd /root/eth-net-intelligence-api
perl -pi -e "s/XXX/$(hostname)/g" app.json
/usr/bin/pm2 start ./app.json
sleep 2

geth --datadir=~/.ethereum/devchain init "/root/files/genesis.json"
sleep 2

if [ -n "$ETHEREUM_BOOTSTRAP" ]; then
    echo Attempting to bootstrap Ethereum client ...
    if ~/wait-for-it/wait-for-it.sh $ETHEREUM_BOOTSTRAP --timeout=300; then
        echo Bootstrap is up, connecting ...
        geth --datadir ~/.ethereum/devchain --networkid 456719 --bootnodes enode://288b97262895b1c7ec61cf314c2e2004407d0a5dc77566877aad1f2a36659c8b698f4b56fd06c4a0c0bf007b4cfb3e7122d907da3b005fa90e724441902eb19e@${ETHEREUM_BOOTSTRAP} --rpc --rpcaddr 0.0.0.0 --rpcapi db,personal,eth,net,web3,miner --rpccorsdomain=* --ws --wsaddr 0.0.0.0 --wsapi db,personal,eth,net,web3,miner --wsorigins=* --unlock 0,1 --password /dev/null $([ -n "$MINE" ] && echo --mine --minerthreads 1)
    else
        echo Network connection to "$ETHEREUM_BOOTSTRAP" not possible, stopping.
        echo Double check that the bootstrap node is up and accessible.
    fi
else
    geth --datadir ~/.ethereum/devchain --networkid 456719 --nodekeyhex 091bd6067cb4612df85d9c1ff85cc47f259ced4d4cd99816b14f35650f59c322 --rpc --rpcaddr 0.0.0.0 --rpcapi db,personal,eth,net,web3,miner --rpccorsdomain=* --ws --wsaddr 0.0.0.0 --wsapi db,personal,eth,net,web3,miner --wsorigins=* --mine --minerthreads 1 --unlock 0,1 --password /dev/null
fi
