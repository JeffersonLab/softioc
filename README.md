# softioc
Docker image of an EPICS CA softioc

## Build
````
docker build -t softioc .
````

## Run 
```
docker run --name softioc --rm -p 5064:5064 -p 5064:5064/udp -p 5065:5065 -p 5065:5065/udp -dit -v ./examples:/user/local/epics/softioc/db softioc
```
