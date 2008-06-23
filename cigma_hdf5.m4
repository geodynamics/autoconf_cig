##############################################################################
# -*- Autoconf -*-
#
#

##############################################################################
#
# CIGMA_OPTIONS_HDF5
#
AC_DEFUN([CIGMA_OPTIONS_HDF5], [
    AC_ARG_VAR(HDF5_HOME, [home path to HDF5 library])
    AC_ARG_WITH([hdf5],
        [AC_HELP_STRING([--with-hdf5],
                        [The prefix where HDF5 is installed @<:@default=/usr@:>@])],
        [with_hdf5="$withval"],
        [with_hdf5="/usr"])
])

##############################################################################
#
# CIGMA_PATH_HDF5([action-if-found], [action-if-not-found])
#
AC_DEFUN([CIGMA_PATH_HDF5],[
    
    # AC_REQUIRE([CIGMA_PATH_ZLIB])


    if [[ $with_hdf5 = "yes" ]]; then
        dnl In case user wrote --with-hdf5=yes
        with_hdf5="/usr"
    fi


    if [[ $with_hdf5 != "no" ]]; then

        HDF5_PREFIX="$with_hdf5"

        AC_CHECK_FILE([$HDF5_PREFIX/include/hdf5.h], [hdf5Found="OK"])
        AC_MSG_CHECKING([if HDF5 is installed in $HDF5_PREFIX])

        if [[ -z "$hdf5Found" ]]; then

            dnl HDF5 not found!
            AC_MSG_RESULT([no])
            $2

        else

            dnl HDF5 found!

            AC_MSG_RESULT([yes])

            AC_CHECK_LIB(hdf5,main,[hdf5lib="OK"])

            #HDF5_CFLAGS="-I$HDF5_PREFIX/include"
            #HDF5_CXXFLAGS="$HDF5_CFLAGS"

            HDF5_INCLUDES="-I$HDF5_PREFIX/include"
            HDF5_LIBS="-lhdf5"
            HDF5_LDFLAGS="-L$HDF5_PREFIX/lib $HDF5_LIBS -Wl,--rpath -Wl,$HDF5_PREFIX/lib"
            $1

        fi

    else
        
        dnl user specified --with-hdf5=no
        dnl nothing to do?
        /bin/false

    fi

])

# vim: syntax=config
