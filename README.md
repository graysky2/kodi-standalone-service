# kodi-standalone-service
A simple systemd service file to run kodi in standalone mode.

## Dependency List
* polkit
* systemd
* xorg-server with xorg-xinit

## Note
Users no longer require `/etc/X11/Xwrapper.config` on the system since the created X server becomes the [controlling process](http://www.freedesktop.org/software/systemd/man/systemd.exec.html#StandardInput=) of the VT to which it is bound.

## Credit
Credit for the service given to the Arch Linux maintainers of the official kodi package.
