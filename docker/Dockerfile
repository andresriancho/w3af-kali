FROM andresriancho/kali:1.1.0

MAINTAINER Andres Riancho <andres.riancho@gmail.com>

# Initial setup
WORKDIR /tmp/
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV HOME /root/

# Squash errors about "Falling back to ..." during package installation
ENV TERM linux
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Adding the proposed updates repo, this is where the Kali devs add the
# test packages before merging them into "master"
RUN echo "deb http://http.kali.org/kali kali-proposed-updates main" >> /etc/apt/sources.list

# Update before installing any package
RUN apt-get update -y
RUN apt-get upgrade -y
RUN apt-get dist-upgrade -y

# This image is *really* basic, so let's install some stuff now to have it in
# our cache before ADD'ing the deb file and invalidating it
RUN apt-get install -y ca-certificates file git git-man javascript-common krb5-locales less libapr1 \
            libaprutil1 libbsd0 libclass-isa-perl libcurl3-gnutls libedit2 liberror-perl \
            libexpat1 libffi5 libgmp10 libgssapi-krb5-2 libjs-jquery libk5crypto3 \
            libkeyutils1 libkrb5-3 libkrb5support0 libldap-2.4-2 libmagic1 \
            libneon27-gnutls librtmp0 libsasl2-2 libsasl2-modules libssh2-1 libsvn1 \
            libswitch-perl libx11-6 libx11-data libxau6 libxcb1 libxdmcp6 libxext6 \
            libxml2 libxmuu1 libxslt1.1 libyaml-0-2 mime-support python-cffi python-chardet \
            openssh-blacklist openssh-blacklist-extra openssh-client openssl patch perl \
            perl-modules python python-async python-beautifulsoup python-bitarray \
            python-crypto python-cryptography python-d2to1 python-lxml \
            python-minimal python-openssl python-pkg-resources python-ply python-pycparser \
            python-six python-smmap python-support python-svn python-yaml \
            python2.7 python2.7-minimal rsync sgml-base wwwconfig-common xauth xml-core

# I like this editor
RUN apt-get install joe

# Install w3af
ADD w3af-console_1.6.46-0kali1_all.deb /tmp/

# Mark dependencies as required
RUN dpkg --install w3af*.deb; true

# Install dependencies
RUN apt-get --yes --fix-broken install

# Really install w3af
RUN dpkg --install w3af*.deb

RUN w3af_console --help
RUN w3af_console --version

# Cleanup just in case someone wants to use this w3af-kali image
RUN apt-get autoremove
