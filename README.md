# kodi-standalone-service
A simple systemd service file to run kodi in standalone mode.

## Dependency List
* polkit
* systemd
* xorg-server with xorg-xinit

## Note
Most users no longer require `/etc/X11/Xwrapper.config` on the system since the created X server becomes the [controlling process](http://www.freedesktop.org/software/systemd/man/systemd.exec.html#StandardInput=) of the VT to which it is bound. Most users does not mean all users. There have been reports of some AMD users still requiring this file. As well, users of Xorg's native modesetting driver may also require it.

The recommendation is to first try starting `kodi.service` it, but if the service fails to start X, create `/etc/X11/Xwrapper.config` and have it contain the following single line:
```
needs_root_rights = yes
```

## Credit
Note that this service was provided by the Arch Linux maintainers of the official kodi package, but was removed upon the [1.16-1 release of Xorg](https://git.archlinux.org/svntogit/community.git/commit/trunk?h=packages/xbmc&id=9763c6d32678f3a3f45c195bfae92eee209d504f).
