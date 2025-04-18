FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y nginx curl && \
mkdir -p /app/static

COPY nginx.conf /etc/nginx/nginx.conf

COPY ./app/static /app/static

EXPOSE 8080

CMD ["nginx", "-g", "daemon off;"]

