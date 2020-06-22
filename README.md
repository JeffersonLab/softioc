# softioc
Docker image of an EPICS CA softioc

## Build
````
docker build -t softioc .
````

## Run 
```
docker run --name softioc --rm -p 5064:5064 -p 5064:5064/udp -p 5065:5065 -p 5065:5065/udp -dit -v $(pwd)/examples/hello:/usr/local/epics/softioc/db softioc
```
**Note**: On Windows the above volume bind command won't work.  Turns out there is no cross-platform way to specify a relative path with a bind mount [Docker CLI Issue 1203](https://github.com/docker/cli/issues/1203).  You must replace $(pwd) with the absolute path (or perhaps %cd%).  This problem is only with "docker run"; Docker compose doesn't have this issue.

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
docker run --entrypoint /bin/bash softioc
# If already running:
docker exec -it softioc /bin/bash
```
