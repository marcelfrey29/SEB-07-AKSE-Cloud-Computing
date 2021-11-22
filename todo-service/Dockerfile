FROM node:16.13.0-alpine

WORKDIR /home/app

COPY package.json .

COPY package-lock.json .

RUN npm install

COPY . .

ENTRYPOINT npm run start:dev

EXPOSE 4000
