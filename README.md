# kodi-standalone-service
A simple systemd service file to run kodi in standalone mode.

## Dependency List
* polkit
* systemd
* xorg-server with xorg-xinit

## Note
Most users no longer require `/etc/X11/Xwrapper.config` on the system since the created X server becomes the [controlling process](http://www.freedesktop.org/software/systemd/man/systemd.exec.html#StandardInput=) of the VT to which it is bound. Most users is not all users. There have been reports of some AMD users still requiring this file. As well, Xorg's native modesetting driver may also require this.

Again, try the service without it, but if it fails to start, create `/etc/X11/Xwrapper.config` and have it contain a single line:
```
needs_root_rights = yes
```

## Credit
Credit for the service given to the Arch Linux maintainers of the official kodi package.
