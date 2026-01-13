FROM docker.io/library/archlinux:latest AS base
RUN pacman -Syu --noconfirm base base-devel git
RUN useradd --create-home --groups wheel builder && echo '%wheel ALL=(ALL:ALL) NOPASSWD: ALL' > /etc/sudoers.d/builder

FROM base AS paru
USER builder
WORKDIR /build
RUN git clone --depth 1 https://aur.archlinux.org/paru.git . && makepkg -s --noconfirm && rm -f ./paru-debug-*-x86_64.pkg.tar.zst && mv ./paru-*-x86_64.pkg.tar.zst ./paru.pkg.tar.zst

FROM base
COPY --from=paru /build/paru.pkg.tar.zst /tmp/
RUN cd /tmp && pacman -U --noconfirm ./paru.pkg.tar.zst && rm ./paru.pkg.tar.zst
# disarm systemd
RUN ln -s /usr/bin/true /usr/local/bin/systemctl
# disable debug builds
RUN echo 'OPTIONS=(strip !docs !libtool !staticlibs emptydirs zipman purge !debug lto)' > /etc/makepkg.conf.d/override.conf
USER builder
WORKDIR /build
ENTRYPOINT ["paru"]
CMD ["--build", ".", "--noconfirm"]
