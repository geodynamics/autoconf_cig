# CIT_PROG_MPICC
# --------------
# Call AC_PROG_CC, but prefer MPI C wrappers to a bare compiler in
# the search list.  Set MPICC to the program/wrapper used to compile
# C MPI programs.  Set CC to the compiler used to compile ordinary
# C programs, and link shared libraries of all types (see the
# comment about the MPI library, below).  Make sure that CC and
# MPICC both represent the same underlying C compiler.
AC_DEFUN([CIT_PROG_MPICC], [
# $Id$
AC_BEFORE([$0], [AC_PROG_CC])
test -z "$want_mpi" && want_mpi=yes
if test -z "$CC" && test -n "$MPICC"; then
    CC=$MPICC
fi
dnl The 'cit_compiler_search_list' is the result of merging the
dnl following:
dnl     * MPI C wrappers
dnl     * the range of values for config's COMPILER_CC_NAME
dnl       (cc cl ecc gcc icc pgcc xlc xlc_r)
dnl Newer names are tried first (e.g., icc before ecc).
cit_compiler_search_list="gcc cc cl icc ecc pgcc xlc xlc_r"
cit_mpicc_search_list="mpicc hcc mpcc mpcc_r mpxlc cmpicc"
if test "$want_mpi" = yes && test -z "$MPICC"; then
    cit_compiler_search_list="$cit_mpicc_search_list $cit_compiler_search_list"
fi
AC_PROG_CC($cit_compiler_search_list)
if test "$want_mpi" = yes && test -z "$MPICC"; then
    MPICC=$CC
fi
AC_ARG_VAR(MPICC, [MPI C compiler command])
AC_SUBST([MPICC], [$MPICC])
# The MPI library is typically static.  Linking a shared object
# against static library is non-portable, and needlessly bloats our
# Python extension modules on the platforms where it does work.
# Attempt to set CC to the underlying compiler command, so that we
# may link with the matching C compiler, but omit -lmpi/-lmpich from
# the link line.
if test "$want_mpi" = yes; then
    case $MPICC in
        *mp* | hcc)
            AC_MSG_CHECKING([for the C compiler underlying $MPICC])
            case $MPICC in
                mpicc | hcc)    # MPICH or LAM/MPI
                    if $MPICC -compile_info >/dev/null 2>&1; then
                        CC=`$MPICC -compile_info | sed s/-c//`
                    else
                        CC=`$MPICC -c -showme | sed s/-c//`
                    fi
                    ;;
                mpcc | mpxlc)
                    CC=xlc ;;
                mpcc_r)
                    CC=xlc_r ;;
                cmpicc)        # ChaMPIon/Pro
                    CC=`$MPICC -c -echo | sed s/-c//` ;;
            esac
            CC=`echo $CC | sed 's/ .*//'`
            AC_MSG_RESULT($CC)
            ;;
    esac
fi
])dnl CIT_PROG_MPICC
dnl end of file
