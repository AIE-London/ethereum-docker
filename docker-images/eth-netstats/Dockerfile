FROM node:8-alpine
EXPOSE 3000

RUN wget -qO- https://github.com/cubedro/eth-netstats/archive/e4ae99d42d3264d10364d7db28704e596ac830ad.zip | unzip -
RUN mv eth-netstats-e4ae99d42d3264d10364d7db28704e596ac830ad eth-netstats

WORKDIR /eth-netstats
RUN rm -f package-lock.json
RUN rm -rf node_modules
RUN npm install
RUN npm install debug
RUN npm audit fix
RUN npm run dist

COPY ./localtime /etc/localtime

CMD ["npm", "start"]
