FROM node:20
WORKDIR /opt/backend
ADD package.json .
ADD *.js .
RUN npm install
ENV DB_HOST="mysql"
CMD [ "node","index.js" ]