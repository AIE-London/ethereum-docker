FROM rwthacis/fast-geth

RUN apk add --update git bash nodejs nodejs-npm perl

RUN cd /root &&\
    git clone https://github.com/cubedro/eth-net-intelligence-api &&\
    cd eth-net-intelligence-api &&\
    npm install &&\
    npm install -g pm2

ADD start.sh /root/start.sh
ADD app.json /root/eth-net-intelligence-api/app.json
RUN chmod 777 /root/start.sh

COPY ./genesis.json /root/genesis.json
COPY ./keystore/ /root/keystore
COPY ./localtime /etc/localtime

WORKDIR /root
RUN git clone https://github.com/ettore26/wait-for-command

ENTRYPOINT /root/start.sh
