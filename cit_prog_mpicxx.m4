# CIT_PROG_MPICXX
# ---------------
# Call AC_PROG_CXX, but prefer MPI C++ wrappers to a bare compiler in
# the search list.  Set MPICXX to the program/wrapper used to compile
# C++ MPI programs.  Set CXX to the compiler used to compile ordinary
# C++ programs, and link shared libraries of all types (see the
# comment about the MPI library, below).  Make sure that CXX and
# MPICXX both represent the same underlying C++ compiler.
AC_DEFUN([CIT_PROG_MPICXX], [
# $Id$
AC_BEFORE([$0], [AC_PROG_CXX])
test -z "$want_mpi" && want_mpi=yes
if test -z "$CXX" && test -n "$MPICXX"; then
    CXX=$MPICXX
fi
dnl The 'cit_compiler_search_list' is the result of merging the
dnl following:
dnl     * MPI C++ wrappers
dnl     * the Autoconf default (g++ c++ gpp aCC CC cxx cc++ cl
dnl       FCC KCC RCC xlC_r xlC)
dnl     * the range of values for config's COMPILER_CXX_NAME (aCC CC cl
dnl       cxx ecpc g++ icpc KCC pgCC xlC xlc++_r xlC_r)
dnl Newer names are tried first (e.g., icpc before ecpc).
cit_compiler_search_list="g++ c++ gpp aCC CC cxx cc++ cl FCC KCC RCC xlc++_r xlC_r xlC"
cit_compiler_search_list="$cit_compiler_search_list icpc ecpc pgCC"
cit_mpicxx_search_list="mpicxx mpic++ mpiCC hcp mpCC mpxlC mpxlC_r cmpic++"
if test "$want_mpi" = yes && test -z "$MPICXX"; then
    cit_compiler_search_list="$cit_mpicxx_search_list $cit_compiler_search_list"
fi
AC_PROG_CXX($cit_compiler_search_list)
if test "$want_mpi" = yes && test -z "$MPICXX"; then
    MPICXX=$CXX
fi
AC_ARG_VAR(MPICXX, [MPI C++ compiler command])
AC_SUBST([MPICXX], [$MPICXX])
# The MPI library is typically static.  Linking a shared object
# against static library is non-portable, and needlessly bloats our
# Python extension modules on the platforms where it does work.
# Attempt to set CXX to the underlying compiler command, so that we
# may link with the matching C++ compiler, but omit -lmpi/-lmpich from
# the link line.
if test "$want_mpi" = yes; then
    case $MPICXX in
        *mp* | hcp)
            AC_MSG_CHECKING([for the C++ compiler underlying $MPICXX])
            case $MPICXX in
                mpicxx | mpiCC) # MPICH
                    CXX=`$MPICXX -compile_info | sed s/-c//` ;;
                mpic++ | hcp)   # LAM/MPI
                    CXX=`$MPICXX -c -showme | sed s/-c//` ;;
                mpxlC | mpCC)
                    CXX=xlC ;;
                mpxlC_r)
                    CXX=xlC_r ;;
                cmpic++)        # ChaMPIon/Pro
                    CXX=`$MPICXX -c -echo | sed s/-c//` ;;
            esac
            CXX=`echo $CXX | sed 's/ .*//'`
            AC_MSG_RESULT($CXX)
            ;;
    esac
fi
])dnl CIT_PROG_MPICXX
dnl end of file
