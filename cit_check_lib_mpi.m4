# CIT_CHECK_LIB_MPI
# -----------------
AC_DEFUN([CIT_CHECK_LIB_MPI], [
# $Id$
AC_ARG_VAR(MPILIBS, [MPI linker flags, e.g. -L<mpi lib dir> -lmpi])
AC_SUBST(MPILIBS)
AC_LANG_PUSH(C++)
cit_save_CXX=$CXX
CXX=$MPICXX
if test x = x"$MPILIBS"; then
    AC_CHECK_FUNC(MPI_Init, [MPILIBS=" "], [
        for cit_lib in mpi mpich; do
            AC_CHECK_LIB($cit_lib, MPI_Init, [
                MPILIBS="-l$cit_lib"
                break])
        done
    ])
else
    cit_save_LIBS=$LIBS
    LIBS="$MPILIBS $LIBS"
    AC_CHECK_FUNC(MPI_Init, [], [MPILIBS=""])
    LIBS=$cit_save_LIBS
fi
if test x = x"$MPILIBS"; then
    AC_MSG_ERROR([no suitable MPI library found
    Set the MPICXX, MPIINCLUDES, and MPILIBS environment variables to
    specify how to build C++ MPI programs.  Use '--without-mpi'
    to build without MPI support.
])
fi
CXX=$cit_save_CXX
AC_LANG_POP(C++)
])dnl CIT_CHECK_LIB_MPI
dnl end of file
