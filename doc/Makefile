# SPDX-FileCopyrightText: © 2025 Rahul Sandhu <nvraxn@gmail.com>
# SPDX-License-Identifier: GPL-3.0-or-later

.POSIX:
.PHONY: all install clean

all: dinit_selinux.8

DESTDIR ?=
PREFIX ?= /usr/local
SHAREDIR ?= $(PREFIX)/share
MANDIR ?= $(SHAREDIR)/man

dinit_selinux.8: man/dinit_selinux.8.scd
	scdoc < $< > $@

install: dinit_selinux.8
	mkdir -p $(DESTDIR)$(MANDIR)/man8
	install -m 644 dinit_selinux.8 $(DESTDIR)$(MANDIR)/man8/dinit_selinux.8

clean:
	rm -f dinit_selinux.8
