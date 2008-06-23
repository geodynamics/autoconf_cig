##############################################################################
# -*- Autoconf -*-
#
#

##############################################################################
#
# CIGMA_PATH_PYTHON
#
# Determine the directories containing <Python.h> and <numpy/arrayobject.h>
#
AC_DEFUN([CIGMA_PATH_PYTHON],[

    AC_REQUIRE([AM_PATH_PYTHON])

    AC_CACHE_CHECK([for $am_display_PYTHON include directory],
                   [PYTHON_INCDIR],
                   [PYTHON_INCDIR=`$PYTHON -c "from distutils import sysconfig; print sysconfig.get_python_inc()" 2>/dev/null || echo "$PYTHON_PREFIX/include/python$PYTHON_VERSION"`])

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

    PYTHON_INCLUDES="-I${PYTHON_INCDIR} -I${NUMPY_INCDIR}"
    PYTHON_LIBS="-lpython${PYTHON_VERSION}"
    PYTHON_LDFLAGS="-L${PYTHON_PREFIX}/lib/python${PYTHON_VERSION}/config"

])


# vim: syntax=config
