FROM openjdk:8-jre-alpine
RUN apk add --no-cache bash nodejs npm git python build-base htop curl sed wget vim

RUN npm i -g pm2 http-server

WORKDIR /root
RUN git clone https://github.com/rwth-acis/las2peer-registry-contracts.git
WORKDIR /root/las2peer-registry-contracts
RUN npm install

WORKDIR /root
RUN git clone https://github.com/vishnubob/wait-for-it.git

COPY ./keystore /root/keystore
COPY ./las2peer /root/las2peer
COPY ./etc /root/las2peer/etc

RUN mkdir -p /root/las2peer/log
RUN mkdir -p /root/las2peer/node-storage

WORKDIR /root/las2peer

ARG LAS2PEER_PORT=9000
ENV LAS2PEER_PORT="${LAS2PEER_PORT}"
ARG LAS2PEER_BOOTSTRAP=""
ENV LAS2PEER_BOOTSTRAP="${LAS2PEER_BOOTSTRAP}"

COPY ./start.sh /root/start.sh
RUN chmod +x /root/start.sh
EXPOSE 9000 8001 8080
ENTRYPOINT /root/start.sh
