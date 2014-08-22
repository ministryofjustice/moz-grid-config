# Pull base image.
FROM phusion/baseimage:0.9.11

MAINTAINER Ravi Kotecha <kotecha.ravi@gmail.com>

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

# Set timezone
RUN echo "Europe/London" > /etc/timezone  &&  dpkg-reconfigure -f noninteractive tzdata

# Dependencies
RUN add-apt-repository -y ppa:chris-lea/node.js
RUN apt-get update
RUN apt-get -y install nodejs

RUN DEBIAN_FRONTEND='noninteractive' \
  apt-get update && \
  apt-get -y --force-yes install build-essential git \
    software-properties-common python-software-properties \
    binutils

RUN  mkdir -p /var/log/selenium

# Define mountable directories.
VOLUME ["/data", "/var/log/selenium"]

# APP_HOME
ENV APP_HOME /home/selenium

# Add project directory to docker
ADD . /home/selenium


# install service files for runit
ADD ./docker/hub.service /etc/service/hub/run
RUN chmod +x /etc/service/hub/run

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Expose ports.
EXPOSE 80