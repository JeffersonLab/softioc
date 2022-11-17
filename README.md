# softioc [![Docker](https://img.shields.io/docker/v/jeffersonlab/softioc?sort=semver&label=DockerHub)](https://hub.docker.com/r/jeffersonlab/softioc)
Docker image of an [EPICS CA](https://epics-controls.org/) softioc that uses BusyBox to slim image size to about 20MB.

---
- [Overview](https://github.com/JeffersonLab/softioc#overview)
- [Quick Start with Compose](https://github.com/JeffersonLab/softioc#quick-start-with-compose)
- [Install](https://github.com/JeffersonLab/softioc#install)
- [Configure](https://github.com/JeffersonLab/softioc#configure)
- [Build](https://github.com/JeffersonLab/softioc#build)
- [Release](https://github.com/JeffersonLab/softioc#release)
---

## Overview
The container currently uses EPICS version 3.15.8.

## Quick Start with Compose
1. Grab project
```
git clone https://github.com/JeffersonLab/softioc
cd softioc
```
2. Launch [Compose](https://github.com/docker/compose)
```
docker compose up
```
3. Monitor for PV named hello
```
docker exec -it softioc camonitor hello
```
4. CAPUT value to hello
```
docker exec softioc caput hello 1
```

## Install
```
docker pull jeffersonlab/softioc
```

## Configure
The container entrypoint is the softIoc application and the default arguments instruct the IOC to use the database from the bind mount point */db* containing a file named _softioc.db_.  Use a volume to provide your own IOC database (or use one of the provided examples) at this mount point:
```
docker run --name softioc -it -v $(pwd)/examples/hello:/db softioc
```
Override the arguments to the softIoc command as necessary:
```
docker run --name softioc -it -v /some/where/else:/db softioc -m user=pklaus -d /db/my.db
``` 
In order to access the softioc container channel access ports on the localhost you must publish the exposed ports with the **-p** flag:
```
docker run --name softioc -it -v $(pwd)/examples/hello:/db -p 5064:5064/tcp -p 5064:5064/udp -p 5065:5065/tcp -p 5065:5065/udp softioc
```

**Note**: Turns out there is no cross-platform way to specify a relative path with a bind mount ([Docker CLI Issue 1203](https://github.com/docker/cli/issues/1203)).  You may need to replace _$(pwd)_ with the absolute path (or perhaps _%cd%_ on Windows).  This problem is only with "docker run"; Docker compose doesn't have this issue.

**Note**: Docker security measures may prevent bind mounts.  On Windows for example you must navigate to Settings > File Sharing then authorize the directory to mount.

**Debug tips**:
```
# If not running:
docker run --entrypoint /bin/sh softioc
# If already running:
docker exec -it softioc /bin/sh
# --OR attach to EPICS softIoc PID 1 entrypoint process directly
docker attach softioc
# To detach you must use escape sequence CTRL+p CTRL+q
```

## Build
```
git clone https://github.com/JeffersonLab/softioc.git
cd softioc
docker build -t softioc .
```

## Release
1. Run docker build and tag release
2. Push to DockerHub

