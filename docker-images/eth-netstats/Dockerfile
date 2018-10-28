FROM node:8-alpine
EXPOSE 3000

RUN wget -qO- https://github.com/cubedro/eth-netstats/archive/6fc79cfad33132f82a4a04658514a7c7c4a5a26a.zip | unzip -
RUN mv eth-netstats-6fc79cfad33132f82a4a04658514a7c7c4a5a26a eth-netstats

WORKDIR /eth-netstats

RUN npm install
RUN npm run dist

COPY ./localtime /etc/localtime

CMD ["npm", "start"]
