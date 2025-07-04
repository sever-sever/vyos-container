# vyos-container
Build container VyOS images

## build
Build a container image:
```
./build.sh
```
or
```
# You can specify a URL to vyos.iso and find images here https://vyos.net/get/nightly-builds/
ISO_URL="https://example.com/vyos.iso"
docker build --build-arg VYOS_ISO_URL="$ISO_URL" -t vyos-container:latest .
```
