# vyos-container
Check build container images

## build
Build image:
```
./build.sh
```
or
```
# You can find images here https://vyos.net/get/nightly-builds/
ISO_URL="https://example.com/vyos.iso"
docker build --build-arg VYOS_ISO_URL="$ISO_URL" -t vyos-container:latest .
```
