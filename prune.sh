docker ps -aq | xargs -n 1 docker stop

docker ps -aq | xargs -n 1 docker rm -v

docker volume prune

docker network prune
