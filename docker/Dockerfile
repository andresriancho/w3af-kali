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

RUN apt-get install -y aspell aspell-en dbus dbus-x11 dconf-gsettings-backend dconf-service \
            dictionaries-common enchant fontconfig fontconfig-config fonts-liberation \
            freepats gconf-service gconf2 gconf2-common gir1.2-glib-2.0 glib-networking \
            glib-networking-common glib-networking-services graphviz gsettings-desktop-schemas \
            gstreamer0.10-ffmpeg gstreamer0.10-gconf gstreamer0.10-plugins-bad \
            gstreamer0.10-plugins-base gstreamer0.10-plugins-good gstreamer0.10-x \
            hicolor-icon-theme hunspell-en-us iso-codes libaa1 libasound2 libaspell15 \
            libass4 libasyncns0 libatk1.0-0 libatk1.0-data libavahi-client3 libavahi-common-data \
            libavahi-common3 libavc1394-0 libavcodec53 libavformat53 libavutil51 libblas3 \
            libcaca0 libcairo-gobject2 libcairo2 libcap2 libcdaudio1 libcdparanoia0 libcdt4 \
            libcgraph5 libcroco3 libcups2 libdatrie1 libdbus-1-3 libdbus-glib-1-2 libdc1394-22 \
            libdca0 libdconf0 libdirac-encoder0 libdirectfb-1.2-9 libdrm-intel1 libdrm-nouveau1a \
            libdrm-radeon1 libdrm2 libdv4 libdvdnav4 libdvdread4 libenca0 libenchant1c2a libfaad2 \
            libfftw3-3 libflac8 libflite1 libfontconfig1 libfreetype6 libfribidi0 libgail18 \
            libgconf-2-4 libgd2-noxpm libgdk-pixbuf2.0-0 libgdk-pixbuf2.0-common libgeoclue0 \
            libgfortran3 libgirepository-1.0-1 libgl1-mesa-dri libgl1-mesa-glx libglapi-mesa \
            libglib2.0-0 libglib2.0-data libglu1-mesa libgme0 libgnome-keyring-common libgnome-keyring0 \
            libgpm2 libgraph4 libgsm1 libgstreamer-plugins-bad0.10-0 libgstreamer-plugins-base0.10-0 \
            libgstreamer0.10-0 libgtk2.0-0 libgtk2.0-bin libgtk2.0-common libgtksourceview2.0-0 \
            libgtksourceview2.0-common libgudev-1.0-0 libgvc5 libgvpr1 libhunspell-1.3-0 libice6 libicu48 \
            libiec61883-0 libjack-jackd2-0 libjasper1 libjavascriptcoregtk-1.0-0 libjbig0 libjpeg8 libjson0 \
            libkate1 libladr4 liblapack3 libltdl7 libmhash2 libmimic0 libmms0 libmodplug1 libmp3lame0 \
            libmpcdec6 libofa0 libogg0 libopenal-data libopenal1 libopenjpeg2 libopus0 liborc-0.4-0 \
            libpango1.0-0 libpathplan4 libpciaccess0 libpcre3 libpixman-1-0 libpng12-0 libpostproc52 \
            libproxy0 libpulse0 libraptor2-0 librasqal3 libraw1394-11 librdf0 librsvg2-2 librsvg2-common \
            libsamplerate0 libschroedinger-1.0-0 libshout3 libslv2-9 libsm6 libsndfile1 libsoundtouch0 \
            libsoup-gnome2.4-1 libsoup2.4-1 libspandsp2 libspeex1 libswscale2 libsystemd-login0 \
            libtag1-vanilla libtag1c2a libthai-data libthai0 libtheora0 libtiff4 libts-0.0-0 \
            libusb-1.0-0 libv4l-0 libv4lconvert0 libva1 libvisual-0.4-0 libvisual-0.4-plugins \
            libvo-aacenc0 libvo-amrwbenc0 libvorbis0a libvorbisenc2 libvpx1 libwavpack1 \
            libwebkitgtk-1.0-0 libwebkitgtk-1.0-common libwildmidi-config libwildmidi1 libwrap0 \
            libx11-xcb1 libx264-123 libxaw7 libxcb-glx0 libxcb-render0 libxcb-shm0 libxcomposite1 \
            libxcursor1 libxdamage1 libxdot4 libxfixes3 libxft2 libxi6  libxinerama1 libxmu6 libxpm4 \
            libxrandr2 libxrender1 libxt6 libxtst6 libxv1 libxvidcore4 libxxf86vm1 libyajl2 libzbar0 \
            libzvbi-common libzvbi0 prover9 psmisc python-gobject-2 python-gtk2 shared-mime-info tcpd \
            tsconf ttf-dejavu-core ttf-liberation ucf x11-common

# Requirements for w3af-scan.sh
RUN wget https://bootstrap.pypa.io/get-pip.py
RUN python get-pip.py
RUN pip install --upgrade pip
RUN pip install --upgrade virtualenv
RUN apt-get install -y build-essential python-dev libmemcached-dev libxml2-dev libxslt1-dev

# I like this editor
RUN apt-get install joe

# Add test web application
RUN git clone https://github.com/andresriancho/django-moth.git
RUN virtualenv /tmp/moth-venv/
RUN /tmp/moth-venv/bin/pip install -r django-moth/requirements.txt

# Scan test
ADD run.sh /tmp/

# The tests to be run inside this container
ENTRYPOINT ["/tmp/run.sh"]
