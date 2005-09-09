# CIT_PATH_PYTHIA([VERSION], [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
# --------------------------------------------------------------------
# Check for the Pythia package.
AC_DEFUN([CIT_PATH_PYTHIA], [
# $Id$
AC_REQUIRE([AM_PATH_PYTHON])
AC_MSG_CHECKING([for Pythia v$1])
if test x == x"$PYTHIA_VERSION"; then
    # It is common practice to create a 'pyre' project subdirectory, which
    # Python will search instead of the installed Pyre!
    mkdir empty
    cd empty
    pythia_version=`$PYTHON -c "import pyre; print pyre.__version__" 2>/dev/null`
    cd ..
    rmdir empty
else
    pythia_version=$PYTHIA_VERSION
fi
if test "$pythia_version" = $1; then
    AC_MSG_RESULT(yes)
    $2
else
    AC_MSG_RESULT(no)
    m4_default([$3], [AC_MSG_ERROR([no suitable Pythia package found])])
fi
AC_ARG_VAR(PYTHIA_INCDIR, [Pythia include directory])
AC_ARG_VAR(PYTHIA_LIBDIR, [Pythia library directory])
if test x == x"$PYTHIA_INCDIR"; then
    PYTHIA_INCDIR="\$(includedir)/pythia-0.8"
fi
if test x == x"$PYTHIA_LIBDIR"; then
    PYTHIA_LIBDIR="\$(libdir)"
fi
])dnl CIT_PATH_PYTHIA
dnl end of file
