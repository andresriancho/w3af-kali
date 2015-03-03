#!/bin/bash

# Heavily based on https://github.com/ctarwater/docker-kali

# Requires 'debootstrap' 
# So make sure you install it on your system before you run this script.


# Fetch the latest Kali debootstrap script from git
curl "http://git.kali.org/gitweb/?p=packages/debootstrap.git;a=blob_plain;f=scripts/kali;hb=HEAD" > kali-debootstrap &&\

# Run Kali debootstrap to create the install
sudo debootstrap kali ./kali-root http://http.kali.org/kali ./kali-debootstrap &&\

# Bundle the install
sudo tar -C kali-root -c . | sudo docker import - andresriancho/kali &&\

# Remove the artifacts
sudo rm -rf ./kali-root &&\

# Run the image to make sure it worked
docker run -t -i andresriancho/kali cat /etc/debian_version &&\

# Let us know if it worked or not
echo "Build OK" || echo "Build failed!" 