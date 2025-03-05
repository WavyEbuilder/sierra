AC_INIT([sierra], [1.0.0])

MODULES=$(echo $(find src -type f -name '*.cil' | sort))
AC_SUBST([MODULES])

AC_ARG_WITH([polvers], AS_HELP_STRING([--with-polvers=], [policy version]),, [with_polvers=34])
AS_IF([test "$with_polvers" = yes], [AC_MSG_ERROR([--with-polvers= must have a value])])
AC_SUBST([POLVERS], [$with_polvers])


AC_CONFIG_FILES([Makefile doc/Makefile])

AC_OUTPUT
