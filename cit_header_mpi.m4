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
dnl Use AC_TRY_COMPILE instead of AC_CHECK_HEADER because the
dnl latter also preprocesses using $CXXCPP.
if test x = x"$MPIINCLUDES"; then
    if test -n "$cit_MPICXX"; then
        AC_MSG_CHECKING([for the includes used by $cit_MPICXX])
        for cit_arg_show in "-show" "-showme" "-echo" "-compile_info"
        do
            cit_cmd="$cit_MPICXX -c $cit_arg_show"
            if $cit_cmd >/dev/null 2>&1; then
                cit_args=`$cit_cmd 2>/dev/null`
                test -z "$cit_args" && continue
                cit_includes=
                for cit_arg in $cit_args
                do
                    case $cit_arg in
                        -I*) cit_includes="$cit_includes $cit_arg" ;;
                    esac
                done
                test -z "$cit_includes" && continue
                AC_MSG_RESULT([$cit_includes])
                AC_MSG_CHECKING([for mpi.h])
                CPPFLAGS="$cit_includes $CPPFLAGS"
                AC_TRY_COMPILE([
#include <mpi.h>
                ], [], [
                    AC_MSG_RESULT(yes)
                    MPIINCLUDES=$cit_includes
                ], [
                    AC_MSG_RESULT(no)
                ])
                break
            fi
        done
        if test -z "$cit_includes"; then
            AC_MSG_RESULT(failed)
        fi
    else
        AC_MSG_CHECKING([for mpi.h])
        AC_TRY_COMPILE([
#include <mpi.h>
        ], [], [
            AC_MSG_RESULT(yes)
            MPIINCLUDES=" "
        ], [
            AC_MSG_RESULT(no)
        ])
    fi
else
    AC_MSG_CHECKING([for mpi.h])
    CPPFLAGS="$MPIINCLUDES $CPPFLAGS"
    AC_TRY_COMPILE([
#include <mpi.h>
    ], [], [
        AC_MSG_RESULT(yes)
    ], [
        AC_MSG_RESULT(no)
        MPIINCLUDES=
    ])
fi
if test x = x"$MPIINCLUDES"; then
    AC_MSG_ERROR([header <mpi.h> not found
    Set the MPICXX, MPIINCLUDES, and MPILIBS environment variables to
    specify how to build C++ MPI programs.  Use '--without-mpi'
    to build without MPI support.
])
fi
CPPFLAGS=$cit_save_CPPFLAGS
CXX=$cit_save_CXX
AC_LANG_POP(C++)
])dnl CIT_HEADER_MPI
dnl end of file
