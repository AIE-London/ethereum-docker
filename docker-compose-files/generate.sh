#!/usr/bin/env bash
set -e
#set -o verbose # see commands as they are executed

echo "Args of this script: NUMBER_NODES [FILENAME [TOTAL_CORES [DIFFICULTY]]]"
echo "    Difficulty is hardcoded via tags, the corresponding image must be available."
echo "    E.g., the difficulty-1 tag should be available, but that actully doesn't work well."
echo "    For the seed network using 1 CPU core (total), difficulty-400000 was used."

NUMBER_NODES=${1:-5}
FILENAME="${2:-$NUMBER_NODES-nodes.docker-compose.yml}"
TOTAL_CORES=${3:-1}
DIFFICULTY=${4:-1}

NUMBER_PEERS="$(($NUMBER_NODES-1))"
CPU_LIMIT=$(echo $(( 100 * $TOTAL_CORES / $NUMBER_NODES )) | sed 's/..$/.&/')

echo "    Using: Number nodes: $NUMBER_NODES"
echo "           File name: $FILENAME"
echo "           Total CPU core limit: $TOTAL_CORES"
echo "           Difficulty: $DIFFICULTY"

echo "Generating docker compose file for a network of $NUMBER_NODES nodes (total) ..."
echo "    That means appending the peer section $NUMBER_PEERS times to the config containing just the boot nodes."
echo "    File '$FILENAME' will be overwritten if it already exists."

echo "We are intentionally using the docker-compose spec v2.2 in order to impose CPU limits per container."
echo "    (Version 3 removed support for this, at least for docker-compose.)"
echo "    We divide $TOTAL_CORES CPU cores over the number of nodes, meaning $CPU_LIMIT is the 'cpus' value."
echo "    (If you want something different, change var in script.)"

sed -e "s/CPULIMIT/$CPU_LIMIT/g" -e "s/DIFFICULTY/$DIFFICULTY/g" boot-only.docker-compose.yml > $FILENAME
for (( i=1; i<=$NUMBER_PEERS; i++ )); do
    sed -e "s/peer-1/peer-$i/g" -e "s/CPULIMIT/$CPU_LIMIT/g" -e "s/DIFFICULTY/$DIFFICULTY/g" peer-subsection.yml >> $FILENAME
done

echo "... done."
