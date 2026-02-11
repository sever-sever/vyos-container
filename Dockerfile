##################
# Stage 1: Builder
##################
FROM ubuntu:24.04 AS builder

ARG VYOS_ISO_URL
ARG ISO_NAME=vyos.iso

RUN apt-get update && \
    apt-get install -y \
        curl \
        squashfs-tools \
        xz-utils \
        p7zip-full \
        jq && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /build

# Download VyOS ISO
RUN curl -L "$VYOS_ISO_URL" -o "$ISO_NAME"

# Extract filesystem.squashfs in a layout-agnostic way
RUN mkdir -p /tmp/iso && \
    7z e "$ISO_NAME" filesystem.squashfs -r -o/tmp/iso && \
    unsquashfs -f -d /build/rootfs /tmp/iso/filesystem.squashfs && \
    rm -rf /tmp/iso "$ISO_NAME"

# Apply VyOS container tweaks
RUN cd /build/rootfs && \
    # Set locale
    sed -i 's/^LANG=.*$/LANG=C.UTF-8/' etc/default/locale && \
    # Remove kernel / firmware (container does not boot its own kernel)
    rm -rf boot/* lib/firmware lib/modules/* root/.gnupg && \
    # VyOS expects /config symlink
    ln -s /opt/vyatta/etc/config config && \
    # Hard-disable unwanted systemd services
    ln -sf /dev/null etc/systemd/system/atopacct.service && \
    ln -sf /dev/null etc/systemd/system/hv-kvp-daemon.service && \
    # Provide hostnamectl shim for VyOS scripts
    mkdir -p usr/local/bin && \
    cat > usr/local/bin/hostnamectl <<'EOF' && \
    chmod +x usr/local/bin/hostnamectl
#!/usr/bin/env sh
case "$1" in
  --static)
    cat /etc/hostname 2>/dev/null || echo vyos
    ;;
  set-hostname)
    echo "$2" > /etc/hostname
    ;;
  *)
    echo "   Static hostname: $(cat /etc/hostname 2>/dev/null || echo vyos)"
    ;;
esac
EOF

#######################
# Stage 2: Final image
#######################
FROM scratch

COPY --from=builder /build/rootfs/ /

CMD ["/sbin/init"]
