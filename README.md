# kodi-standalone-service
A simple systemd service file to run kodi in standalone mode.

## Dependency List
* systemd
* xorg-server with xorg-xinit

## Post-install instructions
If using xorg version >=1.16 then create /etc/X11/Xwrapper.config containing these two lines:

	allowed_users = anybody
	needs_root_rights = yes

## Credit
Credit for the service given to the Arch Linux maintainers of the official kodi package.
