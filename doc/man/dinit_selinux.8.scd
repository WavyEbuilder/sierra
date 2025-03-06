dinit_selinux(8)

# NAME

dinit_selinux - SELinux policy for the Dinit service, supervision and init suite.

# BOOLEANS

*dinit.allow_unknown_agent*
	Enable support for running unknown agents in the unconfined domain, sys.subj.   Enabled by default.

# DOMAINS

*dinit.subj*
	is used for the system instance of dinit, running as PID1.  *dinit*, when executed from the initial SID context's domain, *sys.subj*, will be run as the system manager in this domain.

# LOCATIONS

The following types are used for filesystem objects.  By default, file-context specifications exist for the default locations for Dinit.  If these are not used, new file-context specifications will be required.  See *semanage-fcontext*(8) for more information.

## EXECUTABLES

*dinit.exec.file*
	is used for the *dinit* binary.

## RUNTIME FILES

*dinit.run.file*
	is used for the *dinit* control socket.

## LIBRARY FILES

*dinit.service.file*
	is used for system services.  Type transition for objects made in the unconfined domain, *sys.subj*, at relevant locations exist.

# POLICY

## MACROS

*dinit.unix_stream_connect*
	Allows ARG1 to connect to dinit unix stream sockets. Domains that talk to the dinit control socket will most likely want to call this macro.

*.file.lib.service* inherits all macro template files.

# SEE ALSO

*selinux*(8), *dinit*(8), *semanage-fcontext*(8).

# AUTHORS

Maintained by Rahul Sandhu <nvraxn@gmail.com>.
