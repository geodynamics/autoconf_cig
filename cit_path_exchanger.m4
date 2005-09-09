# CIT_PATH_EXCHANGER([VERSION], [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
# -----------------------------------------------------------------------
# Check for the Exchanger package.
AC_DEFUN([CIT_PATH_EXCHANGER], [
AC_REQUIRE([AM_PATH_PYTHON])
AC_MSG_CHECKING([for Exchanger with version ~ $1])
AC_MSG_RESULT(yes)
AC_ARG_VAR(EXCHANGER_INCDIR, [Exchanger include directory])
AC_ARG_VAR(EXCHANGER_LIBDIR, [Exchanger library directory])
if test x == x"$EXCHANGER_INCDIR"; then
    EXCHANGER_INCDIR="\$(includedir)"
fi
if test x == x"$EXCHANGER_LIBDIR"; then
    EXCHANGER_LIBDIR="\$(libdir)"
fi
# $Id$
])dnl CIT_PATH_EXCHANGER
dnl end of file
