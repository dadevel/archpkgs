# archpkgs

> Red teaming and pentesting tools packaged for Arch Linux.

Remarks:

- packages are installed under `/opt/archpkgs`
- Python packages are isolated in their own virtual environments
- packages are rebuild weekly
- for now packages are unsigned

## Setup

To add the repository to your system edit `/etc/pacman.conf` and insert the `[archpkgs]` section between `[core]` and `[extra]`.

~~~ ini
...
[core]
Include = /etc/pacman.d/mirrorlist

[archpkgs]
SigLevel = Optional TrustAll
Server = https://dadevel.github.io/archpkgs

[extra]
Include = /etc/pacman.d/mirrorlist
...
~~~

Prepend `/opt/archpkgs/bin` to the `$PATH`.
For Bash append the following line to your shell profile in `~/.bashrc`:

~~~ bash
export "PATH=/opt/archpkgs/bin:$PATH"
~~~

Then add `/opt/archpkgs/bin` to the `secure_path` option of `sudo`.
`/etc/sudoers` should contain a line similar to this:

~~~
Defaults secure_path="/opt/archpkgs/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin"
~~~

Finally run the following commands and start installing packages.

~~~ bash
sudo pacman -Sy && sudo pacman -Sl archpkgs
~~~

## Development

1. Create a new directory named like the package.

    ~~~ bash
    mkdir ./example
    ~~~

2. Place a [PKGBUILD](https://wiki.archlinux.org/title/PKGBUILD) in the newly created directory that describes how the package is built.

    ~~~ bash
    vim ./example/PKGBUILD
    ~~~

3. Update the build container.

    ~~~ bash
    podman pull ghcr.io/dadevel/archpkgs-builder:latest
    ~~~

4. Build the package.

    ~~~ bash
    podman run -it --rm --userns keep-id --group-add wheel -v ./example:/build -w /build --entrypoint /bin/env ghcr.io/dadevel/archpkgs-builder:latest makepkg --syncdeps --clean --needed --noconfirm
    ~~~~

5. Install the package and verify everything is on order.

    ~~~ bash
    sudo pacman -U ./example/example-1234.5678900-1-any.pkg.tar.zst
    ~~~

6. Run [generate-workflow.py](./generate-workflow.py) to update the CI pipeline.
7. Open a [pull request](https://github.com/dadevel/archpkgs/pulls).

## Tips

If building Rust fails with a strange linker error, use `CFLAGS="${CFLAGS/-flto=auto/}" cargo build ...`.
