# -*- Autoconf -*-


# ======================================================================
# Autoconf macros for cpptrace.
# ======================================================================

# ----------------------------------------------------------------------
# CIT_CPPTRACE_HEADER
# ----------------------------------------------------------------------
AC_DEFUN([CIT_CPPTRACE_HEADER], [
  cit_save_cppflags=$CPPFLAGS
  CPPFLAGS="$CPPFLAGS $CPPTRACE_INCLUDES"
  AC_LANG(C++)
  AC_REQUIRE_CPP
  AC_CHECK_HEADER([cpptrace/cpptrace.hpp], [
    AC_DEFINE([HAVE_CPPTRACE], [1], [Define if cpptrace/cpptrace.hpp is available])], [
    AC_MSG_ERROR([cpptrace header not found; try --with-cpptrace-incdir=<cpptrace include dir>])
  ])dnl
  CPPFLAGS=$cit_save_cppflags
])dnl CIT_CPPTRACE_HEADER


# ----------------------------------------------------------------------
# CIT_CPPTRACE_LIB
# ----------------------------------------------------------------------
AC_DEFUN([CIT_CPPTRACE_LIB], [
  cit_save_cppflags=$CPPFLAGS
  cit_save_ldflags=$LDFLAGS
  cit_save_libs=$LIBS
  CPPFLAGS="$CPPFLAGS $CPPTRACE_INCLUDES"
  LDFLAGS="$LDFLAGS $CPPTRACE_LDFLAGS"
  LIBS="-lcpptrace"
  AC_LANG(C++)
  AC_REQUIRE_CPP
  AC_MSG_CHECKING([for cpptrace::generate_trace in -lcpptrace])
  AC_LINK_IFELSE(
    [AC_LANG_PROGRAM([[#include <cpptrace/cpptrace.hpp>]],
	             [[cpptrace::generate_trace()]])],
    [AC_MSG_RESULT(yes)],
    [AC_MSG_RESULT(no)
     AC_MSG_ERROR([cpptrace library not found; try --with-cpptrace-libdir=<cpptrace lib dir>])
    ])
  CPPFLAGS=$cit_save_cppflags
  LDFLAGS=$cit_save_ldflags
  LIBS=$cit_save_libs
])dnl CIT_CPPTRACE_LIB


dnl end of file
