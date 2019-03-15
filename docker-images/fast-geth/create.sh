#!/usr/bin/env bash
set -e
set -o verbose # see commands as they are executed

#DIFFICULTIES="1 10 100 500 1000 2000 5000 10000 25000 50000 100000 200000 400000 800000 1600000 3200000 6400000 12800000"
DIFFICULTIES="25600000 51200000 102400000 204800000"

for d in $DIFFICULTIES; do
	echo "Creating image w difficulty $d ..."
	sed -i "s/return big.NewInt([0-9]*)/return big.NewInt($d)/" mygeth.patch
	#tail -n4 mygeth.patch | head -n1
	docker build -t rwth-acis/fast-geth:difficulty-$d .
done

echo "... done."
