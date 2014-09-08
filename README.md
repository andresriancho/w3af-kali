This repository contains all files required to build the `w3af` package for [Kali](http://www.kali.org/).

## Building a new package

Building a new `Kali` package for `w3af` requires these steps to be completed:

### Get the latest from Kali repositories

The Kali developers are really active and might add more patches or package dependencies. So before performing any change on our side, lets pull from upstream:

```bash
cd w3af-kali
git remote add kali-upstream git://git.kali.org/packages/w3af.git
git fetch -v kali-upstream
git merge kali-upstream/master
```

### Update the w3af version

When the code being packaged needs to be updated you'll have to tag it in the `w3af` repository and then:

```bash
cd w3af-kali/
# This downloads the updated tagged version from your git repo
uscan --force-download --verbose
git-import-orig ../w3af_1.6.0.3.orig.tar.gz
```
Please note that the second command will change depending on the version tag.

### Build the package

```bash
cd w3af-kali/

# Add the new release changelog entry, pointing to the right version so dpkg-buildpackage can find the tgz
dch -v 1.6.0.3-0kali1 -D kali
editor debian/changelog

dpkg-checkbuilddeps
git-buildpackage
```

## Testing the .deb files
 * Install `Kali` in a VirtualBox
 * `apt-get update`
 * `apt-get dist-upgrade`
 * Shutdown the VM, and take a snapshot. Call it "After apt-get dist-upgrade"
 * Build the new w3af package as explained before
 * Copy the `.deb` files to Kali
 * `dpkg -i w3af*.deb`
 * Verify that the installation works as expected
 * Run a scan

## Creation of this repository
This repository is a copy of [Kali Linux's w3af repository](http://git.kali.org/gitweb/?p=packages/w3af.git;a=summary) which was created using these commands:

```bash
cd /tmp/
apt-get source w3af
git-import-dsc w3af*.dsc
cd w3af
git push --mirror git@github.com:andresriancho/w3af-kali.git
cd ..
rm -rf w3af
cd /tmp/
git clone git@github.com:andresriancho/w3af-kali.git
cd w3af-kali
git remote add kali-upstream git://git.kali.org/packages/w3af.git
git fetch -v kali-upstream
git merge kali-upstream/master
```

## Resources

 * http://pkg.kali.org/pkg/w3af