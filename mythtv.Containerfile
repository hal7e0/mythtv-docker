# vim: set ft=dockerfile :
FROM ubuntu:24.04

ARG MYTHTV_VERSION=34
RUN apt-get update &&\
	apt-get -y dist-upgrade &&\
	apt-get install -y software-properties-common &&\
	add-apt-repository ppa:mythbuntu/$MYTHTV_VERSION &&\
	apt-get update &&\
	apt-get install -y mythtv-backend &&\
	rm -rf /var/lib/apt/lists/*

CMD mythbackend
