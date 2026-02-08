FROM scratch AS ctx

#COPY --chmod=755 build*.sh /
#COPY --chmod=755 build_files/*.sh /
COPY --from=ghcr.io/emblem-66/bootc-config:latest build_files/ /

FROM quay.io/fedora/fedora-bootc:latest

COPY --from=ghcr.io/emblem-66/bootc-config:latest system_files/ /
COPY --from=ghcr.io/emblem-66/containers:latest system_files/ /

RUN --mount=type=bind,from=ctx,source=/,target=/ctx \
    --mount=type=cache,dst=/var/cache \
    --mount=type=cache,dst=/var/log \
    --mount=type=tmpfs,dst=/tmp \
    /ctx/build_files/build_desktop.sh

RUN bootc container lint
