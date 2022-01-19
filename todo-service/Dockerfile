FROM node:16.13.0-alpine

WORKDIR /home/app

COPY package.json .
COPY package-lock.json .

RUN npm install

COPY . .

EXPOSE 4000

ENTRYPOINT npm run start:dev
