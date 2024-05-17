FROM docker.io/library/archlinux:latest
RUN pacman -Syu --noconfirm base base-devel git
RUN useradd --create-home --groups wheel builder && \
echo '%wheel ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/builder
# disarm systemd
RUN ln -s /usr/bin/true /usr/local/bin/systemctl
# disable debug builds
RUN echo 'OPTIONS=(strip !docs !libtool !staticlibs emptydirs zipman purge !debug lto)' > /etc/makepkg.conf.d/override.conf
COPY ./entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD []
