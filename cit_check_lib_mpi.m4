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
    if test -n "$cit_MPICXX"; then
        AC_MSG_CHECKING([for the libraries used by $cit_MPICXX])
        for cit_arg_show in "-show" "-showme" "-echo" "-link_info"
        do
            cit_cmd="$cit_MPICXX $cit_arg_show"
            if $cit_cmd >/dev/null 2>&1; then
                cit_args=`$cit_cmd 2>/dev/null`
                test -z "$cit_args" && continue
                cit_libs=
                for cit_arg in $cit_args
                do
                    case $cit_arg in
                        -L* | -l* | -pthread*) cit_libs="$cit_libs $cit_arg" ;;
                    esac
                done
                test -z "$cit_libs" && continue
                AC_MSG_RESULT([$cit_libs])
                cit_save_LIBS=$LIBS
                LIBS="$cit_libs $LIBS"
                AC_CHECK_FUNC(MPI_Init, [MPILIBS=$cit_libs])
                LIBS=$cit_save_LIBS
                break
            fi
        done
        if test -z "$cit_libs"; then
            AC_MSG_RESULT(failed)
        fi
    else
        AC_CHECK_FUNC(MPI_Init, [MPILIBS=" "], [
            for cit_lib in mpi mpich; do
                AC_CHECK_LIB($cit_lib, MPI_Init, [
                    MPILIBS="-l$cit_lib"
                    break])
            done
        ])
    fi
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
