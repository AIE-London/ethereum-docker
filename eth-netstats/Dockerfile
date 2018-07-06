FROM node:8-alpine

RUN apk add --update git

RUN git clone https://github.com/cubedro/eth-netstats

WORKDIR /eth-netstats

RUN npm install
RUN npm install -g grunt-cli
RUN grunt
RUN sudo mkdir -p ~/etc && touch ~/etc/localtime | /usr/sbin/systemsetup -gettimezone | sed 's/^Time Zone\: //' > ~/etc/localtime
EXPOSE 3000

CMD ["npm", "start"]
