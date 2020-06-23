# softioc
Docker image of an [EPICS CA](https://epics-controls.org/) softioc that uses BusyBox to slim image size to about 50MB.

## Usage
Use a volume to provide your own IOC database (or use one of the provided examples) at the container mount point */db* by specifying a directory containing a file named _softioc.db_.  

You can use a pre-built image from [DockerHub](https://hub.docker.com/r/slominskir/softioc).  For example in your own project you could use Docker Compose to specify a softioc like so:
```
services:
  softioc:
    image: slominskir/softioc:latest
    tty: true
    stdin_open: true
    hostname: softioc
    container_name: softioc
    ports:
      - "5065:5065"
    volumes:
      - ./examples/hello:/db
```


## Build
````
docker build -t softioc .
````

## Run 
```
docker run --name softioc --rm -p 5064:5064 -p 5064:5064/udp -p 5065:5065 -p 5065:5065/udp -dit -v $(pwd)/examples/hello:/db softioc
```
**Note**: Turns out there is no cross-platform way to specify a relative path with a bind mount ([Docker CLI Issue 1203](https://github.com/docker/cli/issues/1203)).  You may need to replace _$(pwd)_ with the absolute path (or perhaps _%cd%_ on Windows).  This problem is only with "docker run"; Docker compose doesn't have this issue.

**Note**: Docker security measures may prevent bind mounts.  On Windows for example you must navigate to Settings > File Sharing then authorize the directory to mount.
## Monitor
```
docker exec -it softioc camonitor hello
```
## Put
```
docker exec softioc caput hello 1
```
## Debug
```
# If not running:
docker run --entrypoint /bin/sh softioc
# If already running:
docker exec -it softioc /bin/sh
```
