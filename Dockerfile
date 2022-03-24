FROM ruby:2.6.8-bullseye
ENV DEBIAN_FRONTEND=noninteractive

RUN apt -y update && apt -y upgrade
RUN apt -y install build-essential musl-dev musl-tools

WORKDIR /root
