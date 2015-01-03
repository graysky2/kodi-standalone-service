# kodi-standalone-service
A simple systemd service file to run kodi in standalone mode.

## Dependency List
* systemd
* xorg-server with xorg-xinit

## Post-install instructions
If using xorg version >=1.16 then create /etc/X11/Xwrapper.config containing this line:

	allowed_users = anybody

Note that the systemd service requires /var/lib/kodi to be user kodi's homedir.  See the readme.install which contains scriptlets used by the Arch Linux package system.  Users of other distros can adapt the code therein.

## Credit
Credit for the service given to the Arch Linux maintainers of the official kodi package.
