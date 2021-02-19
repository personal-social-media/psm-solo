FROM ruby:2.7.2

RUN curl -sL https://deb.nodesource.com/setup_14.x | bash

RUN apt-get update && \
  apt-get install -y \
  build-essential \
  libpq-dev \
  nodejs \
  libmagickwand-dev  \
  vim \
  bison \
  python-dev

RUN npm install -g yarn
RUN apt-get install -y libvips libvips-dev libvips-tools libcurl4 libcurl3-gnutls libcurl4-openssl-dev ffmpeg

RUN mkdir -p /app /sockets /keys
WORKDIR /app