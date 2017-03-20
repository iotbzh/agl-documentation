# Initializing SDK environment and templates

### Initializing the SDK environment

*(This document assumes that you are logged inside the **bsp-devkit** Docker
container, used to produce Porter BSP image and AGL SDK in the
previous **"Image and SDK for porter"** document)*

To be able to use the toolchain and utilities offered by AGL SDK, it is
necessary to source the proper setup script. This script is in the SDK
root folder and is named `/xdt/sdk/environment-setup-*` (full name
depends on the target machine)

For Porter board, we source the required SDK environment variables like
this:
```
$ source /xdt/sdk/environment-setup-cortexa15hf-neon-agl-linux-gnueabi
```

To verify that it succeeded, we should obtain a non-empty result for
this command:
```
$ echo $CONFIG_SITE | grep sdk /xdt/sdk/site-config-cortexa15hf-neon-agl-linux-gnueabi
```

### Application categories

We provide multiple development templates for the AGL SDK:

- Service

  A Service is a headless background process, allowing Bindings to expose
  various APIs accessible through the transports handled by the application
  framework, which are currently:
  - [HTTP REST (HTTP GET, POST...)](https://en.wikipedia.org/wiki/Representational_state_transfer)
  - [WebSocket](https://en.wikipedia.org/wiki/WebSocket)
  - [D-Bus](https://www.freedesktop.org/wiki/Software/dbus/)

- Native application

  A Native application is a compiled application, generally written in C/C++,
  accessing one or more services, either by its own means or using a helper
  library with HTTP REST/WebSocket capabilities.

  *(our template is written in C and uses the "libafbwsc" helper library
  available in the app-framework-binder source tree on AGL Gerrit)*

- HTML5 application

  An HTML5 application is a web application, generally written with a framework
  (AngularJS, Zurb Foundation...), accessing services with its built-in HTTP
  REST/WebSocket capabilities.

- QML application

  An QML application is a Qt application written in QML/QtQuick descriptive
  language, accessing a service with its built-in HTTP REST/WebSocket
  capabilities.

- Hybrid application (composed of a backend and a frontend)

  A Hybrid application contains at the same time (an) **Application-specific
  Binding(s)** as backend(s) and a **User Interface** (Native, HTML5, QML ...)
  as a frontend.

  This is probably the most pertinent real-world case, since it allows
  developers to provide capabilities through Bindings, and an end-user
  experience through the UI. For instance, a GPS Binding giving device
  localization status, and a HTML5 GPS frontend displaying it on the screen.

### Getting application templates

Application Framework Templates live in a dedicated Git Repository,
currently hosted on GitHub at the following address:

[https://github.com/iotbzh/app-framework-templates](https://github.com/iotbzh/app-framework-templates)

To get the templates in our development container, let us simply clone
the source repository:
```
$ cd ~
$ git clone https://github.com/iotbzh/app-framework-templates
Cloning into 'app-framework-templates'...
remote: Counting objects: 315, done.
remote: Compressing objects: 100% (62/62), done.
remote: Total 315 (delta 25), reused 0 (delta 0), pack-reused 250
Receiving objects: 100% (315/315), 512.81 KiB | 284.00 KiB/s, done.
Resolving deltas: 100% (125/125), done.
Checking connectivity... done.
```

### Organization of templates

Templates are provided with the following layout:
```
$ tree -L 2 app-framework-templates
app-framework-templates
|-- build_all
|-- demos
| |-- cpu-hybrid-html5
| `-- cpu-hybrid-qml
`-- templates
 |-- html5
 |-- hybrid-html5
 |-- hybrid-qml
 |-- native
 |-- qml
 `-- service
```

There are 2 main categories in the repository:

- **demos/:** projects demonstrating fully-working applications, that
  are still simple enough to be used as starting points.
- **templates/:** one subdirectory per template type, see folder name.

Here are some details on the files encountered in the projects:

- **CMakeLists.txt**: our templates use CMake for automatic
  configuration and building. In your projects, you can of course
  adapt templates to use your preferred solution (Autoconf, Scons...).
- **gulpfile.js**: these are some kind of `Makefiles` used by the
  Gulp tool. g*ulp *is often used in HTML5 projects as it is able to
  execute all needed tasks to process web source files (JavaScript,
  CSS, HTML templates, images...) and create a directory suitable for
  deployment on a website.
- **package.json**: this is a Node.js file used to specify project
  dependencies. Basically, `gulp` and `gulpfile.js` will download and
  install all packages mentioned here to assemble the HTML5 project
  during the "npm install" step.
- **config.xml(.in)**: XML configuration file required by the
  application framework. This file is mandatory for an AGL Application
  to be installed and launched by the framework.
- **export.map**: for Bindings (a.k.a. shared libraries) only, this
  file must contain a list of exported API verbs. Only the symbols
  specified in this export file will be accessible at runtime. So
  *export.map* should contain all verbs you intend to provide in your
  Binding.
