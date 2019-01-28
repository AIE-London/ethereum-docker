#!/usr/bin/env bash
set -e
#set -o verbose # see commands as they are executed

NUMBER_NODES=${1:-5}
NUMBER_PEERS="$(($NUMBER_NODES-1))"
FILENAME="${2:-$NUMBER_NODES-nodes.docker-compose.yml}"

echo "Generating docker compose file for a network of $NUMBER_NODES nodes (total) ..."
echo "    That means appending the peer section $NUMBER_PEERS times to the config containing just the boot nodes."
echo "    File '$FILENAME' will be overwritten if it already exists."

cp boot-only.docker-compose.yml $FILENAME
for (( i=1; i<=$NUMBER_PEERS; i++ )); do
    BASE_PORT=8080
    PORT=$((BASE_PORT + $i))
    sed "s/peer-1/peer-$i/g;s/8081/$PORT/g" peer-subsection.yml >> $FILENAME
done

echo "... done."
