#!/usr/bin/env bash
set -e
set -o verbose # see commands as they are executed

#DIFFICULTIES="1 10 100 500 1000 2000 5000 10000 25000 50000 100000 200000 400000 800000 1600000 3200000 6400000 12800000"
DIFFICULTIES="25600000 51200000 102400000 204800000"

for d in $DIFFICULTIES; do
	echo "Creating image w difficulty $d ..."
	sed -i "s|rwth-acis/fast-geth:difficulty-[0-9]*|rwth-acis/fast-geth:difficulty-$d|" Dockerfile
	docker build -t rwth-acis/monitored-geth-client:difficulty-$d .
done

echo "... done."
