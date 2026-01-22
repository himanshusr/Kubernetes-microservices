FROM ubuntu/nginx:latest
RUN mkdir /app
WORKDIR /app
COPY . /app/
RUN apt update
RUN apt upgrade -y
RUN apt install npm -y
RUN apt install nodejs -y
RUN npm --version
RUN node --version
RUN npm install
ENV API_GATEWAY=http://localhost
RUN npm run build
RUN cp -r dist/* /var/www/html