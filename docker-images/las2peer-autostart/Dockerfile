FROM openjdk:8-jdk-alpine as builder
RUN apk add --no-cache curl tar bash git apache-ant nodejs npm

# https://github.com/mhart/alpine-node/issues/48#issuecomment-370171836
RUN addgroup -g 1000 -S build && \
    adduser -u 1000 -S build -G build

COPY --chown=build:build ./las2peer /app

USER build
WORKDIR /app
RUN ant build-only

FROM openjdk:8-jre-alpine
RUN apk add --no-cache bash

COPY --from=builder /app/core/bin /app/bin
RUN mkdir -p /app/etc
COPY --from=builder /app/core/export /app/export
COPY --from=builder /app/core/lib /app/lib
RUN mkdir -p /app/log
RUN mkdir -p /app/node-storage
COPY --from=builder /app/core/properties /app/properties
COPY --from=builder /app/core/resources /app/resources

WORKDIR /app

ARG LAS2PEER_PORT=9000
ENV LAS2PEER_PORT="${LAS2PEER_PORT}"
ARG LAS2PEER_BOOTSTRAP=""
ENV LAS2PEER_BOOTSTRAP="${LAS2PEER_BOOTSTRAP}"

# since the vars can be overridden when starting the container (and we want that to be possible),
# it's better not to declare that here at all
#EXPOSE ${LAS2PEER_PORT}/tcp
#EXPOSE ${LAS2PEER_PORT}/udp

# https://stackoverflow.com/a/35770783/3826702
# to just keep the container running without a specific command:
#CMD exec /bin/sh -c "trap : TERM INT; (while true; do sleep 1000; done) & wait"

#CMD java -cp "lib/*:export/jars/*" i5.las2peer.tools.L2pNodeLauncher --port ${LAS2PEER_PORT} --node-id-seed ${LAS2PEER_PORT} interactive
CMD java -cp "lib/*:export/jars/*" i5.las2peer.tools.L2pNodeLauncher --port $LAS2PEER_PORT $([ -n "$LAS2PEER_BOOTSTRAP" ] && echo "--bootstrap $LAS2PEER_BOOTSTRAP") --node-id-seed $RANDOM
