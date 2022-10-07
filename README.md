# archpkgs

> Red teaming and pentesting tools packaged for Arch Linux.

Remarks:

- packages are installed under `/opt/archpkgs`
- Python packages are installed into their own virtual environment
- packages are rebuild weekly
- for now packages are unsigned

## Setup

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
