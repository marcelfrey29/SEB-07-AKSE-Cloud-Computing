FROM node:16.13.0-alpine

WORKDIR /home/app

COPY package.json .
COPY package-lock.json .

RUN npm install --only=production

COPY /dist ./dist

EXPOSE 4000

CMD ["node", "dist/main.js"]
