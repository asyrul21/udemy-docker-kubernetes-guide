FROM node:14

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

EXPOSE 80

# VOLUME ["/app/node_modules"] # commented since we are using docker run -v flag

CMD  ["npm", "start"]

