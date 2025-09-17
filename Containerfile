# Based on fedora-bootc image
FROM quay.io/fedora/fedora-bootc:latest

RUN mkdir -p /var/roothome /var/home /data

# Automatic Updates DNF
RUN echo "" \
 && sed -i 's|ExecStart=/usr/bin/bootc upgrade --apply --quiet|ExecStart=/usr/bin/bootc upgrade --quiet|' /usr/lib/systemd/system/bootc-fetch-apply-updates.service \
 && systemctl enable bootc-fetch-apply-updates.timer \
 && echo ""

# Tailscale
RUN echo "" \
 && dnf install -y dnf5-plugins \
 && dnf config-manager addrepo --from-repofile=https://pkgs.tailscale.com/stable/fedora/tailscale.repo \
 && dnf install -y tailscale \
 && systemctl enable tailscaled.service sshd.service \
 && dnf autoremove -y \
 && dnf clean all \
 && rm -rf /var/* /tmp/* \
 && echo "" 

# Flatpak
RUN echo "" \
 && dnf install -y flatpak \
 && dnf autoremove -y \
 && dnf clean all \
 && rm -rf /var/* /tmp/* \
 && echo "" 

# GNOME
RUN echo "" \
 && dnf install -y \
    gnome-shell \
    gdm \
    nautilus \
    ptyxis \
    adw-gtk3-theme \
 && systemctl set-default graphical.target \
 && dnf autoremove -y \
 && dnf clean all \
 && rm -rf /var/* /tmp/* \
 && echo "" 

# Finish
RUN echo "" \
 && rm -rf /var/* /tmp/* \
 && ostree container commit \
 && bootc container lint
