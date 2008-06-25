##############################################################################
# -*- Autoconf -*-
# 
# Implements the AM_OPTIONS_VTK and AM_PATH_VTK macros.
# The AM_OPTIONS_VTK macro adds the --with-vtk=path option,
# and the AM_PATH_VTK macro is used to detect VTK presence,
# location and version.
#
# Modified from http://www.vtk.org/Wiki/VTK_Autoconf
# Originally by Francesco Montorsi
#


##############################################################################
#
# CIGMA_OPTIONS_VTK
#
# Adds the --with-vtk=PATH option to the configure options
#
AC_DEFUN([CIGMA_OPTIONS_VTK],[
    AC_ARG_WITH([vtk],
                [AC_HELP_STRING(
                    [--with-vtk],
                    [The prefix where VTK is installed (default is /usr)])],
                [with_vtk=$withval],
                [with_vtk="/usr"])
    AC_ARG_WITH([vtk-version],
                [AC_HELP_STRING(
                    [--with-vtk-version],
                    [VTK's include directory name is vtk-suffix, e.g., vtk-5.0/.
                     What's the suffix? (Default -5.0)])],
                [vtk_suffix=$withval],
                [vtk_suffix="-5.0"])
])

##############################################################################
#
# AM_PATH_VTK([minimum-version], [action-if-found], [action-if-not-found])
# 
# NOTE: [minimum-version] must be in the form [X.Y.Z]
#
AC_DEFUN([AM_PATH_VTK],[

    dnl do we want to check for VTK?
    if [[ $with_vtk = "yes" ]]; then
        dnl in case user wrote --with-vtk=yes
        with_vtk="/usr"
    fi

    if [[ $with_vtk != "no" ]]; then
        
        VTK_PREFIX="$with_vtk"

        AC_CHECK_FILE([$VTK_PREFIX/include/vtk$vtk_suffix/vtkCommonInstantiator.h],
                      [vtkFound="OK"])
        AC_MSG_CHECKING([if VTK is installed in $VTK_PREFIX])

        if [[ -z "$vtkFound" ]]; then

            dnl VTK not found!
            AC_MSG_RESULT([no])
            $3

        else

            dnl VTK found!
            AC_MSG_RESULT([yes])

            dnl these are the VTK libraries of a default build

            dnl figure out vtkCommon, vtkIO, vtkFiltering, plus dependencies (in case VTK libs are static)
            dnl order of libs is significant
            VTK_SUPPORT_LIBS="-lvtktiff -lvtkpng -lvtkjpeg -lvtkzlib -lvtkexpat"
            AC_CHECK_LIB(vtkIO, abort, [], [
                VTK_SUPPORT_LIBS="-ltiff -lpng -ljpeg -lzlib -lexpat"
                AC_CHECK_LIB(vtkIO, exit, [], [
                    VTK_SUPPORT_LIBS=""
                    AC_CHECK_LIB(vtkIO, strstr, [], [
                        AC_MSG_ERROR([cannot link against VTK libraries])
                    ], [$VTK_SUPPORT_LIBS])
                ], [$VTK_SUPPORT_LIBS])
            ], [$VTK_SUPPORT_LIBS])
            VTK_LIBS="-lvtkIO -lvtkDICOMParser -lvtkFiltering -lvtkCommon $VTK_SUPPORT_LIBS -lvtksys"

            dnl set VTK c,cpp,ld flags
            VTK_CFLAGS="-I$VTK_PREFIX/include/vtk$vtk_suffix"
            VTK_CXXFLAGS="$VTK_CFLAGS"
            VTK_INCLUDES="-I$VTK_PREFIX/include/vtk$vtk_suffix"
            VTK_LDFLAGS="-L$VTK_PREFIX/lib/vtk$vtk_suffix -L$VTK_PREFIX/lib64/vtk$vtk_suffix"

            dnl now, eventually check version
            if [[ -n "$1" ]]; then
                
                dnl the version of VTK we need
                maj=`echo $1 | sed 's/\([[0-9]]*\).\([[0-9]]*\).\([[0-9]]*\)/\1/'`
                min=`echo $1 | sed 's/\([[0-9]]*\).\([[0-9]]*\).\([[0-9]]*\)/\2/'`
                rel=`echo $1 | sed 's/\([[0-9]]*\).\([[0-9]]*\).\([[0-9]]*\)/\3/'`
                AC_MSG_CHECKING([if VTK version is at least $maj.$min.$rel])

                dnl in order to be able to compile the following test program,
                dnl we need to add to the current flags, the VTK settings...
                OLD_CFLAGS=$CFLAGS
                OLD_CXXFLAGS=$CXXFLAGS
                OLD_LDFLAGS=$LDFLAGS
                OLD_LIBS=$LIBS
                CFLAGS="$VTK_CFLAGS $CFLAGS"
                CXXFLAGS="$VTK_CXXFLAGS $CXXFLAGS"
                LDFLAGS="$VTK_LDFLAGS $LDFLAGS"
                LIBS="$VTK_LIBS $LIBS"

                dnl check if the installed VTK is greater or not
                AC_COMPILE_IFELSE([
                    AC_LANG_PROGRAM([
                        #include <vtk/vtkConfigure.h>
                        #include <stdio.h>
                        ],[
                        printf("VTK version is: %d.%d.%d",
                               VTK_MAJOR_VERSION,
                               VTK_MINOR_VERSION,
                               VTK_BUILD_VERSION);

                        #if VTK_MAJOR_VERSION < $maj
                        #error Installed VTK is too old!
                        #endif

                        #if VTK_MINOR_VERSION < $min
                        #error Installed VTK is too old!
                        #endif

                        #if VTK_BUILD_VERSION < $rel
                        #error Installed VTK is too old!
                        #endif
                    ])
                ], [vtkVersion="OK"])

                if [[ "$vtkVersion" = "OK" ]]; then

                    AC_MSG_RESULT([yes])

                    $2

                else

                    AC_MSG_RESULT([no])

                    dnl restore all flags without VTK values
                    CFLAGS=$OLD_CFLAGS
                    CXXFLAGS=$OLD_CXXFLAGS
                    LDFLAGS=$OLD_LDFLAGS
                    LIBS=$OLD_LIBS

                    $3
                fi              # if [[ $vtkVersion = "OK ]];

            else

                dnl if we don't have to check for minimum version
                dnl (because the user did not set that option),
                dnl then we can execute here the block action-if-found
                CFLAGS="$VTK_CFLAGS $CFLAGS"
                CXXFLAGS="$VTK_CXXFLAGS $CXXFLAGS"
                LDFLAGS="$VTK_LDFLAGS $LDFLAGS"
                
                $2

            fi          #if [[ -n "$1" ]];

        fi          # if [[ -z "$vtkFound" ]];
    fi          # $with_vtk != "no"
])



# vim: syntax=config
