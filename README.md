This repository contains all files required to build the `w3af` package for [Kali](http://www.kali.org/).

## Building a new package
Building a new `Kali` package for `w3af` requires these steps to be completed:

### Install the required tools
```bash
sudo apt-get install devscripts git-buildpackage debhelper debootstrap
```

### Get this repository
```bash
git clone git@github.com:andresriancho/w3af-kali.git
cd w3af-kali
git checkout upstream
git checkout pristine-tar
git checkout master
```

### Get the latest from Kali repositories

The Kali developers are really active and might add more patches or package dependencies. So before performing any change on our side, lets pull from upstream:

```bash
git remote add kali-upstream git://git.kali.org/packages/w3af.git
git fetch -v kali-upstream
git merge kali-upstream/master
```

### Update the w3af version

Set the version to package:
```bash
# Define the version
VERSION=1.6.45
```

When the code being packaged needs to be updated you'll have to tag it in the `w3af` repository and then:
```bash
# Tag the new release in the w3af repository
cd w3af/
git tag $VERSION
git push origin --tags

# And now in w3af-kali
cd w3af-kali/
# This downloads the updated tagged version from your git repo
uscan --force-download --verbose
git-import-orig ../w3af_$VERSION.orig.tar.gz
```
Please note that the second and last commands will change depending on the version tag.

### Package dependencies
`w3af`'s dependencies change frequently and are listed [here](https://github.com/andresriancho/w3af/blob/master/w3af/core/controllers/dependency_check/requirements.py) . When we add a new dependency to upstream we then add extra work to the packaging process. These are some of the recommended steps to follow to make sure all dependencies are up to date:
 * Check [requirements.py](https://github.com/andresriancho/w3af/blob/master/w3af/core/controllers/dependency_check/requirements.py) file history to identify any changes
 * Find the two `Depends:` entries in the [debian/control](https://github.com/andresriancho/w3af-kali/blob/master/debian/control) file and make sure all `pip` and `OS` packages from `requirements.py` are listed there. It's important to identify the version of each Kali package, please verify the versions using http://pkg.kali.org/
 * If there is a missing library that needs to be packaged contact the Kali developers

### Build the package

```bash
cd w3af-kali/

# Add the new release changelog entry, pointing to the right version
# so dpkg-buildpackage can find the tgz
dch -v $VERSION-0kali1 -D kali
git commit debian/changelog -m $VERSION

dpkg-checkbuilddeps
git-buildpackage --git-ignore-new
```

The last command can fail because of one of the following:
 * Outdated patches (`Hunk #1 FAILED at`), which you fix using [quilt](https://pkg-perl.alioth.debian.org/howto/quilt.html#creating_a_patch)
 * Package signing (`debsign: gpg error occurred!  Aborting`)

## Testing the .deb files
 * Build a docker image using `docker/build.sh`
 * Run the image using `docker run -i -t --rm andresriancho/kali /bin/bash`, then inside the container:
   * `apt-get update`
   * `apt-get dist-upgrade`
   * Copy the newly built `.deb` files to the Kali container
   * `dpkg --install w3af*.deb`
   * Verify that the installation works as expected by running a scan

### Push the changes to this repository
```bash
git push origin pristine-tar
git push origin upstream
```

## Push to Kali repositories
Pushing to Kali repositories is not under our control, so we need to bother one of the Kali maintainers.

Once they push the package we can see it [here](http://pkg.kali.org/pkg/w3af).

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
