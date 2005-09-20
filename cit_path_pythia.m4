# CIT_PATH_PYTHIA([VERSION], [SUBPACKAGES],
#                 [ACTION-IF-FOUND], [ACTION-IF-NOT-FOUND])
# ---------------------------------------------------------
# Check for the Pythia package.  If SUBPACKAGES is
# specified, check for each whitespace-separated subpackage
# listed (useful for optional subpackages such as 'mpi'
# and 'acis').
AC_DEFUN([CIT_PATH_PYTHIA], [
# $Id$
AC_REQUIRE([AM_PATH_PYTHON])
AC_ARG_VAR(PYTHIA_VERSION, [Pythia version, e.g. 0.8-mpi to override Pythia tests])
AC_MSG_CHECKING([for Pythia v$1])
if test -n "$PYTHIA_VERSION"; then
    # Override the tests.
    pythia_version=`echo $PYTHIA_VERSION | sed 's/-/ /' | sed 's/ .*//'`
    pythia_subpackages=,`echo $PYTHIA_VERSION | sed 's/-/ /' | sed 's/^.* //' | sed 's/-/,/g'`,
    if test "$pythia_version" = $1; then
        AC_MSG_RESULT([(overridden) yes])
        pythia_found="yes"
        for pythia_subpackage in $2; do
            AC_MSG_CHECKING([for subpackage '$pythia_subpackage' in Pythia])
            if test `echo $pythia_subpackages | grep ,$pythia_subpackage,`; then
                AC_MSG_RESULT([(overridden) yes])
            else
                AC_MSG_RESULT([(overridden) no])
                pythia_found="no"
            fi
        done
        if test "$pythia_found" = "yes"; then
            $3
            :
        else
            m4_default([$4], [AC_MSG_ERROR([required Pythia subpackages not found; check PYTHIA_VERSION])])
            :
        fi
    else
        AC_MSG_RESULT([(overridden) no])
        m4_default([$4], [AC_MSG_ERROR([no suitable Pythia package found; check PYTHIA_VERSION])])
    fi
else
    # It is common practice to create a 'pyre' project subdirectory, which
    # Python will search instead of the installed Pyre!
    test -d empty || mkdir empty
    pythia_version=`cd empty && $PYTHON -c "import pyre; print pyre.__version__" 2>/dev/null`
    rmdir empty
    if test "$pythia_version" = $1; then
        AC_MSG_RESULT(yes)
        pythia_found="yes"
        for pythia_subpackage in $2; do
            AC_MSG_CHECKING([for subpackage '$pythia_subpackage' in Pythia])
            test -d empty || mkdir empty
            pythia_subversion=`cd empty && $PYTHON -c "import $pythia_subpackage; print $pythia_subpackage.__version__" 2>/dev/null`
            rmdir empty
            if test "$pythia_subversion" = $1; then
                AC_MSG_RESULT(yes)
            else
                AC_MSG_RESULT(no)
                pythia_found="no"
            fi
        done
        if test "$pythia_found" = "yes"; then
            AC_MSG_CHECKING([Pythia include directory])
            test -d empty || mkdir empty
            [pythia_pkgincludedir=`cd empty && $PYTHON -c "from pyre.config import makefile; print makefile['pkgincludedir']" 2>/dev/null`]
            rmdir empty
            if test -d "$pythia_pkgincludedir"; then
                AC_MSG_RESULT([$pythia_pkgincludedir])
                CPPFLAGS="-I$pythia_pkgincludedir $CPPFLAGS"; export CPPFLAGS
            else
                AC_MSG_RESULT(no)
            fi
            AC_MSG_CHECKING([Pythia lib directory])
            test -d empty || mkdir empty
            [pythia_libdir=`cd empty && $PYTHON -c "from pyre.config import makefile; print makefile['libdir']" 2>/dev/null`]
            rmdir empty
            if test -d "$pythia_libdir"; then
                AC_MSG_RESULT([$pythia_libdir])
                LDFLAGS="-L$pythia_libdir $LDFLAGS"; export LDFLAGS
            else
                AC_MSG_RESULT(no)
            fi
            AC_CHECK_LIB(journal, firewall_hit, [
                AC_LANG_PUSH(C++)
                AC_CHECK_HEADER([journal/diagnostics.h], [
                    $3
                    :
                ], [
                    m4_default([$4], [AC_MSG_ERROR([Pythia headers not found; try CPPFLAGS="-I<pythia-$1 include dir>"])])
                    :
                ])
                AC_LANG_POP(C++)
            ], [
                m4_default([$4], [AC_MSG_ERROR([Pythia libraries not found; try LDFLAGS="-L<Pythia lib dir>"])])
                :
            ])
        else
            m4_default([$4], [AC_MSG_ERROR([required Pythia subpackages not found])])
            :
        fi
    else
        AC_MSG_RESULT(no)
        AC_MSG_CHECKING([for prepackaged Pythia])
        if test -d $srcdir/pythia-$1; then
            AC_MSG_RESULT(yes)
            MAYBE_PYTHIA=pythia-$1
            # Override the above tests in any subpackages.
            if test -n "$2"; then
                PYTHIA_VERSION=$1-`echo $2 | sed 's/ /-/g'`
            else
                PYTHIA_VERSION="$1"
            fi
            export PYTHIA_VERSION
            # Find Pythia headers and libraries in the build directory.
            pythia_builddir=`pwd`/pythia-$1
            pythia_pkgdir=$pythia_builddir/packages
            CPPFLAGS="-I$pythia_builddir/include $CPPFLAGS"; export CPPFLAGS
            LDFLAGS="-L$pythia_pkgdir/journal/libjournal -L$pythia_pkgdir/mpi $LDFLAGS"; export LDFLAGS
            $3
        else
            AC_MSG_RESULT(no)
            m4_default([$4], [AC_MSG_ERROR([no suitable Pythia package found])])
        fi
    fi
fi
if test -d $srcdir/pythia-$1; then
    MAYBE_DIST_PYTHIA=pythia-$1
fi
AC_SUBST([MAYBE_PYTHIA])
AC_SUBST([MAYBE_DIST_PYTHIA])
])dnl CIT_PATH_PYTHIA
dnl end of file
