# kodi-standalone-service
Systemd service units to run [Kodi](https://kodi.tv/) in standalone mode without the need for a DE.  Both X11 and GBM are supported (makes little sense to use Wayland in standalone mode).

## Installation
### Arch Linux
Arch Linux users can find a PKGBUILD in the [AUR](https://aur.archlinux.org/packages/kodi-standalone-service) that will take care of everything. Simply install and use.

### Arch ARM
Users of Arch ARM should NOT use this method as the distro package provides analogous functionality.

### Other distros
Users of other distros should copy `kodi.service` and `kodi-gbm.service` to `/usr/lib/systemd/system/` and should create both a kodi user and home directory as follows:
```
 useradd -c 'kodi user' -u 420 -g kodi -G audio,video,network,optical -d /var/lib/kodi -s /usr/bin/nologin kodi

 passwd -l kodi > /dev/null

 mkdir /var/lib/kodi
 chown -R kodi:kodi /var/lib/kodi
```

Note that the kodi user's home directory is `/var/lib/kodi/` in this example, NOT `/home/kodi/` like a regular user.

## Usage
Simply call the requisite service to start, for kodi-x11:
```
systemctl start kodi
```
Or for kodi-gbm:
```
systemctl start kodi-gbm
```

## Dependency List
* kodi (x11 or gbm)
* polkit

* xorg-server and xorg-xinit (for running x11)
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
