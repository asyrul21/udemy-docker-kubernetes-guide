FROM node

WORKDIR /app

COPY package.json .

RUN npm install

COPY . .

EXPOSE 80

# Default value
# override in the `docker run` -e flag
ENV MONGODB_USERNAME=root

# Default value
# override in the `docker run` -e flag
ENV MONGODB_PASSWORD=root

CMD ["npm", "start"]