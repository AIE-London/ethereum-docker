FROM alpine as builder

RUN apk add --no-cache git go build-base linux-headers

RUN git clone https://github.com/ethereum/go-ethereum.git
WORKDIR /go-ethereum
RUN git checkout v1.8.17
COPY mygeth.patch /go-ethereum/
RUN git apply mygeth.patch
RUN make geth

FROM alpine as dag-generator

RUN apk add --no-cache ca-certificates
COPY --from=builder /go-ethereum/build/bin/geth /usr/local/bin/

# compute DAG so it's baked into the image
RUN geth --datadir=~/.ethereum/devchain makedag 0 ~/.ethash

FROM alpine

RUN apk add --no-cache ca-certificates
COPY --from=dag-generator /usr/local/bin/geth /usr/local/bin/
COPY --from=dag-generator /root/.ethash/ /root/.ethash/

EXPOSE 8545 8546 30303 30303/udp
ENTRYPOINT ["geth"]
#CMD exec /bin/sh -c "trap : TERM INT; (while true; do sleep 1000; done) & wait"
