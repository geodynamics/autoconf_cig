# -*- Autoconf -*-


## --------------------------- ##
## Autoconf macros for OPENCL. ##
## --------------------------- ##


# ----------------------------------------------------------------------
# CIT_OPENCL_CONFIG
# ----------------------------------------------------------------------
# Determine the directory containing <CL/cl.h>
AC_DEFUN([CIT_OPENCL_CONFIG], [
  AC_ARG_VAR(OPENCL_INC, [Location of OpenCL include files])
  AC_ARG_VAR(OPENCL_LIB, [Location of Opencl library libopencl])

  AC_LANG_PUSH([C++])
  AC_REQUIRE_CPP
  CPPFLAGS_save="$CPPFLAGS"
  LDFLAGS_save="$LDFLAGS"
  LIBS_save="$LIBS"

  dnl Check for OpenCL headers
  if test "x$OPENCL_INC" != "x"; then
    OPENCL_CPPFLAGS="-I$OPENCL_INC"
    CPPFLAGS="$OPENCL_CPPFLAGS $CPPFLAGS"
  fi
  AC_CHECK_HEADER([CL/cl.h], [], [
    AC_MSG_ERROR([OpenCL header not found; try setting OPENCL_INC.])
  ])

  if test "x$OPENCL_LIB" != "x"; then
    OPENCL_LDFLAGS="-L$OPENCL_LIB"
    LDFLAGS="$OPENCL_LDFLAGS $LDFLAGS"
  fi
  OPENCL_LIBS="-lOpenCL"
  LIBS="$OPENCL_LIBS $LIBS"
  AC_MSG_CHECKING([for clCreateBuffer in -lOpenCL])
  AC_LINK_IFELSE(
    [AC_LANG_PROGRAM([[#include <CL/cl.h>]],
  	             [[clGetPlatformIDs(0, 0, 0);]])],
    [AC_MSG_RESULT(yes)],
    [AC_MSG_RESULT(no)
     AC_MSG_ERROR([OpenCL library not found; try setting OPENCL_LIB.])
  ])

  CPPFLAGS="$CPPFLAGS_save"
  LDFLAGS="$LDFLAGS_save"
  LIBS="$LIBS_save"
  AC_LANG_POP([C++])

  AC_SUBST([OPENCL_CPPFLAGS])
  AC_SUBST([OPENCL_LDFLAGS])
  AC_SUBST([OPENCL_LIBS])
])dnl CIT_OPENCL_COMPILER


dnl end of file
