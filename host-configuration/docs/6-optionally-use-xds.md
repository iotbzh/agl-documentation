# 6. Optionally Using XDS

Once you have built and run your micro-service successfully using your 
native Linux system, you should consider using the 
X(Cross) Development System (XDS) to cross-compile
and port your AGL image to your target hardware.

When your project and your development environment are working smoothly
in your native environment, you should be able to compile, run, and 
debug the same source code either locally or on remote hardware through
XDS.

## XDS Overview

AGL's XDS provides a multi-platform cross development tool with 
[near-zero](https://en.wikipedia.org/wiki/Zero_Install) installation.

XDS consists of three parts that you need to install:

* **`xds-agent`**: A client/agent that runs on your local system and is
  used for development in the XDS environment.

* **`xds-cli`**: A command-line tool that controls or interfaces with
  XDS.
  You can use this tool in addition to the XDS Dashboard.

* **`xds-gdb`**: A wrapper around the 
  [GNU Debugger](https://en.wikipedia.org/wiki/GNU_Debugger) (GDB) used 
  within XDS.

For more complete overview information about XDS, see the
"[Getting Started for Users](../../xds/part-1/0_Abstract.html)" 
section.

The remainder of this section describes the commands needed to install
XDS based on your native Linux system.

## Installing on Debian

Use the following commands if your native Linux machine uses the
Debian distribution:

```bash
sudo apt-get install agl-xds-agent agl-xds-cli agl-xds-gdb
```

## Installing on OpenSUSE

Use the following commands if your native Linux machine uses the
OpenSUSE distribution:

```bash
sudo zypper install agl-xds-agent agl-xds-cli agl-xds-gdb
```

## Installing on Fedora

Use the following commands if your native Linux machine uses the
Fedora distribution:

```bash
sudo dnf install agl-xds-agent agl-xds-cli agl-xds-gdb
```
