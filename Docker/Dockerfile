FROM ubuntu

RUN apt-get update 
RUN apt-get upgrade -y
RUN apt-get install -y nasm
RUN apt-get install -y binutils
RUN apt-get install -y build-essential
RUN apt-get install -y mtools

VOLUME /root/env
WORKDIR /root/env
