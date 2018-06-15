FROM node:10.4-alpine

ENV NPM_CONFIG_LOGLEVEL info

RUN npm install -g npm@6.1.0 nodemon

# Provides cached layer for node_modules
COPY package*.json /tmp/
RUN cd /tmp && npm install && mkdir -p /src && cp -a /tmp/node_modules /src/

ENV NODE_ENV production

WORKDIR /src
ADD . /src
RUN npm run build

EXPOSE 3000
CMD ["nodemon", "-L", "server.js"]

