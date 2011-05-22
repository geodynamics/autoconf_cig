# -*- Autoconf -*-


## --------------------------- ##
## Autoconf macros for CUDA. ##
## --------------------------- ##

# ----------------------------------------------------------------------
# CIT_CUDA_INCDIR
# ----------------------------------------------------------------------
# Determine the directory containing <cuda_runtime.h>
AC_DEFUN([CIT_CUDA_INCDIR], [
  AC_REQUIRE_CPP
  AC_LANG(C++)
  AC_CHECK_HEADER([cuda_runtime.h], [], [
    AC_MSG_ERROR([CUDA runtime header not found; try CPPFLAGS="-I<CUDA include dir>"])
  ])dnl
])dnl CIT_CUDA_INCDIR


# ----------------------------------------------------------------------
# CIT_CUDA_LIB
# ----------------------------------------------------------------------
# Checking for the CUDA library.
AC_DEFUN([CIT_CUDA_LIB], [
  AC_REQUIRE_CPP
  AC_LANG(C++)
  AC_MSG_CHECKING([for cudaMalloc in -lcuda])
  AC_COMPILE_IFELSE(
    [AC_LANG_PROGRAM([[#include <cuda_runtime.h>]],
                     [[void* ptr = 0;]]
  	             [[cudaMalloc(ptr, ptr, 1);]])],
    [AC_MSG_RESULT(yes)],
    [AC_MSG_RESULT(no)
     AC_MSG_ERROR([cuda library not found.])
  ])dnl
])dnl CIT_CUDA_LIB


dnl end of file
