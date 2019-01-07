# AGL Application Framework

The binder provides a way to connect applications to required services.
It provides a fast way to securely offer APIs to applications that are
written in any language and that can run almost anywhere.

## Install the AGL Application Framework

Depending on your distribution, use the appropriate command to install
the AGL Application Framework:

* **Debian**

  ```bash
  $ sudo apt-get install agl-app-framework-binder-dev
  ```

* **openSUSE**

  ```bash
  $ sudo zypper install agl-app-framework-binder-devel
  ```

* **Fedora**

  ```bash
  $ sudo dnf install agl-app-framework-binder-devel
  ```

Regardless of the distribution, you need to have environment variables set
correctly in order to use `app-framework-binder` after installing the
framework.
Do one of the following after you have installed the framework:

* **Logout and Log Back In:**

  Logging out and then logging back in correctly sets the environment
  variables.

* **Manually Source the `AGL-app-framework-binder.sh` File:**

  Source the following command:

  ```bash
  $ source /etc/profile.d/AGL-app-framework-binder.sh
  ```

  **NOTE:**
  Creating a new session automatically sources the `AGL-app-framework-binder.sh`
  file.

## AGL Application Framework Documentation

You can learn more about the AGL Application Framework in the
"[AGL Framework Overview](../../../../../../apis_services/en/dev/reference/af-main/0-introduction.html)"
section.
