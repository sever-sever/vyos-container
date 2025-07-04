# vyos-container
Build a containerized VyOS image for use in container environments.

## build
You can build the image using one of two methods:

### Method 1: Automatically fetch the latest nightly ISO

> Requires: `jq`, `curl`

```bash
./build.sh
```
check:
```
./build.sh

# Example output:
$ docker image ls | grep vyos-container
vyos-container                       latest     747f8f9e88b6   29 seconds ago   2.06GB
```

### Method 2: Manually specify the ISO URL

You can find VyOS nightly ISO images here: https://vyos.net/get/nightly-builds
```
ISO_URL="https://example.com/vyos.iso"
docker build --build-arg VYOS_ISO_URL="$ISO_URL" -t vyos-container:latest .
```

## usage
Example of usage:
```
docker run --rm -d --privileged -v /lib/modules:/lib/modules --name vyos-node1 vyos-container:latest /sbin/init
docker exec -it vyos-node1 su - vyos
```
You can use images as containers for example for [containerlab-vyos](https://github.com/sever-sever/containerlab-vyos)
