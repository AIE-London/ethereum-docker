#!/bin/bash
set -e

cd /root/webui

# ipfs config --json API.HTTPHeaders.Access-Control-Allow-Origin '["http://localhost:3000"]'
# ipfs config --json API.HTTPHeaders.Access-Control-Allow-Methods '["PUT", "GET", "POST"]'
# ipfs config --json API.HTTPHeaders.Access-Control-Allow-Credentials '["true"]
/usr/local/bin/start_ipfs $@
