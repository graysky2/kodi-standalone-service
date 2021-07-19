# kodi-standalone-service
Systemd service units to run [Kodi](https://kodi.tv/) in standalone mode without the need for a DE.  X11, Wayland, and GBM are supported.

Which one to choose?

In terms of functionality, X11 is probably the most mature and feature rich.  Wayland is next in line and should be considered on-par with X11, however, a known limitation of Wayland is having the resolution and frame rate set in the compositor rather than in kodi's GUI.  As well, Wayland currently does not support VT switching.  GBM has some known features it lacks compared the X11 and Wayland.  A complete list can be found in [Kodi issue 14876](https://github.com/xbmc/xbmc/issues/14876).

Another factor that may affect choice is the number of dependencies required to run which will vary distro-to-distro.

## Installation
### Arch Linux
Arch Linux users (likely users of Arch clones) can find a PKGBUILD in the [AUR](https://aur.archlinux.org/packages/kodi-standalone-service) that will take care of everything. Simply install and use.

### Other distros/manual installation
Users of other distros can just run `make install` as the root user.  Then, as the root user, run:

* `systemd-sysusers`
* `systemd-tmpfiles --create`

Note that the kodi user's home directory is `/var/lib/kodi/` in this example, NOT `/home/kodi/` like a regular user.

### Dependencies
Note that I list some dependencies below that the Arch package already has listed as dependencies.  This is to help users of other distros whose kodi packages may not have these listed.  If you're installing this from the AUR package listed above, just pay attention to pacman's post-install message which calls out the Arch-specific `optdepends` needed for the various service files to work.

* kodi (>=19.1 on Arch Linux, lower versions may work with other distros)
* cage, libinput, and xorg-xwayland (for running wayland)
* libinput (for running gbm)
* xorg-server and xorg-xinit (for running x11)

#### Notes for users of non-Arch Linux distros
1. Users of Ubuntu ≥20.0 will need to copy the contents of [sysusers.conf](https://github.com/graysky2/kodi-standalone-service/blob/master/x86/init/sysusers.conf) to `/etc/sysusers.d/kodi.conf` and uncomment the line adding kodi user to the `render` group.

2. Users of Ubuntu wishing the kodi user to access devices on `/dev/ttyxxxx`, will need to copy the contents of [sysusers.conf](https://github.com/graysky2/kodi-standalone-service/blob/master/x86/init/sysusers.conf) to `/etc/sysusers.d/kodi.conf` and uncomment the line adding the kodi user to the `dialout` group.

## Usage
Simply [start/enable](https://wiki.archlinux.org/index.php/Systemd#Using_units) the requisite service.

## Passing environment variables to the service
Certain use cases require environment variables to be passed to the service. Define these variables in `/etc/conf.d/kodi-standalone` and they will be passed along to the service.

## Notes on system shutdown/reboot
Be aware that these services run Kodi in systemd's user.slice not in the system.slice.  In order to have Kodi gracefully exit, the system should be called to shutdown or to reboot using the respective Kodi actions not by a call to systemctl.  Failure to do so will result in an ungraceful exit of Kodi and the saving of GUI settings, Kodi uptime etc. will not occur.  In principal this is no different than data loss occurring from a user doing work when a sysadmin issues a reboot command without prior warning.  While it is possible to run Kodi in systemd's system.slice instead, doing so makes it difficult to use USB mounts within Kodi and to use pulseaudio for Kodi sessions.

### Recommended methods to reboot/shutdown
Here are several options:

* Select the corresponding option under Power menu in the Kodi GUI.
* Use the official Android/iOS remote app.
* If a CLI option is preferred, use `kodi-send` to issue a `Reboot` or `ShutDown()` like so:
```
$ kodi-send -a "Reboot"
$ kodi-send -a "ShutDown()"
```

## Acknowledgments
Much of the credit for this service goes to the Arch Linux maintainers of the official kodi package. Note that they removed it upon the [1.16-1 release of Xorg](https://git.archlinux.org/svntogit/community.git/commit/trunk?h=packages/xbmc&id=9763c6d32678f3a3f45c195bfae92eee209d504f).

## Tips and Tricks
### Service not starting
Most users should not need `/etc/X11/Xwrapper.config` since the created X server becomes the [controlling process](http://www.freedesktop.org/software/systemd/man/systemd.exec.html#StandardInput=) of the VT to which it is bound. Most users does not mean all users. There have been reports of some AMD users still requiring this file. As well, users of Xorg's native modesetting driver may also require it.

The recommendation is to first try starting `kodi-x11.service` without it, but if the service fails to start X, you may need to create `/etc/X11/Xwrapper.config` which should contain the following:
```
needs_root_rights = yes
```

### Running Kodi web service on a privileged port
Users wishing to run the kodi web service on a privileged port (i.e. <1024) can simply use a [systemd drop-in](https://wiki.archlinux.org/index.php/Systemd#Drop-in_files) modification as follows:
```
[Service]
AmbientCapabilities=CAP_NET_BIND_SERVICE
```
