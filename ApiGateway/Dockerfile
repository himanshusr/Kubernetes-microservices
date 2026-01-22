FROM node:18
RUN mkdir /app
WORKDIR /app
COPY . /app/
RUN npm install
ENV QUOTES_API=http://quote-service:5000
CMD ["node", "index.js"]