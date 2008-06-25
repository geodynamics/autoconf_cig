##############################################################################
# -*- Autoconf -*-
#
#

##############################################################################
#
# CIGMA_PATH_NUMPY
#
# Determine the directory containing <numpy/arrayobject.h>
#
AC_DEFUN([CIGMA_PATH_NUMPY],[

    AC_REQUIRE([AM_PATH_PYTHON])

    #AC_MSG_CHECKING([for $am_display_PYTHON numpy include directory])

    NUMPY_INCDIR=`$PYTHON -c "import numpy; print numpy.get_include()" 2>/dev/null`
    if [[ -n "$NUMPY_INCDIR" ]]; then
        AC_CHECK_FILE([$NUMPY_INCDIR/numpy/arrayobject.h])
        #AC_CHECK_FILE([$NUMPY_INCDIR/numpy/arrayobject.h], [numpyFound="OK"])
        #if [[ -n "$numpyFound" ]]; then
        #    AC_MSG_RESULT([yes])
        #else
        #    AC_MSG_RESULT([no])
        #fi
    #else
    #    AC_MSG_RESULT([no])
    fi

    NUMPY_INCLUDES="-I${NUMPY_INCDIR}"
    AC_SUBST([NUMPY_INCLUDES], [$NUMPY_INCLUDES])

])


# vim: syntax=config
