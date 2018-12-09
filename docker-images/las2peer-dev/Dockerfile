FROM openjdk:8-jdk-alpine
EXPOSE 9000 8001 8080
ARG LAS2PEER_PORT=9000
ENV LAS2PEER_PORT="${LAS2PEER_PORT}"
ARG LAS2PEER_BOOTSTRAP=""
ENV LAS2PEER_BOOTSTRAP="${LAS2PEER_BOOTSTRAP}"

RUN apk add --no-cache bash nodejs npm git python build-base htop curl sed apache-ant tar wget vim
RUN npm i -g pm2 http-server

# https://github.com/mhart/alpine-node/issues/48#issuecomment-370171836
RUN addgroup -g 1000 -S build && \
    adduser -u 1000 -S build -G build

RUN mkdir /app && chown build:build /app
USER build

WORKDIR /app
RUN git clone https://github.com/ettore26/wait-for-command

RUN git clone https://github.com/rwth-acis/las2peer-registry-contracts.git
WORKDIR /app/las2peer-registry-contracts
RUN npm install

WORKDIR /app
RUN git clone https://github.com/rwth-acis/las2peer.git -b registry-gateway
WORKDIR /app/las2peer
RUN ant build-modules-only
RUN mkdir -p /app/las2peer/log
RUN mkdir -p /app/las2peer/node-storage

COPY --chown=build:build ./keystore /app/keystore
COPY --chown=build:build ./etc /app/las2peer/etc
COPY --chown=build:build ./start.sh /app/start.sh

RUN chmod +x /app/start.sh
ENTRYPOINT /app/start.sh
