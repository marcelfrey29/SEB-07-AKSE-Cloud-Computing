FROM node:16.13.0-bullseye

WORKDIR /home/app

COPY package.json .
COPY package-lock.json .

RUN npm install nuxt
RUN npm install

COPY . .

ENTRYPOINT npm run start:dev
