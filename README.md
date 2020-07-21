# First off:

This script uses code from [dragon](https://github.com/DragonBuild/Installer) and my own code. I would like to heavily thank Kritanta for open sourcing dragon and DragonBuild's install script, as this project wouldn't have been possible without it.

# How to install

```bash <(curl -s https://raw.githubusercontent.com/ajaidan0/theosscript/master/setup.sh)```

# Commands

THEOS
usage: theos [commands]

BUILDING
b | build | Builds a package. (Put any build commands **before** the b flag (i.e. theos final do build))

MISC
ch | checkra1n | Opens checkra1n.

s | ssh | SSH to the IP that you selected.

r | respring | Resprings on your development device.

dr | devicerun | Runs selected command on your development device.

rl | rlog | Opens RLog.

CONFIG
u | update | Updates Theos.

n | nic | Runs nic.pl.

v | version | Displays the script's version.

INSTALL
cl | clang | Installs the latest clang toolchain

inst | install | Installs Theos.

# Install Theos

Once you have ran ```setup.sh```, run ```theos -cl```. After that is finished, run ```theos -inst```. Congratulations, theos is now installed!

Note: Best used in conjunction with [mpi](https://github.com/samoht9277/mpi)
