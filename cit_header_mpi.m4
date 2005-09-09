# CIT_HEADER_MPI
# --------------
AC_DEFUN([CIT_HEADER_MPI], [
# $Id$
AC_ARG_VAR(MPIINCLUDES, [MPI include flags, e.g. -I<mpi include dir>])
AC_SUBST(MPIINCLUDES)
AC_LANG_PUSH(C++)
cit_save_CXX=$CXX
cit_save_CPPFLAGS=$CPPFLAGS
CXX=$MPICXX
CPPFLAGS="$MPIINCLUDES $CPPFLAGS"
dnl Use AC_TRY_COMPILE instead of AC_CHECK_HEADER because the
dnl latter also preprocesses using $CXXCPP.
AC_MSG_CHECKING([for mpi.h])
AC_TRY_COMPILE([#include <mpi.h>], [], [AC_MSG_RESULT(yes)], [
    AC_MSG_RESULT(no)
    AC_MSG_ERROR([header <mpi.h> not found
    Set the MPICXX, MPIINCLUDES, and MPILIBS environment variables to
    specify how to build C++ MPI programs.  Use '--without-mpi'
    to build without MPI support.
])])
CPPFLAGS=$cit_save_CPPFLAGS
CXX=$cit_save_CXX
AC_LANG_POP(C++)
])dnl CIT_HEADER_MPI
dnl end of file
