# 3. Installing the Binder Daemon

The Application Framework Binder Daemon (`afb-daemon`), which is a part of
the AGL Application Framework, provides a way to connect applications to
required services.
It provides a fast way to securely offer APIs to applications that are
written in any language and that can run almost anywhere.

You can learn more about the AGL Application Framework in the
"[AGL Framework Overview](../../../../../../apis_services/en/dev/reference/af-main/0-introduction.html)"
section.
You can learn more about the `aft-daemon` in the
"[Binder Overview](../../../../../../apis_services/en/dev/reference/af-binder/afb-overview.html)"
section.

## Installing on Debian

Use the following commands if your native Linux machine uses the Debian
distribution:

```bash
$ sudo apt-get install agl-app-framework-binder-dev
```

## Installing on OpenSUSE

Use the following commands if your native Linux machine uses the OpenSUSE
distribution:

  ```bash
  $ sudo zypper install agl-app-framework-binder-devel
  ```

## Installing on Fedora

Use the following commands if your native Linux machine uses the Fedora
distribution:

  ```bash
  $ sudo dnf install agl-app-framework-binder-devel
  ```

## Setting Your Environment Variables

Regardless of your system's distribution, you need to set certain environment
variables correctly in order to use the daemon (i.e. `app-framework-binder`).

Commands that define and export these environment variables exist in the
`/etc/profile.d/AGL_app-framework-binder.sh` file, which is created when
you install the daemon:

```bash
export LD_LIBRARY_PATH=/opt/AGL/lib/x86_64-linux-gnu:${LD_LIBRARY_PATH}
export LIBRARY_PATH=/opt/AGL/lib/x86_64-linux-gnu:${LIBRARY_PATH}
export PKG_CONFIG_PATH=/opt/AGL/lib/x86_64-linux-gnu/pkgconfig:${PKG_CONFIG_PATH}
export PATH=/opt/AGL/bin:${PATH}
```

You can make sure thest environment variables are correctly set by doing
one of the following:

* **Logout and Log Back In:**

  Logging out and then logging back in correctly sets the environment
  variables.

* **Manually Source the `AGL_app-framework-binder.sh` File:**

  Source the following command:

  ```bash
  $ source /etc/profile.d/AGL_app-framework-binder.sh
  ```

  **NOTE:**
  Creating a new session automatically sources the `AGL_app-framework-binder.sh`
  file.
