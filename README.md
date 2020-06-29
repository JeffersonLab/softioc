# softioc
Docker image of an [EPICS CA](https://epics-controls.org/) softioc that uses BusyBox to slim image size to about 20MB.

## Usage
### Docker Run
The container entrypoint is the softIoc application and the default arguments instruct the IOC to use the database from the bind mount point */db* containing a file named _softioc.db_.  Use a volume to provide your own IOC database (or use one of the provided examples) at this mount point: 
```
docker run --name softioc -it -v $(pwd)/examples/hello:/db softioc
```
Override the arguments to the softIoc command as necessary:
```
docker run --name softioc -it -v /some/where/else:/db softioc -m user=pklaus -d /db/my.db
``` 
**Note**: Turns out there is no cross-platform way to specify a relative path with a bind mount ([Docker CLI Issue 1203](https://github.com/docker/cli/issues/1203)).  You may need to replace _$(pwd)_ with the absolute path (or perhaps _%cd%_ on Windows).  This problem is only with "docker run"; Docker compose doesn't have this issue.

**Note**: Docker security measures may prevent bind mounts.  On Windows for example you must navigate to Settings > File Sharing then authorize the directory to mount.

### Docker Compose
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
# --OR attach to EPICS softIoc PID 1 entrypoint process directly
docker attach softioc
# To detach you must use escape sequence CTRL+p CTRL+q
```
