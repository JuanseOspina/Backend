FROM node:12
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install
RUN npm seeds.js
COPY . .
ENV PORT=3000
EXPOSE $PORT
CMD ["node","server.js"]
