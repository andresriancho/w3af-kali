#!/bin/sh

#
# Heavily based on https://github.com/ctarwater/docker-kali
#

# Make sure only root can run our script
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

set -x
set -e

# Fetch the latest Kali debootstrap script from git
curl "http://git.kali.org/gitweb/?p=packages/debootstrap.git;a=blob_plain;f=scripts/kali;hb=HEAD" > kali-debootstrap

echo "Run Kali debootstrap to create the install"
debootstrap kali ./kali-root http://http.kali.org/kali ./kali-debootstrap

echo "Bundle the install"
tar -C kali-root -c . | docker import - andresriancho/kali

echo "Remove the artifacts"
rm -rf ./kali-root

echo "Run the image to make sure it worked"
docker run -t -i andresriancho/kali cat /etc/debian_version
