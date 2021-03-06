# Trying out the templates

In this section, we describe how to build the various templates, how to
package them and finally how to deploy and run them on the target board.

Every template is stored in a single directory and is independent of the
rest of the tree: each template can be used as a foundation for a fresh
new application.

For deployment, we assume that the target board is booted with an AGL
image and available on the network. Let us use the `BOARDIP` variable
for the board IP address (replace by appropriate address or hostname)
and test the SSH connection:

```bash
$ export BOARDIP=1.2.3.4
$ ssh root@$BOARDIP cat /etc/os-release
ID="poky-agl"
NAME="Automotive Grade Linux"
VERSION="1.0+snapshot-20160717 (master)"
VERSION_ID="1.0+snapshot-20160717"
PRETTY_NAME="Automotive Grade Linux 1.0+snapshot-20160717 (master)"
```

## Building

All operations are executed inside the Docker "Devkit" container. For
convenience, a build script named `autobuild` can build template and
package at once.

Compile the service:

```bash
$ cd ~/helloworld-service/
$ ./conf.d/autobuild/agl/autobuild package
-- The C compiler identification is GNU 6.3.1
-- The CXX compiler identification is GNU 6.3.1
[snip]
[100%] Generating helloworld-service.wgt
NOTICE: -- PACKING widget helloworld-service.wgt from directory /home/claneys/Workspace/Sources/IOTbzh/helloworld-service/build/package
++ Install widget file using in the target : afm-util install helloworld-service.wgt
```

This produced a `helloworld-service.wgt` package. Let us copy it to the
target:

```bash
$ scp helloworld-service.wgt root@$BOARDIP:~/
helloworld-service.wgt                           100%   24KB   24.3KB/s   00:00
```

## Installing on the target

And then, in a separate window, log in to the target board:

```bash
ssh root@$BOARDIP
```

and install our packages:

```bash
$ afm-util install helloworld-service.wgt
{ "added": "helloworld-service@1.0" }
```

We can verify that they were correctly installed by listing all
available applications:

```bash
$ afm-util list
[ { "description": "The name says it all!", "name": "helloworld-service", "shortname": "", "id": "helloworld-service@1.0", "version": "1.0", "author": "Stephane Desneux <sdx@iot.bzh>", "author-email": "", "width": "", "height": "" } ]
```

## Running the template

Even if the template is mostly skeleton application, we can still
start them and see them in action.

Once installed Application Framework created appropriate systemD unit file
to get able to manage the application. You can directly connect to the unix
socket to get connected to the application template, it will be launched
automatically if not already started.

when systemD receives a connection to an existing socket that it handles, it
launch the associated application using its service unit. Service unit is
generated by wgtpkg-unit at installation, its content depends of the
`config.xml` configuration file located in its specific directory
(`/var/local/lib/afm/applications/<appname>/<version>/config.xml`).

Generation is controlled by the global `/etc/afm/afm-unit.conf` config
file.

This file defines how various applications types are handled by the
system and application framework.

### Run and connect to the service

Let us first run the Service:

```bash
$ afm-util run helloworld-service@1.0
1
```

Then confirm it is running:

```bash
$ afm-util ps
[ { "runid": 20091, "pids": [ 20091 ], "state": "running", "id": "helloworld-service@1.0" } ]
$ ps -ef | grep afb
ps -ef|grep afb
root      5764  3876  0 15:34 ?        00:00:00 /usr/bin/afb-daemon --rootdir=/var/local/lib/afm/applications/helloworld-service/1.0 --workdir=/home/root/app-data/helloworld-service --roothttp=htdocs --binding=/var/local/lib/afm/applications/helloworld-service/1.0/lib/afb-helloworld.so --ws-server=sd:helloworld --no-httpd
```

We can see that an afb-daemon (Binder) process for this Service started
and get a websocket server up, meaning that an unix socket is available
from directory `/var/run/user/<uid>/apis/ws` named as the api name.
We also see that the shared library as been loaded as binding using `binding`
flag.

A Service has no user interface, but we can still try the binding API.
Looking at the Service source code, we see that the Service implements
an API named '**helloworld**' providing a `ping` verb. Let us try to launch
a websocket client connected to that service invoking the `ping` verb.

First as we don't know security token used to launch the service, we still can
connect to through the unix socket and use the websocket client demo:

```bash
$ afb-daemon --ws-client=/var/run/user/0/apis/ws/helloworld --port=12345 --token='' --roothttp=.
$ afb-client-demo ws://localhost:12345/api?token= helloworld ping
ON-REPLY 1:helloworld/ping: {"response":"Make the World great again!","jtype":"afb-reply","request":{"status":"success","info":"Ping Binder Daemon tag=pingSample count=2 query=\"null\"","uuid":"2edcfee9-943b-40d7-a0c6-08a31141f045"}}
```
