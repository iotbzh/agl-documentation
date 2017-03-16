Build from scratch: AGL image and SDK for Porter
================================================

## Inside the container

### Features

Container features:
- a Debian 8.5 based system with an SSH server listening on tcp/22,
- a dedicated user is defined to run the SSH session: **devel**
  (password: **devel**)
- a script named "prepare_meta" for preparing the build environment

### File system organization and shared volume

The image has been designed with a dedicated file-system hierarchy. Here it is:
```
devel@bsp-devkit:/$ **tree -L 2 /xdt**
/xdt
|-- build
| `-- conf
| |-- bblayers.conf
| |-- local.conf
| [snip]
|-- ccache
|-- downloads
|-- meta
| |-- agl-manifest
| |-- meta-agl
| |-- meta-agl-demo
| |-- meta-agl-extra
| |-- meta-amb
| |-- meta-intel
| |-- meta-intel-iot-security
| |-- meta-iot-agl
| |-- meta-oic
| |-- meta-openembedded
| |-- meta-qt5
| |-- meta-renesas
| |-- meta-rust
| |-- meta-security-isafw
| `-- poky
|-- sdk
|-- sources
|-- sstate-cache
| |-- 00
| |-- 01
| |-- 02
| |-- 03
| |-- 04
| |-- 05
| |-- 06
| |-- 07
 [snip]
`-- workspace
```
Noticeably, the BSP related features are located in the dedicated "/xdt"
directory.

This directory contains sub-directories, and in particular the
following:
- **build**: will contain the result of the build process, including
  an image for the Porter board.
- **downloads**: (optional) contain the Yocto download cache, a
  feature which will locally store the upstream projects sources codes
  and which is fulfilled when an image is built for the first time.
  When populated, this cache allow the user to built without any
  connection to Internet.
- **meta**: contains the pre-selected Yocto layers required to built
  the relevant AGL image for the Porter board.
- **sstate-cache**: (optional) contain the Yocto shared state
  directory cache, a feature which store the intermediate output of
  each task for each recipe of an image. This cache enhance the image
  creation speed time by avoiding Yocto task to be run when they are
  identical to a previous image creation.


## Build an image for Porter board

In this section, we will go on the image compilation for the Porter
board within the Docker container.

### Download Renesas proprietary drivers

For the Porter board, we first need to download the proprietary drivers
from Renesas web site. The evaluation version of these drivers can be
found here:

[http://www.renesas.com/secret/r_car_download/rcar_demoboard.jsp](http://www.renesas.com/secret/r_car_download/rcar_demoboard.jsp)

under the **Target hardware: R-Car H2, M2 and E2** section:

![](pictures/renesas_download.jpg)

Note that you have to register with a free account on MyRenesas and
accept the license conditions before downloading them. The operation is
fast and simple but nevertheless mandatory to access evaluation of non
open-source drivers for free.

Once you register, you can download two zip files: store them in a
directory visible from the container, for example in the directory
`$MIRRORDIR/proprietary-renesas-r-car` (`$MIRRORDIR` was created
previously in section [Start the container](#anchor-start-container) and adjust
the permissions. The zip files should then be visible from the inside of the
container in `/home/devel/mirror`:
```
$ chmod +r /home/devel/mirror/proprietary-renesas-r-car/*.zip
$ ls -l /home/devel/mirror/proprietary-renesas-r-car/
total 8220
-rw-r--r-- 1 1000 1000 6047383 Jul 11 11:03 R-Car_Series_Evaluation_Software_Package_for_Linux-20151228.zip
-rw-r--r-- 1 1000 1000 2394750 Jul 11 11:03 R-Car_Series_Evaluation_Software_Package_of_Linux_Drivers-20151228.zip
```

### Setup the build environment

We should first prepare the environment to build images.

This can be easily done thanks to a helper script named `prepare_meta`.
This script does the following:
- check for an updated version at
  [https://github.com/iotbzh/agl-manifest](https://github.com/iotbzh/agl-manifest)
- pull Yocto layers from git repositories, following a snapshot manifest
- setup build configuration (build/conf files)

The following options are available:
```
devel@bsp-devkit:~$ prepare_meta -h
prepare_meta [options]

Options:
 -f|--flavour <flavour[/tag_or_revision]>
   what flavour to us
   default: 'iotbzh'
   possible values: 'stable','unstable','testing', 'iotbzh' ... see agl-manifest git repository
 -o|--outputdir <destination_dir>
   output directory where subdirectories will be created: meta, build, ...
    default: current directory (.)
 -l|--localmirror <directory>
   specifies a local mirror directory to initialize meta, download_dir or sstate-cache
    default: none
 -r|--remotemirror <url>
   specifies a remote mirror directory to be used at build time for download_dir or sstate-cache
    default: none
 -p|--proprietary <directory>
   Directory containing Renesas proprietary drivers for RCar platform (2 zip files)
    default: none
 -e|--enable <option>
   enable a specific option
    available options: ccache, upgrade
 -d|--disable <option>
   disable a specific option
    available options: ccache, upgrade
 -t|--target <name>
   target platform
    default: porter
    valid options: intel-corei7-64, qemux86, qemux86-64, wandboard
 -h|--help
   get this help

Example:
  prepare_meta -f iotbzh/master -o /tmp/xdt -l /ssd/mirror -p /vol/xdt/proprietary-renesas-rcar/ -t porter
```

In our case, we can start it with the following arguments:
- build in `/xdt` (-o /xdt)
- build for porter board (`-t porter`)
- build the 'iotbzh' flavour (`-f iotbzh`), which contains the standard
  AGL layers + security and app framework. Flavours are stored in the
  agl-manifest repository.
- Use a local mirror (`-l <mirror path>`). This directory may
  contain some directories generated in a previous build: `downloads`,
  `sstate-cache`, `ccache`, `meta`. If found, the mirror directories
  will be specified in configuration files.
- specify proprietary drivers location (`-p <drivers path>`)

So we can run the helper script:
```
devel@bsp-devkit:~$ prepare_meta -o /xdt -t porter -f rel2.0 -l /home/devel/mirror/ -p /home/devel/mirror/proprietary-renesas-r-car/ -e wipeconfig
[...]
=== setup build for porter
Using proprietary Renesas drivers for target porter
=== conf: build.conf
=== conf: download caches
=== conf: sstate caches
=== conf: local.conf
=== conf: bblayers.conf.inc -> bblayers.conf
=== conf: porter_bblayers.conf.inc -> bblayers.conf
=== conf: bblayers_proprietary.conf.inc is empty
=== conf: porter_bblayers_proprietary.conf.inc is empty
=== conf: local.conf.inc is empty
=== conf: porter_local.conf.inc is empty
=== conf: local_proprietary.conf.inc is empty
=== conf: porter_local_proprietary.conf.inc is empty
=====================================================================

Build environment is ready. To use it, run:

# source /xdt/meta/poky/oe-init-build-env /xdt/build

then

# bitbake agl-demo-platform
```

Now, the container shell is ready to build an image for Porter.

### Launch the build

To start the build, we can simply enter the indicated commands:
```
devel@bsp-devkit:~$ . /xdt/build/agl-init-build-env
### Shell environment set up for builds. ###

You can now run 'bitbake <target>'

Common target are:

 agl-demo-platform

devel@bsp-devkit:/xdt/build$ bitbake agl-demo-platform
[snip]
NOTE: Tasks Summary: Attempted 5108 tasks of which 4656 didn't need to
be rerun and all succeeded.

Summary: There were 19 WARNING messages shown.
```

Without mirror, it will take a few hours to build all the required
component of the AGL distribution, depending on: your host machine CPU,
disk drives types and internet connection.

### Updating the local mirror

Optionally, at the end of the build, some directories may be synced to
the mirror dir, for future usage:

- `/xdt/meta`: contains all layers used to build AGL
- `/xdt/downloads`: download cache (avoid fetching source from remote sites)
- `/xdt/sstate-cache`: binary build results (avoid recompiling sources)

This can be done with the following command:
```
$ for x in meta downloads sstate-cache; do rsync -Pav \
   --delete /xdt/$x /home/devel/mirror/$x; done
```


## Porter image deployment on target

Once the Porter image has been built with Yocto, we can deploy it on an
empty SD card to prepare its use on the target.

### SD card image creation

First, we need to generate an SD card disk image file. For this purpose,
a helper script is provided within the container. Here below is the way
to use it.

#### Linux, Mac OS X ©
```
$ cd /xdt/build
$ mksdcard /xdt/build/tmp/deploy/images/porter/agl-demo-platform-porter-20XXYYZZxxyyzz.rootfs.tar.bz2 /home/devel/mirror
```

#### Windows ©
```
$ cd /xdt/build
$ sudo dd if=/dev/zero of=/sprs.img bs=1 count=1 seek=4G
$ sudo mkfs.ext4 /sprs.img
$ sudo mkdir /tmp/sprs
$ sudo mount /sprs.img /tmp/sprs
$ sudo mksdcard /xdt/build/tmp/deploy/images/porter/agl-demo-platform-porter-20XXYYZZxxyyzz.rootfs.tar.bz2
/tmp/sprs/sdcard.img
$ xz -dc /tmp/sprs/sdcard.img.xz > $XDT_WORKSPACE/agl-demo-platform-porter-sdcard.img
```

You should get the following prompt during the `mksdcard` step:
```
Creating the image agl-demo-platform-porter-sdcard.img ...
0+0 records in
0+0 records out
0 bytes (0 B) copied, 6.9187e-05 s, 0.0 kB/s
mke2fs 1.42.12 (29-Aug-2014)
Discarding device blocks: done
Creating filesystem with 524287 4k blocks and 131072 inodes
Filesystem UUID: 5307e815-9acd-480b-90fb-b246dcfb28d8
Superblock backups stored on blocks:
    32768, 98304, 163840, 229376, 294912

Allocating group tables: done
Writing inode tables: done
Creating journal (8192 blocks): done
Writing superblocks and filesystem accounting information: done

Extracting image tarball...
done

Image agl-demo-platform-porter-sdcard.img created!

Set the following uboot environment
setenv bootargs_console 'console=ttySC6,38400 ignore_loglevel'
setenv bootargs_video 'vmalloc=384M video=HDMI-A-1:1920x1080-32@60'
setenv bootargs_root 'root=/dev/mmcblk0p1 rootdelay=3 rw rootfstype=ext3 rootwait'
setenv bootmmc '1:1'
setenv bootcmd_sd 'ext4load mmc ${bootmmc} 0x40007fc0 boot/uImage+dtb'
setenv bootcmd 'setenv bootargs ${bootargs_console} ${bootargs_video} ${bootargs_root}; run bootcmd_sd; bootm 0x40007fc0'
saveenv

NB: replace bootmmc value '1:1' with '0:1' or '2:1' to access the good slot
 use 'ext4ls mmc XXX:1' to test access

$ ls -lh $XDT_WORKSPACE
-rw-r--r-- 1 devel devel 2.0G Feb 15 14:13 agl-demo-platform-porter-sdcard.img

```
After the disk image is created, we can copy it on the SD card itself
using an SD card adapter. To do so, we need to gain access to the SD
card image file from our host machine.

If you already share a directory between your host machine and the
container (as described in section [Set up a persistent workspace](#anchor-setup-persist-wks)),
this state is already reached and you go directly on sections relating the SD
card image installation.

Otherwise, you need to copy the SD card image file out of the container
and into your host machine using SSH protocol:

- On Linux and Mac OS X hosts, you can use the `scp` command, which is part of
 the OpenSSH project,
- On Windows hosts, you can use the
 [`pscp.exe`](http://the.earth.li/~sgtatham/putty/latest/x86/pscp.exe)
 binary, which is part of the [PuTTY project](http://www.putty.org/).


### Deployment from a Linux or Mac OS X host

Now that the SD card image is ready, the last step required is to
"flash" it onto the SD card itself.

First, you need an SD card adapter connected to your host machine.
Depending on your adapter type and OS, the relevant block device can
change. Mostly, you can expect:

- `/dev/sdX` block device; usually for external USB adapters on
    Linux hosts,
-   `/dev/mmcblkN`: when using a laptop internal adapter on Linux
    hosts,
-   `/dev/diskN`: on Mac OS X hosts,

#### Linux

If you do not know which block device you should use, you can check the
kernel logs using the following command to figure out what is the
associated block devices:
```
$ dmesg | grep mmcblk
$ dmesg | grep sd
[...snip...]
[1131831.853434] sd 6:0:0:0: [sdb] 31268864 512-byte logical blocks: (16.0 GB/14.9 GiB)
[1131831.853758] sd 6:0:0:0: [sdb] Write Protect is on
[1131831.853763] sd 6:0:0:0: [sdb] Mode Sense: 4b 00 80 08
[1131831.854152] sd 6:0:0:0: [sdb] No Caching mode page found
[1131831.854157] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[1131831.855174] sd 6:0:0:0: [sdb] No Caching mode page found
[1131831.855179] sd 6:0:0:0: [sdb] Assuming drive cache: write through
[...snip...]
$
```

In this example, no `mmcblk` device where found, but a 16.0GB disk was
listed and can be accessed on **`/dev/sdb`** which in our case is the
physical SD card capacity.

The command `lsblk` is also a good solution to explore block devices:
```
$ lsblk
NAME MAJ:MIN RM SIZE RO TYPE MOUNTPOINT
sda 8:0 0 931.5G 0 disk
|--sda1 8:1 0 8G 0 part /
|--sda2 8:2 0 16G 0 part [SWAP]
|--sda3 8:3 0 907.5G 0 part
 |--vg0-usr 254:0 0 32G 0 lvm /usr
 |--vg0-data 254:1 0 200G 0 lvm /data
 |--vg0-home 254:2 0 100G 0 lvm /home
 |--vg0-var 254:3 0 8G 0 lvm /var
 |--vg0-docker 254:4 0 100G 0 lvm /docker
sdb 8:16 0 223.6G 0 disk
|--sdb1 8:17 0 223.6G 0 part /ssd
sdc 8:32 1 3.7G 0 disk                  <-- SD card plugged into USB card reader
|--sdc1 8:33 1 2G 0 part                <--
sr0 11:0 1 1024M 0 rom
```
In this example, the 4GB device `/dev/sdc` is listed as removable
(column RM) and corresponds to a SD Card plugged into an USB card
reader.

Finally, as we know the block device which corresponds to our SD card,
we can raw-copy the image on it using the following command __**from your
host terminal**__ : (replace `/dev/sdZ` by the appropriate device)
```
$ xzcat ~/mirror/agl-demo-platform-porter-20XXYYZZxxyyzz.raw.xz | sudo dd of=/dev/sdZ bs=1M
2048+0 records in
2048+0 records out
2147483648 bytes (2.0 GB) copied, 69 s, 39.2 MB/s
$ sync
```

This will take few minutes to copy and sync. You should not remove the
card from its slot until both commands succeed.

Once it is finished, you can unplug the card and insert it in the
micro-SD card slot on the Porter board, and perform a power cycle to
start your new image on the target.

__**NB:**__ The output format is also suitable to `bmaptool` utility (source
code available here: [https://github.com/01org/bmap-tools](https://github.com/01org/bmap-tools):
this significantly speeds up the copy as only relevant data are written on
the Sdcard (filesystem "holes" are not written). It's also supporting
direct access to URLs pointing to compressed images.

#### Mac OS X ©

If you do not know which block device you should use, you can use the
`diskutil` tool to list them:
```
$ diskutil list
[...snip...]

/dev/disk2
#:   TYPE                  NAME   SIZE       IDENTIFIER
0: Fdisk_partition_scheme          7.9 GB    disk2
1: Linux                           7.9 GB    disk2s1
[...snip...]
$
```

In this example, we have a 8.0GB disk which can be accessed on
**`/dev/disk2`** which in our case is the physical SD card capacity.

Finally, as we know the block device which accesses our SD card, we can
raw-copy the image on it using the following command __from your host
terminal__:
```
$ xzcat ~/mirror/agl-demo-platform-porter-20XXYYZZxxyyzz.raw.xz | sudo dd of=/dev/disk2 bs=1M
2048+0 records in
2048+0 records out
2147483648 bytes (2.0 GB) copied, 69 s, 39.2 MB/s
$ sync
```

This will take few minutes to copy and sync. You should not remove the
card from its slot until both commands succeed.

Once it is finished, you can unplug the card and insert it in the
micro-SD card slot on the Porter board, and perform a power cycle to
start your new image on the target.

### Deployment from a Windows host

Now that the SD card image is ready, the last step required is to "flash" it
onto the SD card itself.

First, you need an SD card adapter connected to your host machine.

We will then use the `Win32DiskImager` program which we will download at
this URL:

[http://sourceforge.net/projects/win32diskimager/](http://sourceforge.net/projects/win32diskimager/)

and by clicking on this button:
![](pictures/windows_win32diskimager_1.png)

We will then install it:

![](pictures/windows_win32diskimager_2.png)
![](pictures/windows_win32diskimager_3.png)

And then start it with its icon:
![](pictures/windows_win32diskimager_4.png)

We can then click on the "blue folder" button to select our .img file
(uncompress the XZ image first using utilities like 7zip for example).

**After having verified that the drive letter on the
right matches our SD card reader**, we click on the "**Write**" button
to start the flashing process.

![](pictures/windows_win32diskimager_5.png)

This will take few minutes to copy and sync. You should not remove the
card from its slot until both commands succeed.

Once it is finished, you can unplug the card and insert it in the
micro-SD card slot on the Porter board, and perform a power cycle to
start your new image on the target.


## AGL SDK compilation and installation

Now that we have both a finalized development container and a deployed
Porter image, let us create and install the SDK (Software Development
Kit), so that we can develop new components for our image.

Going back to the container, let's generate our SDK files:
```
$ bitbake agl-demo-platform-crosssdk
```

This will take some time to complete.

Alternatively, you can download a prebuilt SDK file suitable for AGL 2.0
on automotivelinux website:
```
$ mkdir -p /xdt/build/tmp/deploy/sdk
$ cd /xdt/build/tmp/deploy/sdk
$ wget https://download.automotivelinux.org/AGL/release/chinook/3.0.2/porter-nogfx/deploy/sdk/poky-agl-glibc-x86_64-core-image-minimal-cortexa15hf-neon-toolchain-3.0.0+snapshot.sh
```

Once you have the prompt again, let's install our SDK to its final
destination. For this, run the script `install_sdk` with the SDK
auto-installable archive as argument:
```
$ install_sdk /xdt/build/tmp/deploy/sdk/poky-agl-glibc-x86_64-core-image-minimal-cortexa15hf-neon-toolchain-3.0.0+snapshot.sh
```

The SDK files should be now installed in `/xdt/sdk`:
```
$ tree -L 2 /xdt/sdk
/xdt/sdk/
|-- environment-setup-cortexa15hf-neon-agl-linux-gnueabi
|-- site-config-cortexa15hf-neon-agl-linux-gnueabi
|-- sysroots
|   |-- cortexa15hf-neon-agl-linux-gnueabi
|   |-- x86_64-aglsdk-linux
`-- version-cortexa15hf-neon-agl-linux-gnueabi
```

You can now use them to develop new services, and native/HTML
applications.

Please refer to the document entitled "Build Your 1st AGL Application"
to learn how to do this.
