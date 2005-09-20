# CIT_PATH_EXCHANGER([VERSION], [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
# -----------------------------------------------------------------------
# Check for the Exchanger package.
AC_DEFUN([CIT_PATH_EXCHANGER], [
# $Id$
AC_REQUIRE([AM_PATH_PYTHON])
AC_ARG_VAR(EXCHANGER_VERSION, [Exchanger version, e.g. $1 to override Exchanger tests])
AC_MSG_CHECKING([for Exchanger with version ~ $1])
if test -n "$EXCHANGER_VERSION"; then
    # Override the tests.
    exchanger_version=$EXCHANGER_VERSION
    if test "$exchanger_version" = $1; then
        AC_MSG_RESULT([(overridden) yes])
        $2
    else
        AC_MSG_RESULT([(overridden) no])
        m4_default([$3], [AC_MSG_ERROR([no suitable Exchanger package found; check EXCHANGER_VERSION])])
    fi
else
    test -d empty || mkdir empty
    exchanger_version=`cd empty && $PYTHON -c "import Exchanger; print Exchanger.__version__" 2>/dev/null`
    rmdir empty
    [eval `echo $exchanger_version | sed 's/\([^.]*\)[.]\([^.]*\).*/exchanger_version_major=\1; exchanger_version_minor=\2;/'`]
    [eval `echo $1 | sed 's/\([^.]*\)[.]\([^.]*\).*/exchanger_1_major=\1; exchanger_1_minor=\2;/'`]
    if test -n "$exchanger_version_major" &&
       test -n "$exchanger_version_minor" &&
       test "$exchanger_version_major" -eq "$exchanger_1_major" &&
       test "$exchanger_version_minor" -ge "$exchanger_1_minor"; then
        AC_MSG_RESULT(yes)
        AC_MSG_CHECKING([Exchanger include directory])
        test -d empty || mkdir empty
        [exchanger_includedir=`cd empty && $PYTHON -c "from Exchanger.config import makefile; print makefile['includedir']" 2>/dev/null`]
        rmdir empty
        if test -d "$exchanger_includedir"; then
            AC_MSG_RESULT([$exchanger_includedir])
            CPPFLAGS="-I$exchanger_includedir $CPPFLAGS"; export CPPFLAGS
        else
            AC_MSG_RESULT(no)
        fi
        AC_MSG_CHECKING([Exchanger lib directory])
        test -d empty || mkdir empty
        [exchanger_libdir=`cd empty && $PYTHON -c "from Exchanger.config import makefile; print makefile['libdir']" 2>/dev/null`]
        rmdir empty
        if test -d "$exchanger_libdir"; then
            AC_MSG_RESULT([$exchanger_libdir])
            LDFLAGS="-L$exchanger_libdir $LDFLAGS"; export LDFLAGS
        else
            AC_MSG_RESULT(no)
        fi
dnl Painful to test; requires MPI.
dnl AC_CHECK_LIB(Exchanger, PyExchanger_exchangeBoundedBox, [],
dnl [AC_MSG_ERROR([Exchanger libraries not found; try LDFLAGS="-L<Exchanger lib dir>"])]
        AC_LANG_PUSH(C++)
        AC_CHECK_HEADER([Exchanger/DIM.h], [
            $2
            :
        ], [
            m4_default([$3], [AC_MSG_ERROR([Exchanger headers not found; try CPPFLAGS="-I<parent of 'Exchanger' include dir>"])])
            :
        ])
        AC_LANG_POP(C++)
    else
        AC_MSG_RESULT(no)
        AC_MSG_CHECKING([for prepackaged Exchanger])
        if test -d $srcdir/Exchanger; then
            AC_MSG_RESULT(yes)
            MAYBE_EXCHANGER=Exchanger
            # Override the above tests in any subpackages.
            EXCHANGER_VERSION=$1; export EXCHANGER_VERSION
            exchanger_builddir=`pwd`/Exchanger
            CPPFLAGS="-I$exchanger_builddir/include $CPPFLAGS"; export CPPFLAGS
            LDFLAGS="-L$exchanger_builddir $LDFLAGS"; export LDFLAGS
        else
            AC_MSG_RESULT(no)
            m4_default([$3], [AC_MSG_ERROR([no suitable Exchanger package found])])
        fi
    fi
fi
if test -d $srcdir/Exchanger; then
    MAYBE_DIST_EXCHANGER=Exchanger
fi
AC_SUBST([MAYBE_EXCHANGER])
AC_SUBST([MAYBE_DIST_EXCHANGER])
])dnl CIT_PATH_EXCHANGER
dnl end of file
