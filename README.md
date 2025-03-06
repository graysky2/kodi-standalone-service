# kodi-standalone-service
Run [Kodi](https://kodi.tv/) as an unprivileged user in standalone mode without the need for a full Desktop Environment.  X11, Wayland, and GBM are supported.

Which one to choose?

In terms of functionality, GBM is currently the most feature rich. It is the only one of the three options able to display HDR content. X11 and Wayland are both a close second and should be considered on-par with GBM, however, a known limitation of Wayland is having the resolution and frame rate set in the compositor rather than in kodi's GUI.  As well, Wayland currently does not support VT switching.  GBM has some known features it lacks compared the X11 and Wayland.  A complete list can be found in [Kodi issue 14876](https://github.com/xbmc/xbmc/issues/14876).

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
1. Users of Ubuntu ≥20.0 will need to edit `/etc/sysusers.d/kodi-standalone.conf` and uncomment the line adding kodi user to the `render` group.

2. Users of Ubuntu wishing the kodi user to access devices on `/dev/ttyxxxx`, will need to edit `/etc/sysusers.d/kodi-standalone.conf` and uncomment the line adding the kodi user to the `dialout` group.

#### Notes for users of RPiOS
To use this with RPiOS Lite (Rasbian 11: Bullseye, Kodi 19.4: Matrix) requires extra setup.

1. Ensure that the boot preference is set to a graphical target.  
`sudo systemctl set-default graphical.target`  
This causes the kodi service to launch automatically on boot via `display-manager.target`.

2. Install the `kodi-eventclients-kodi-send` package and see [shutdown/reboot](https://github.com/graysky2/kodi-standalone-service#notes-on-system-shutdownreboot).

#### Notes for users of Proxmox
If running kodi containerized on Proxmox, see [Issue #47](https://github.com/graysky2/kodi-standalone-service/issues/47).

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
* If a CLI option is preferred, use `kodi-send` to issue a `Reboot` or `ShutDown` like so:
```
$ kodi-send -a Reboot
$ kodi-send -a ShutDown
```

## Acknowledgments
Much of the credit for this service goes to the Arch Linux maintainers of the official kodi package. Note that they removed it upon the [1.16-1 release of Xorg](https://git.archlinux.org/svntogit/community.git/commit/trunk?h=packages/xbmc&id=9763c6d32678f3a3f45c195bfae92eee209d504f).

## Tips and Tricks
### Automatically restart upon resuming from suspend ###
If the machine is suspended or hibernated, kodi running with these services may have issues upon resuming.

Known issues include:
* Broken connection to an external database (mariadb)
* Using some plugins (observed with official YouTube plugin) simply not working upon resume

To circumvent, enable the provided kodi-xxx-restart-on-resume.service (where xxx is either gbm, wayland, or x11) which will handle an auto-restart when the system is resumed.

### Running Kodi web service on a privileged port
Users wishing to run the kodi web service on a privileged port (i.e. <1024) can simply use a [systemd drop-in](https://wiki.archlinux.org/index.php/Systemd#Drop-in_files) modification as follows:
```
[Service]
AmbientCapabilities=CAP_NET_BIND_SERVICE
```
