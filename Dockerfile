FROM node:16.16-alpine

WORKDIR /server

COPY package.json /server
COPY package-lock.json /server

RUN npm i

COPY . /server

CMD ["node", "./bin/www"]
