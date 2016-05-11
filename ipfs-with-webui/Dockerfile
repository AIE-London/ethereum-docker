FROM ipfs/go-ipfs
#FROM alpine:3.3

EXPOSE 3000

RUN apk add --update git nodejs

RUN cd /root &&\
    git clone https://github.com/ipfs/webui &&\
    cd webui &&\
    # Remove all build-time dependencies
    apk del --purge git

ADD start.sh /root/start.sh
RUN chmod +x /root/start.sh

ENTRYPOINT /root/start.sh
