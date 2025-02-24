# SPDX-FileCopyrightText: © 2025 Dominick Grift <dominick.grift@defensec.nl>
# SPDX-License-Identifier: Unlicense

.PHONY: all clean policy check config_install modular_install monolithic_install

all: clean policy check

MCS = true
MODULES = $(shell find src -type f -name '*.cil' -print0 | sort -z | xargs -r0)
POLVERS = 33
SELINUXTYPE = sierra
VERBOSE = false

clean: clean.$(POLVERS)
clean.%:
	rm -f policy.$* file_contexts

policy: policy.$(POLVERS)
policy.%: $(MODULES)
ifeq ($(VERBOSE),false)
	secilc -OM $(MCS) --policyvers=$* $^
else
	secilc -vvv -OM $(MCS) --policyvers=$* $^
endif

check: check.$(POLVERS)
check.%:
	setfiles -c policy.$* file_contexts

config_install:
	install -d $(DESTDIR)/etc/selinux/$(SELINUXTYPE)/contexts/files
	install -d $(DESTDIR)/etc/selinux/$(SELINUXTYPE)/contexts/users
	install -d $(DESTDIR)/etc/selinux/$(SELINUXTYPE)/logins
	install -d -m0700 $(DESTDIR)/etc/selinux/$(SELINUXTYPE)/policy
	/bin/echo -e """<!DOCTYPE busconfig PUBLIC\
 \"-//freedesktop//DTD D-BUS Bus Configuration 1.0//EN\"\
\n	\"http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd\">\
\n<busconfig>\
\n<selinux>\
\n</selinux>\
\n</busconfig>""" > $(DESTDIR)/etc/selinux/$(SELINUXTYPE)/contexts/dbus_contexts
	echo "sys.serialtermdev" > $(DESTDIR)/etc/selinux/$(SELINUXTYPE)/contexts/customizable_types
	echo "sys.role:sys.subj" > $(DESTDIR)/etc/selinux/$(SELINUXTYPE)/contexts/default_type
	/bin/echo -e """/bin /usr/bin\
\n/etc/dinit.d /usr/lib/dinit.d\
\n/etc/dinit.d/user /usr/lib/dinit.d/user\
\n/lib /usr/lib\
\n/lib64 /usr/lib\
\n/sbin /usr/bin\
\n/usr/lib64 /usr/lib\
\n/usr/libexec /usr/bin\
\n/usr/local/bin /usr/bin\
\n/usr/local/etc /etc\
\n/usr/local/lib /usr/lib\
\n/usr/local/lib64 /usr/lib\
\n/usr/local/libexec /usr/bin\
\n/usr/local/sbin /usr/bin\
\n/usr/local/share /usr/share\
\n/usr/local/src /usr/src\
\n/usr/sbin /usr/bin\
\n/usr/tmp /tmp\
\n/var/mail /var/spool/mail\
\n/var/lock /run/lock\
\n/var/run /run\
\n/var/tmp /tmp""" > $(DESTDIR)/etc/selinux/$(SELINUXTYPE)/contexts/files/file_contexts.subs_dist
ifeq ($(MCS),false)
	/bin/echo -e """cdrom sys.id:sys.role:removable.stordev\
\ndisk sys.id:sys.role:removable.stordev\
\nfloppy sys.id:sys.role:removable.stordev""" > $(DESTDIR)/etc/selinux/$(SELINUXTYPE)/contexts/files/media
	echo "sys.role:sys.subj sys.role:sys.subj" > $(DESTDIR)/etc/selinux/$(SELINUXTYPE)/contexts/default_contexts
	echo "sys.role:sys.subj" > $(DESTDIR)/etc/selinux/$(SELINUXTYPE)/contexts/failsafe_context
	echo "sys.id:sys.role:removable.fs" > $(DESTDIR)/etc/selinux/$(SELINUXTYPE)/contexts/removable_context
else
	/bin/echo -e """cdrom sys.id:sys.role:removable.stordev:s0\
\ndisk sys.id:sys.role:removable.stordev:s0\
\nfloppy sys.id:sys.role:removable.stordev:s0""" > $(DESTDIR)/etc/selinux/$(SELINUXTYPE)/contexts/files/media
	echo "sys.role:sys.subj:s0 sys.role:sys.subj:s0" > $(DESTDIR)/etc/selinux/$(SELINUXTYPE)/contexts/default_contexts
	echo "sys.role:sys.subj:s0" > $(DESTDIR)/etc/selinux/$(SELINUXTYPE)/contexts/failsafe_context
	echo "sys.id:sys.role:removable.fs:s0" > $(DESTDIR)/etc/selinux/$(SELINUXTYPE)/contexts/removable_context
endif

modular_install: config_install
	install -d -m0700 $(DESTDIR)/var/lib/selinux/$(SELINUXTYPE)
ifeq ($(MCS),false)
	sed -i 's/(mls true)/(mls false)/' src/misc/conf.cil
endif
ifndef DESTDIR
ifeq ($(VERBOSE),false)
	semodule --priority=100 -NP -s $(SELINUXTYPE) -i $(MODULES)
else
	semodule --priority=100 -NP -vvv -s $(SELINUXTYPE) -i $(MODULES)
endif
else
ifeq ($(VERBOSE),false)
	semodule --priority=100 -NP -s $(SELINUXTYPE) -i $(MODULES) -p $(DESTDIR)
else
	semodule --priority=100 -NP -vvv -s $(SELINUXTYPE) -i $(MODULES) -p $(DESTDIR)
endif
endif
ifeq ($(MCS),false)
	sed -i 's/(mls false)/(mls true)/' src/misc/conf.cil
endif

monolithic_install: config_install monolithic_install.$(POLVERS)
monolithic_install.%:
ifeq ($(MCS),false)
	echo "__default__:sys.id" > $(DESTDIR)/etc/selinux/$(SELINUXTYPE)/seusers
else
	echo "__default__:sys.id:s0-s0" > $(DESTDIR)/etc/selinux/$(SELINUXTYPE)/seusers
endif
	install -m 644 file_contexts $(DESTDIR)/etc/selinux/$(SELINUXTYPE)/contexts/files/
	install -m 600 policy.$* $(DESTDIR)/etc/selinux/$(SELINUXTYPE)/policy/
