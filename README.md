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

4. Build the package and run its runtime test, if provided.

    ~~~ bash 

    podman run --rm --pull=always --userns keep-id -v ./example:/build ghcr.io/dadevel/archpkgs-builder:latest
    ~~~

    You can also use the `build-package.sh` script:

    ~~~ bash
    CONTAINER_ENGINE=podman ./build-package.sh example
    ~~~

    Run the scripts from the repository root. They use Docker by default. So you have to set `CONTAINER_ENGINE=podman` to use Podman.

    With rootless Podman, the build script maps the container's `builder` user
    to your host user so the package directory stays writable. `makepkg` may
    update `pkgver` and `pkgrel` in the mounted `PKGBUILD` during the build.

5. Install the package and verify everything is in order.

    ~~~ bash
    sudo pacman -U ./example/example-1234.5678900-1-any.pkg.tar.zst
    ~~~

6. Run `./generate-workflow.py` to update the CI pipeline.
7. Open a [pull request](https://github.com/dadevel/archpkgs/pulls).

## Runtime tests

Place an optional Bash `test.sh` alongside a package's `PKGBUILD`. Use `set -euo pipefail` so a failing command fails the test. After a successful build, `build-package.sh` automatically invokes `test-package.sh`, which runs the package's `test.sh` if it exists. 

For example, build and test aardwolf:

~~~ bash
CONTAINER_ENGINE=podman ./build-package.sh aardwolf
~~~

To test an already built package without rebuilding:

~~~ bash
CONTAINER_ENGINE=podman ./test-package.sh aardwolf
~~~

A failed test lets the build script fail and prevents the CI package artifact from being uploaded.

## Tips

If building Rust fails with a strange linker error, use `CFLAGS="${CFLAGS/-flto=auto/}" cargo build ...`.
