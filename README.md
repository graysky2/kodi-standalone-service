# kodi-standalone-service
Systemd service units to run [Kodi](https://kodi.tv/) in standalone mode without the need for a DE.  X11, Wayland, and GBM are supported.

Which one to choose?  Depends...

In terms of functionality, X11 is probably the most mature and feature rich.  Wayland is next in line and should be considered on-par with X11, however, a known limitation of Wayland is having the resolution and frame rate set in the compositor rather than in kodi's GUI.  As well, Wayland currently does not support VT switching.  GBM has some known features it lacks compared the X11 and Wayland.  A complete list can be found in [Kodi issue 14876](https://github.com/xbmc/xbmc/issues/14876).

Another factor that may affect choice is the number of dependencies required to run which will vary distro-to-distro.

## Installation
### Arch Linux
Arch Linux users can find a PKGBUILD in the [AUR](https://aur.archlinux.org/packages/kodi-standalone-service) that will take care of everything. Simply install and use.

### ARM distros
Users of ARM distros such as Arch ARM, Raspberry Pi OS (formerly Raspbian), etc. should NOT use these files since their official corresponding kodi packages supply their own version of a service. If you are knowledgeable enough with your distro, feel free to use/modify.

### Ubuntu
For the kodi user to access devices on `/dev/ttyxxxx`, users will need to edit `init/sysusers.conf` and uncomment the line corresponding to enable membership in the dialout group.

### Other distros
Users of other distros should install the following files:

* `init/*.service`  to `/usr/lib/systemd/system/`
* `init/sysusers.conf` to `/usr/lib/sysusers.d/`, then run `systemd-sysusers`
* `init/tmpfiles.conf` to `/usr/lib/tmpfiles.d/`, then run `systemd-tmpfiles --create`

Note that the kodi user's home directory is `/var/lib/kodi/` in this example, NOT `/home/kodi/` like a regular user.

## Usage
Simply [start/enable](https://wiki.archlinux.org/index.php/Systemd#Using_units) the requisite service.

## Dependencies
* kodi (x11 or wayland or gbm)
* polkit
* xorg-server and xorg-xinit (for running x11)
* libinput and cage (for running wayland)
* libinput (for running gbm)

## Acknowledgments
Much of the credit for this service goes to the Arch Linux maintainers of the official kodi package. Note that they removed it upon the [1.16-1 release of Xorg](https://git.archlinux.org/svntogit/community.git/commit/trunk?h=packages/xbmc&id=9763c6d32678f3a3f45c195bfae92eee209d504f).

## Tips and Tricks
### Service not starting
Most users should not need `/etc/X11/Xwrapper.config` since the created X server becomes the [controlling process](http://www.freedesktop.org/software/systemd/man/systemd.exec.html#StandardInput=) of the VT to which it is bound. Most users does not mean all users. There have been reports of some AMD users still requiring this file. As well, users of Xorg's native modesetting driver may also require it.

The recommendation is to first try starting `kodi.service` without it, but if the service fails to start X, you may need to create `/etc/X11/Xwrapper.config` which should contain the following:
```
needs_root_rights = yes
```

### Running Kodi web service on a privileged port
Users wishing to run the kodi web service on a privileged port (i.e. <1024) can simply use a [systemd drop-in](https://wiki.archlinux.org/index.php/Systemd#Drop-in_files) modification as follows:
```
[Service]
AmbientCapabilities=CAP_NET_BIND_SERVICE
```
