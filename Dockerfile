# Stage 1: Builder
FROM ubuntu:24.04 AS builder

ARG VYOS_ISO_URL
ARG ISO_NAME=vyos.iso

RUN apt-get update && \
    apt-get install -y \
        curl \
        squashfs-tools \
        xz-utils \
        p7zip-full && \
    mkdir -p /build/rootfs /build/unsquashfs

WORKDIR /build

RUN curl -L "$VYOS_ISO_URL" -o "$ISO_NAME"

# Extract the filesystem.squashfs from the ISO using 7z
RUN 7z x "$ISO_NAME" live/filesystem.squashfs -o/tmp && \
    unsquashfs -f -d /build/unsquashfs /tmp/live/filesystem.squashfs && \
    rm -rf /tmp/live /build/"$ISO_NAME"


# Stage 2: Final image
FROM scratch

COPY --from=builder /build/unsquashfs/ /

CMD ["/sbin/init"]
