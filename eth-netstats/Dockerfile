FROM node:7

RUN git clone https://github.com/cubedro/eth-netstats
RUN cd /eth-netstats && npm install
RUN cd /eth-netstats && npm install -g grunt-cli
RUN cd /eth-netstats && grunt

WORKDIR /eth-netstats

EXPOSE 3000

CMD ["npm", "start"]
