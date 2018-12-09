LAS2PEER_ROOT=/path/to/las2peer
rsync -a --delete-before --prune-empty-dirs --include '*/' --include 'registrygateway/src/main/resources/logback.xml' --include '*.jar' --exclude '*' --exclude 'las2peer/webconnector/frontend/node_modules' "$LAS2PEER_ROOT" las2peer
