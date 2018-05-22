# Prerequisites for package installation

There are 3 different repos for AGL packages depending on the version, it is
possible to install the three of them and switching between them.

The three versions are:

* ElectricEel: the released version
* Master: the last stable version
* MasterNext: the developer version

```bash
export REVISION=ElectricEel
export REVISION=Master
export REVISION=MasterNext
```

For more details about OBS, please visit [LinuxAutomotive page on OBS](https://build.opensuse.org/project/show/isv:LinuxAutomotive)

## Add repo for debian distro

```bash
#available distro values are xUbuntu_16.04 xUbuntu_16.10 xUbuntu_17.10 xUbuntu_18.04
export REVISION=Master
export DISTRO="xUbuntu_18.04"
wget -O - http://download.opensuse.org/repositories/isv:/LinuxAutomotive:/AGL_${REVISION}/${DISTRO}/Release.key | sudo apt-key add -
sudo bash -c "cat >> /etc/apt/sources.list.d/AGL.list <<EOF
#AGL
deb http://download.opensuse.org/repositories/isv:/LinuxAutomotive:/AGL_${REVISION}/${DISTRO}/ ./
EOF"
sudo apt-get update
```

## Add repo for openSuse distro

```bash
#available distro values are openSUSE_Leap_42.3 openSUSE_Tumbleweed
export REVISION=Master
source /etc/os-release; export DISTRO=$(echo $PRETTY_NAME | sed "s/ /_/g")
sudo zypper ar http://download.opensuse.org/repositories/isv:/LinuxAutomotive:/AGL_${REVISION}/${DISTRO}/isv:LinuxAutomotive:AGL_${REVISION}.repo
sudo zypper --gpg-auto-import-keys ref
```

## Add repo for fedora distro

```bash
#available distro values are Fedora_27 Fedora_28 Fedora_Rawhide
export REVISION=Master
source /etc/os-release ; export DISTRO="${NAME}_${VERSION_ID}"
sudo wget -O /etc/yum.repos.d/isv:LinuxAutomotive:AGL_${REVISION}.repo http://download.opensuse.org/repositories/isv:/LinuxAutomotive:/AGL_${REVISION}/${DISTRO}/isv:LinuxAutomotive:AGL_${REVISION}.repo
```
