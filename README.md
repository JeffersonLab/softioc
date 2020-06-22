# softioc
Docker image of an EPICS CA softioc

## Build
````
docker build -t softioc .
````

## Run 
```
docker run --name softioc --rm -p 5064:5064 -p 5064:5064/udp -p 5065:5065 -p 5065:5065/udp -dit -v $(pwd)/examples/hello:/user/local/epics/softioc/db softioc
```
**Note**: On Windows the above volume bind command won't work.  Turns out there is no cross-platform way to specify a relative path with a bind mount [Docker CLI Issue 1203](https://github.com/docker/cli/issues/1203).  You must replace $(pwd) with the absolute path.  This problem is only with "docker run".  Docker compose doesn't have this issue.
## Monitor
```
docker exec -it softioc camonitor hello
```
## Put
```
docker exec caput hello 1
```
