# archpkgs

Run the following commands as root to add the repository to your system.

~~~ bash
cat << EOF >> /etc/pacman.conf
[archpkgs]
SigLevel = Optional TrustAll
Server = https://dadevel.github.io/archpkgs
EOF
pacman -Sy
pacman -Sl archpkgs
~~~

All packages are installed under `/opt/archpkgs` to avoid conflicts.
For easy access add `export "PATH=/opt/archpkgs/bin:$PATH"` to your shell profile and prepend `/opt/archpkgs/bin` to the `secure_path` option in `/etc/sudoers`.

## Development

Rebuild and install all packages.

~~~ bash
docker build -t localhost/archpkgs-builder .
rm ./*/*.pkg.tar.zst
./build-pkgs.sh
ls ./*/*.pkg.tar.zst
sudo pacman -U ./*/*.pkg.tar.zst
~~~
