# -*- Autoconf -*-


# ======================================================================
# Autoconf macros for curl.
# ======================================================================

# ----------------------------------------------------------------------
# CIT_CURL_HEADER
# ----------------------------------------------------------------------
AC_DEFUN([CIT_CURL_HEADER], [
  cit_save_cppflags=$CPPFLAGS
  CPPFLAGS="$CPPFLAGS $CURL_INCLUDES"
  AC_LANG(C++)
  AC_REQUIRE_CPP
  AC_CHECK_HEADER([curl/curl.h], [], [
    AC_MSG_ERROR([curl header not found; try --with-curl-incdir=<curl include dir>"])
  ])dnl
  CPPFLAGS=$cit_save_cppflags
])dnl CIT_CURL_HEADER


# ----------------------------------------------------------------------
# CIT_CURL_LIB
# ----------------------------------------------------------------------
AC_DEFUN([CIT_CURL_LIB], [
  cit_save_CPPFLAGS=$CPPFLAGS
  cit_save_LDFLAGS=$LDFLAGS
  cit_save_libs=$LIBS
  CPPFLAGS="$CPPFLAGS $CURL_INCLUDES"
  LDFLAGS="$LDFLAGS $CURL_LDFLAGS"
  AC_LANG(C++)
  AC_REQUIRE_CPP
  AC_CHECK_LIB(curl, curl_global_init, [],[
    AC_MSG_ERROR([curl library not found; try --with-curl-libdir=<curl lib dir>])
  ])dnl
  CPPFLAGS=$cit_save_cppflags
  LDFLAGS=$cit_save_ldflags
  LIBS=$cit_save_libs
])dnl CIT_CURL_LIB


dnl end of file
