This repository contains all files required to build the [w3af](https://github.com/andresriancho/w3af)
package for [Kali](http://www.kali.org/).

## Building a new package
Building a new `Kali` package for `w3af` requires these steps to be completed:

### Install the required tools
```bash
sudo apt-get install -y devscripts git-buildpackage debhelper debootstrap
```

### Get this repository
```bash
git clone git@github.com:andresriancho/w3af-kali.git
cd w3af-kali

git checkout --track origin/upstream
git checkout --track origin/pristine-tar
git checkout master
```

### Get the latest from Kali repositories

The Kali developers are really active and might add more patches or package dependencies.
So before performing any change on our side, lets pull from upstream:

```bash
git remote add kali-upstream git://git.kali.org/packages/w3af.git
git fetch -v kali-upstream

git checkout master
git merge kali-upstream/master
```

### Update the w3af version

When the code being packaged needs to be updated you'll have to tag it in the `w3af`
repository:
```bash
# Tag the new release in the w3af repository changing the $VERSION
cd w3af/
git tag $VERSION
git push origin --tags
```

And now in w3af-kali:
```bash
cd w3af-kali/

# Define the version
VERSION=`python get-latest-w3af-tag.py`

# This downloads the updated tagged version from your git repo
uscan --force-download --verbose
git-import-orig ../$VERSION.tar.gz --upstream-version=$VERSION
```

### Package dependencies

`w3af`'s dependencies change frequently and are listed
[here](https://github.com/andresriancho/w3af/blob/master/w3af/core/controllers/dependency_check/requirements.py).
When we add a new dependency to upstream we then add extra work to the packaging
process. These are some of the recommended steps to follow to make sure all
dependencies are up to date:

 * Check [requirements.py](https://github.com/andresriancho/w3af/blob/master/w3af/core/controllers/dependency_check/requirements.py) file history to identify any changes

 * Find the two `Depends:` entries in the [debian/control](https://github.com/andresriancho/w3af-kali/blob/master/debian/control) file and make sure all `pip` and `OS` packages from `requirements.py` are listed there. It's important to identify the version of each Kali package, please verify the versions using http://pkg.kali.org/
 
 * If there is a missing library that needs to be packaged contact the Kali developers

### Build the package

```bash
cd w3af-kali/

# Add the new release changelog entry, pointing to the right version
# so dpkg-buildpackage can find the tgz
dch -v $VERSION-0kali1 -D kali -M --force-distribution
git commit debian/changelog -m $VERSION

dpkg-checkbuilddeps

# -uc and -us disable PGP signing (which we don't need, Kali devs will
# sign the final package)
#
# --git-ignore-new ignores any changes to the local directory
#
# -b builds binary only package
git-buildpackage --git-ignore-new -b -uc -us
```

The last command can fail because of one of the following:
 * Outdated patches (`Hunk #1 FAILED at`), which you fix using
 [quilt](https://pkg-perl.alioth.debian.org/howto/quilt.html#creating_a_patch)

 ```bash
 git checkout $W3AF_FILE_TO_PATCH

 # Edit the file with the changes you want to be in the debian package
 subl $W3AF_FILE_TO_PATCH

 quilt refresh
 quilt pop
 quilt push $PATCH_NAME
 ```

## Testing the .deb files

 * Get the latest `w3af-kali` docker from [the registry](https://registry.hub.docker.com/u/andresriancho/w3af-kali/).
 The image includes `django-moth` and some `w3af` dependencies:

 ```bash
 sudo docker pull andresriancho/w3af-kali
 ```

 * Update the image with your local changes by running a build:
 
 ```bash
 cd w3af-kali/docker/
 sudo docker build -t andresriancho/w3af-kali .
 ```
 
 * Prepare the test files and run the container:
 
 ```bash
 cd w3af-kali/docker/
 cp ../../*$VERSION*.deb .
 sudo docker run -v `pwd`:/w3af/ -i -t --name w3af-kali --rm andresriancho/w3af-kali $VERSION
 ```

 If the return code of the command is `0` then `w3af` was properly installed and the scan
 found all the expected vulnerabilities.

### Push the changes to this repository
```bash
git push
git push origin pristine-tar
git push origin upstream
```

## Push to Kali repositories
Pushing to Kali repositories is not under our control, so we need to bother one
of the Kali maintainers.

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
 * The steps outlined in this README.md are automated in [w3af-kali-ci](https://github.com/andresriancho/w3af-kali-ci)
