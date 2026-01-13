# archpkgs

Red teaming and pentesting tools packaged for Arch Linux.

Remarks:

- packages are installed under `/opt/archpkgs`
- Python packages are isolated in their own virtual environments
- packages are rebuild weekly

## Setup

Run the following command to add the repo.

~~~ bash
curl -sSfL https://github.com/dadevel/archpkgs/raw/main/setup.sh | sudo bash
~~~

List all packages provided by the repo.

~~~ bash
sudo pacman -Sl archpkgs
~~~

> **Note:** Breaking changes that require manual interaction are marked in the [commit history](https://github.com/dadevel/archpkgs/commits/main/) with an `!`.

## Development

1. Clone the repo.

    ~~~ bash
    git clone --depth 1 https://github.com/dadevel/archpkgs.git
    cd ./archpkgs
    ~~~

2. Create a new directory named like the package.

    ~~~ bash
    mkdir ./example
    ~~~

3. Place a [PKGBUILD](https://wiki.archlinux.org/title/PKGBUILD) in the newly created directory that describes how the package is built.

    ~~~ bash
    vim ./example/PKGBUILD
    ~~~

4. Update the build container.

    ~~~ bash
    podman pull ghcr.io/dadevel/archpkgs-builder:latest
    ~~~

5. Build the package.

    ~~~ bash
    podman run --rm --userns keep-id -v ./example:/build ghcr.io/dadevel/archpkgs-builder:latest
    ~~~~

6. Install the package and verify everything is on order.

    ~~~ bash
    sudo pacman -U ./example/example-1234.5678900-1-any.pkg.tar.zst
    ~~~

7. Run `./generate-workflow.py` to update the CI pipeline.
8. Open a [pull request](https://github.com/dadevel/archpkgs/pulls).

## Tips

If building Rust fails with a strange linker error, use `CFLAGS="${CFLAGS/-flto=auto/}" cargo build ...`.
