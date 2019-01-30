# 7. Optionally Using CANdevStudio


With todays connected automobiles, most automotive projects need to
have access to the Controller Area Network (CAN) bus.
Plenty of commercial frameworks exist that provide CAN software 
stacks, hardware tools, and software tools that allow developers to 
create CAN networks.
The Controller Area Network (CAN) Development Studio (CANdevStudio)
is a cost-effective replacement for CAN simulation software.
CANdevStudio lets you simulate CAN signals such as ignition status,
doors status, or reverse gear by every automotive developer.

CANdevStudio works as a stand-alone application without hardware or
can be used with several CAN hardware interfaces:

* Microchip
* Vector
* PEAK-Systems
* vcan (stand-alone)
* cannelloni (stand-alone)

You can find more information on using CANdevStudio in the AGL development
environment in the 
"[CANdevStudio Quickstart](../../../../../../apis_services/en/dev/reference/candevstudio/docs/1_Usage.html)".

**WRITER NOTES**:

  * CANdevStudio is a
    [Qt-based](https://en.wikipedia.org/wiki/Qt_(software)) application.
    Qt (pronounced "cute")
    Qt is a cross-platform application framework and widget toolkit for 
    creating classic and embedded graphical user interfaces, and applications 
    that run on various software and hardware platforms with little or no 
    change in the underlying codebase while still being a native application 
    with native capabilities and speed.

  * [CAN Bus](https://elinux.org/CAN_Bus) is an ISO standard bus originally 
    developed for vehicles.
    It manages the Chassis Electrical System Control and is responsible
    for critical activities like engine electrical, and skid control.
    This system is also used to provide vehicle diagnostic information
    for maintenance.

  * CANDevStudio is maintained by Remigiusz Kołłątaj of Poland and working
    for Mobica.
    CANdevStudio is not required for AGL.
    It is a third-party application that is probably the most cost-effective
    way to simulate CAN Bus behavior used in the connected car.
    AGL provides the CANdevStudio binary for the UI as a convenience.
    It appears that binaries on the upstream CANdevStudio project might
    be limited to Ubuntu 16.04 only.

  * The best overview of the CANdevStudio is probably the README.md file 
    in the repo - [README.md](https://github.com/GENIVI/CANdevStudio/blob/master/README.md)

The remainder of this section describes the commands needed to install
XDS based on your native Linux system.

## Installing on Debian

Use the following commands if your native Linux machine uses the
Debian distribution:

```bash
sudo apt-get install CANdevStudio
```

## Installing on OpenSUSE

Use the following commands if your native Linux machine uses the
OpenSUSE distribution:

```bash
sudo zypper install CANdevStudio
```

## Installing on Fedora

Use the following commands if your native Linux machine uses the
Fedora distribution:


```bash
sudo dnf install CANdevStudio
```
