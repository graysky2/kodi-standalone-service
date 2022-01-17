PN = kodi-standalone-service

PREFIX ?= /usr
INITDIR = $(PREFIX)/lib/systemd/system
USERDIR = $(PREFIX)/lib/sysusers.d
TMPFDIR = $(PREFIX)/lib/tmpfiles.d
UDEVDIR = $(PREFIX)/lib/udev/rules.d
POLKDIR = $(PREFIX)/share/polkit/rules.d
MANDIR = $(PREFIX)/share/man/man1
ENVDIR = /etc/conf.d

RM = rm
INSTALL = install -p
INSTALL_DIR = $(INSTALL) -d
INSTALL_PROGRAM = $(INSTALL) -m755
INSTALL_DATA = $(INSTALL) -m644

IS_ARCH_ARM := $(shell grep -q ARM /proc/cpuinfo; echo $$?)
ifeq ($(IS_ARCH_ARM), 0)
	ARCH = arm
else
	ARCH = x86
endif

common/$(PN):
	@echo -e '\033[1;32mNothing to be done.\033[0m'
	@echo -e '\033[1;32mJust run make install as root.\033[0m'

install-common:
	$(INSTALL_DIR) "$(DESTDIR)$(UDEVDIR)"
	$(INSTALL_DIR) "$(DESTDIR)$(ENVDIR)"
	$(INSTALL_DATA) $(ARCH)/udev/99-kodi.rules "$(DESTDIR)$(UDEVDIR)/99-kodi.rules"
	$(INSTALL_DATA) common/kodi-standalone "$(DESTDIR)$(ENVDIR)/kodi-standalone"
ifeq ($(ARCH),arm)
	$(INSTALL_DIR) "$(DESTDIR)$(POLKDIR)"
	$(INSTALL_DATA) $(ARCH)/polkit/polkit.rules "$(DESTDIR)$(POLKDIR)/99-kodi.rules"
endif

install-init:
	$(INSTALL_DIR) "$(DESTDIR)$(INITDIR)"
	$(INSTALL_DIR) "$(DESTDIR)$(USERDIR)"
	$(INSTALL_DIR) "$(DESTDIR)$(TMPFDIR)"
ifeq ($(ARCH),x86)
	$(INSTALL_DATA) $(ARCH)/init/kodi-gbm.service "$(DESTDIR)$(INITDIR)/kodi-gbm.service"
	$(INSTALL_DATA) $(ARCH)/init/kodi-wayland.service "$(DESTDIR)$(INITDIR)/kodi-wayland.service"
	$(INSTALL_DATA) $(ARCH)/init/kodi-x11.service "$(DESTDIR)$(INITDIR)/kodi-x11.service"
else
	$(INSTALL_DATA) $(ARCH)/init/kodi.service "$(DESTDIR)$(INITDIR)/kodi.service"
endif
	$(INSTALL_DATA) $(ARCH)/init/tmpfiles.conf "$(DESTDIR)$(TMPFDIR)/kodi-standalone.conf"
	$(INSTALL_DATA) $(ARCH)/init/sysusers.conf "$(DESTDIR)$(USERDIR)/kodi-standalone.conf"

install-man:
	$(INSTALL_DIR) "$(DESTDIR)$(MANDIR)"
	$(INSTALL_DATA) $(ARCH)/doc/kodi.service.1 "$(DESTDIR)$(MANDIR)/kodi.service.1"

uninstall:
ifeq ($(ARCH),x86)
	$(RM) "$(DESTDIR)$(INITDIR)/kodi-gbm.service"
	$(RM) "$(DESTDIR)$(INITDIR)/kodi-wayland.service"
	$(RM) "$(DESTDIR)$(INITDIR)/kodi-x11.service"
else
	$(RM) "$(DESTDIR)$(INITDIR)/kodi.service"
	$(RM) "$(DESTDIR)$(POLKDIR)/99-kodi.rules"
endif
	$(RM) "$(DESTDIR)$(TMPFDIR)/kodi-standalone.conf"
	$(RM) "$(DESTDIR)$(USERDIR)/kodi-standalone.conf"
	$(RM) "$(DESTDIR)$(UDEVDIR)/99-kodi.rules"
	$(RM) "$(DESTDIR)$(MANDIR)/kodi.service.1"
	$(RM) "$(DESTDIR)$(ENVDIR)/kodi-standalone"

install: install-common install-init install-man

.PHONY: install-common install-init uninstall
