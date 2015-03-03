FROM andresriancho/kali

MAINTAINER Andres Riancho <andres.riancho@gmail.com>

# Initial setup
WORKDIR /tmp/
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en

# Squash errors about "Falling back to ..." during package installation
ENV TERM linux
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Update before installing any package
RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get dist-upgrade -y

# Install w3af
ADD w3af-console_1.6.45-0kali1_all.deb /tmp/

# Mark dependencies as required
RUN dpkg --install w3af*.deb; true

# Install dependencies
RUN apt-get --yes --fix-broken install

# Really install w3af
RUN dpkg --install w3af*.deb

RUN ./w3af_console --version
