# NODE_MODULES AND IVY BUILD CACHE
FROM openjdk:8-jdk-alpine AS buildcache
RUN apk add --no-cache bash nodejs npm git python build-base htop curl sed apache-ant tar wget vim && npm i -g pm2 http-server
# https://github.com/mhart/alpine-node/issues/48#issuecomment-370171836
RUN addgroup -g 1000 -S build && adduser -u 1000 -S build -G build
RUN mkdir /app-cache && chown build:build /app-cache
USER build
WORKDIR /app-cache
RUN git clone https://github.com/rwth-acis/las2peer-registry-contracts.git -b master
WORKDIR /app-cache/las2peer-registry-contracts
RUN npm install
WORKDIR /app-cache
# RUN git clone https://github.com/rwth-acis/las2peer/ -b develop
RUN git clone https://github.com/rwth-acis/las2peer/
WORKDIR /app-cache/las2peer
RUN git checkout tags/v1.0.0
RUN ant build-only-no-bundle

# LAS2PEER BOOTSTRAP
FROM openjdk:8-jdk-alpine
EXPOSE 9000 8001 8080
ARG LAS2PEER_PORT=9000
ENV LAS2PEER_PORT="${LAS2PEER_PORT}"
ARG LAS2PEER_BOOTSTRAP=""
ENV LAS2PEER_BOOTSTRAP="${LAS2PEER_BOOTSTRAP}"

RUN apk add --no-cache bash nodejs npm git python build-base htop curl sed apache-ant tar wget vim && npm i -g pm2 http-server

# https://github.com/mhart/alpine-node/issues/48#issuecomment-370171836
RUN addgroup -g 1000 -S build && adduser -u 1000 -S build -G build
RUN mkdir -p /app && chown build:build /app
USER build

WORKDIR /app
RUN git clone https://github.com/ettore26/wait-for-command

# use build cache from develop branch
COPY --from=buildcache --chown=build:build /home/build/.ivy2 /home/build/.ivy2

# cache bust, see https://stackoverflow.com/a/39278224
ADD https://api.github.com/repos/rwth-acis/las2peer-registry-contracts/git/refs/heads/master version.json
RUN git clone https://github.com/rwth-acis/las2peer-registry-contracts.git -b master
WORKDIR /app/las2peer-registry-contracts
COPY --from=buildcache --chown=build:build /app-cache/las2peer-registry-contracts/node_modules /app/las2peer-registry-contracts/node_modules
RUN npm install

WORKDIR /app
# cache bust, see https://stackoverflow.com/a/39278224
ADD https://api.github.com/repos/rwth-acis/las2peer/git/refs/heads/master version.json
RUN git clone https://github.com/rwth-acis/las2peer.git -b master
COPY --from=buildcache --chown=build:build /app-cache/las2peer/webconnector/frontend/node_modules /app/las2peer/webconnector/frontend/node_modules

WORKDIR /app/las2peer
RUN mkdir -p /app/las2peer/restmapper/tmp && mkdir -p /app/las2peer/webconnector/tmp && mkdir -p /app/las2peer/log && mkdir -p /app/las2peer/node-storage
RUN ant build-only-no-bundle

WORKDIR /app
COPY --chown=build:build ./etc /app/las2peer/etc
COPY --chown=build:build ./service /app/las2peer/service
COPY --chown=build:build ./keystore /app/keystore
COPY --chown=build:build ./start.sh /app/start.sh
RUN chmod +x /app/start.sh

ENTRYPOINT /app/start.sh
