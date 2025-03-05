# SPDX-FileCopyrightText: © 2025 Rahul Sandhu <nvraxn@gmail.com>
# SPDX-License-Identifier: GPL-3.0-or-later

.POSIX:
.PHONY: all clean policy check doc config_install modular_install monolithic_install

all: clean policy check doc

DESTDIR ?=
PREFIX ?= /usr/local
SHAREDIR ?= $(PREFIX)/share
MANDIR ?= $(SHAREDIR)/man
MCS ?= true
MODULES := $(shell find src -type f -name '*.cil' | sort)
POLVERS ?= 34
SELINUXTYPE ?= sierra
VERBOSE ?= false

clean: clean.$(POLVERS)
clean.%:
	rm -f policy.$* file_contexts
	$(MAKE) -C doc clean

policy: policy.$(POLVERS)
policy.%: $(MODULES)
	case "$(VERBOSE)" in \
		false) secilc -OM $(MCS) --policyvers=$* $(MODULES) ;; \
		*) secilc -vvv -OM $(MCS) --policyvers=$* $(MODULES) ;; \
	esac

check: check.$(POLVERS)
check.%:
	setfiles -c policy.$* file_contexts

doc:
	$(MAKE) -C doc DESTDIR=$(DESTDIR) PREFIX=$(PREFIX) SHAREDIR=$(SHAREDIR) MANDIR=$(MANDIR)

config_install:
	install -d $(DESTDIR)/etc/selinux/$(SELINUXTYPE)/contexts/files
	install -d $(DESTDIR)/etc/selinux/$(SELINUXTYPE)/contexts/users
	install -d $(DESTDIR)/etc/selinux/$(SELINUXTYPE)/logins
	install -d -m0700 $(DESTDIR)/etc/selinux/$(SELINUXTYPE)/policy

	for file in dbus_contexts customizable_types default_type; do \
		install -m 644 templates/contexts/$$file $(DESTDIR)/etc/selinux/$(SELINUXTYPE)/contexts/$$file; \
	done

	install -m 644 templates/contexts/files/file_contexts.subs_dist \
		$(DESTDIR)/etc/selinux/$(SELINUXTYPE)/contexts/files/file_contexts.subs_dist

	if [ "$(MCS)" = "false" ]; then \
		replace=''; \
	else \
		replace=':s0'; \
	fi; \
	for file in files/media default_contexts failsafe_context removable_context; do \
		sed "s/@MCS_SUFFIX@/$$replace/g" templates/contexts/$$file > tmp_context; \
		install -m 644 tmp_context $(DESTDIR)/etc/selinux/$(SELINUXTYPE)/contexts/$$file; \
		rm tmp_context; \
	done

modular_install: config_install
	install -d -m0700 $(DESTDIR)/var/lib/selinux/$(SELINUXTYPE)
	if [ "$(MCS)" = "false" ]; then \
		sed -i 's/(mls true)/(mls false)/' src/misc/conf.cil; \
	fi
	if [ -z "$(DESTDIR)" ]; then \
		case "$(VERBOSE)" in \
			false) semodule --priority=100 -NP -s $(SELINUXTYPE) -i $(MODULES) ;; \
			*) semodule --priority=100 -NP -vvv -s $(SELINUXTYPE) -i $(MODULES) ;; \
		esac; \
	else \
		case "$(VERBOSE)" in \
			false) semodule --priority=100 -NP -s $(SELINUXTYPE) -i $(MODULES) -p $(DESTDIR) ;; \
			*) semodule --priority=100 -NP -vvv -s $(SELINUXTYPE) -i $(MODULES) -p $(DESTDIR) ;; \
		esac; \
	fi
	if [ "$(MCS)" = "false" ]; then \
		sed -i 's/(mls false)/(mls true)/' src/misc/conf.cil; \
	fi

monolithic_install: config_install monolithic_install.$(POLVERS)
monolithic_install.%:
	if [ "$(MCS)" = "false" ]; then \
		replace=''; \
	else \
		replace=':s0-s0'; \
	fi; \
	sed "s/@MCS_SUFFIX@/$$replace/g" templates/seusers > tmp_users; \
	install -m 644 tmp_users $(DESTDIR)/etc/selinux/$(SELINUXTYPE)/seusers; \
	rm tmp_users;

	install -m 644 file_contexts $(DESTDIR)/etc/selinux/$(SELINUXTYPE)/contexts/files/
	install -m 600 policy.$* $(DESTDIR)/etc/selinux/$(SELINUXTYPE)/policy/
