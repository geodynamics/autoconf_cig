##############################################################################
# -*- Autoconf -*-
#
# ZLIB is needed for compiling HDF5
#

##############################################################################
#
# CIGMA_OPTIONS_ZLIB
#
AC_DEFUN([CIGMA_OPTIONS_ZLIB], [
    AC_ARG_WITH([zlib],
        [AC_HELP_STRING([--with-zlib],
                        [The prefix where zlib is installed @<:@default=/usr@:>@])],
        [with_zlib="$withval"],
        [with_zlib="/usr"])
])

##############################################################################
#
# CIGMA_PATH_ZLIB([action-if-found], [action-if-not-found])
#
AC_DEFUN([CIGMA_PATH_ZLIB],[
    

    dnl Check for zlib

    if [[ $with_zlib = "yes" ]]; then
        dnl In case user wrote --with-zlib=yes
        with_zlib="/usr"
    fi

    if [[ $with_zlib="no" ]]; then

        ZLIB_PREFIX="$with_zlib"

        AC_CHECK_LIB(z,main,[zlibFound="OK"])

        if [[ -n "$zlibFound" ]]; then
            ZLIB_LIBS="-lz"
            ZLIB_CFLAGS="-I$ZLIB_PREFIX/include -I$ZLIB_PREFIX"
            ZLIB_LDFLAGS="-L$ZLIB_PREFIX/lib -L$ZLIB_PREFIX"
        fi

    else
        dnl ZLIB not specified...fail?
        /bin/false
    fi

    AC_SUBST(ZLIB_LIBS)
    AC_SUBST(ZLIB_CFLAGS)
    AC_SUBST(ZLIB_LDFLAGS)

])

# vim: syntax=config
