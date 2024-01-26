FROM docker.io/library/archlinux:latest
RUN pacman -Syu --noconfirm base base-devel git
RUN useradd --create-home --groups wheel builder && \
echo '%wheel ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/builder
# disarm systemd
RUN ln -s /usr/bin/true /usr/local/bin/systemctl
COPY ./entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD []
