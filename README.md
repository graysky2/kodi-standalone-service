# kodi-standalone-service
A simple systemd service file to run kodi in standalone mode.

## Installation
### Arch Linux
Arch Linux users (not Arch ARM users) can find a PKGBUILD in the [AUR](https://aur.archlinux.org/packages/kodi-standalone-service) that will take care of everything. Simply install and use.

### Other distros
Users of other distros should copy `kodi.service` to `/usr/lib/systemd/system/` and should create both a kodi user and home directory as follows:
```
 useradd -c 'kodi user' -u 420 -g kodi -G audio,video,network,optical \
   -d /var/lib/kodi -s /usr/bin/nologin kodi
 
 passwd -l kodi > /dev/null

 mkdir /var/lib/kodi/.kodi
 chown -R kodi:kodi /var/lib/kodi/.kodi
```

## Usage
Simply call systemd to start the service:
```
systemctl start kodi
```

## Dependency List
* polkit
* systemd
* xorg-server with xorg-xinit

## Notes
Most users should not `/etc/X11/Xwrapper.config` since the created X server becomes the [controlling process](http://www.freedesktop.org/software/systemd/man/systemd.exec.html#StandardInput=) of the VT to which it is bound. Most users does not mean all users. There have been reports of some AMD users still requiring this file. As well, users of Xorg's native modesetting driver may also require it.

The recommendation is to first try starting `kodi.service` without it, but if the service fails to start X, you may need to create `/etc/X11/Xwrapper.config` which should contain the following:
```
needs_root_rights = yes
```

Users wishing to run the kodi web service on a privileged port (i.e. <1024) can simply modify `kodi.service` to contain the following line under the `[Service]` section:
`AmbientCapabilities=CAP_NET_BIND_SERVICE`

If installing this manually, that should be all that's needed.  If installing from the AUR, to avoid an overwrite, simply copy `kodi.service` (with the modified line) to `/etc/systemd/system` which will take president over the package-provided one.

## Credit
Note that this service was provided by the Arch Linux maintainers of the official kodi package, but was removed upon the [1.16-1 release of Xorg](https://git.archlinux.org/svntogit/community.git/commit/trunk?h=packages/xbmc&id=9763c6d32678f3a3f45c195bfae92eee209d504f).
