##### http://autoconf-archive.cryp.to/ax_boost_python.html
#
# SYNOPSIS
#
#   DEB_AX_BOOST_PYTHON
#
# DESCRIPTION
#
#   This macro checks to see if the Boost.Python library is installed.
#   It also attempts to guess the currect library name using several
#   attempts. It tries to build the library name using a user supplied
#   name or suffix and then just the raw library.
#
#   If the library is found, HAVE_BOOST_PYTHON is defined and
#   BOOST_PYTHON_LIB is set to the name of the library.
#
#   This macro calls AC_SUBST(BOOST_PYTHON_LIBS).
#
#   In order to ensure that the Python headers are specified on the
#   include path, this macro requires AX_PYTHON to be called.
#
# LAST MODIFICATION
#
#   2007-07-29
#
# COPYLEFT
#
#   Copyright (c) 2005 Michael Tindal <mtindal@paradoxpoint.com>
#   Copyright © 2007 Carl Fürstenberg <azatoth@gmail.com>
#
#   This program is free software; you can redistribute it and/or
#   modify it under the terms of the GNU General Public License as
#   published by the Free Software Foundation; either version 2 of the
#   License, or (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful, but
#   WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
#   General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software
#   Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA
#   02111-1307, USA.
#
#   As a special exception, the respective Autoconf Macro's copyright
#   owner gives unlimited permission to copy, distribute and modify the
#   configure scripts that are the output of Autoconf when processing
#   the Macro. You need not follow the terms of the GNU General Public
#   License when using or distributing such scripts, even though
#   portions of the text of the Macro appear in them. The GNU General
#   Public License (GPL) does govern all other use of the material that
#   constitutes the Autoconf Macro.
#
#   This special exception to the GPL applies to versions of the
#   Autoconf Macro released by the Autoconf Macro Archive. When you
#   make and distribute a modified version of the Autoconf Macro, you
#   may extend this special exception to the GPL to apply to your
#   modified version as well.

AC_DEFUN([DEB_AX_BOOST_PYTHON],[
  AC_REQUIRE([DEB_AX_PYTHON])dnl

  AS_VAR_PUSHDEF([ax_BoostPython], [ax_cv_boost_python])dnl
  AC_LANG_PUSH([C++])
  ax_cv_boost_python_save_CPPFLAGS=$CPPFLAGS
  CPPFLAGS="-I$PYTHON_INCLUDE_DIR $CPPFLAGS"
  AC_CHECK_HEADER([boost/python.hpp],
                  [AC_DEFINE([HAVE_BOOST_PYTHON],,[define if the Boost::Python library is available])])
  CPPFLAGS=$ax_cv_boost_python_save_CPPFLAGS
  AC_LANG_POP([C++])

  ax_python_lib=boost_python
  AC_ARG_WITH([boost-python],
    AS_HELP_STRING([--with-boost-python],[specify the boost python library to use]),
    [ax_python_lib=$withval],
    [for suffix in mt st gcc-mt gcc gcc41-mt gcc41 gcc42-mt gcc42; do
        ax_python_lib_extra="$ax_python_lib_extra $ax_python_lib-$suffix";
     done;
     ax_python_lib="$ax_python_lib $ax_python_lib_extra"]
  )

  AS_VAR_PUSHDEF([ax_Search], [ax_cv_search])dnl
  AC_CACHE_CHECK([for Usable Boost::Python library], [ax_Search],
                 [AC_LANG_PUSH([C++])
                  ax_cv_search_save_CXXFLAGS=$CXXFLAGS
                  CXXFLAGS="-I$PYTHON_INCLUDE_DIR $CXXFLAGS"
                  ax_cv_search_save_LIBS=$LIBS
                  for ax_current_lib in $ax_python_lib; do
                    ax_res=-l$ax_current_lib
                    LIBS="-l$ax_current_lib -l$PYTHON_LIB $ax_cv_search_save_LIBS"
                    AC_LINK_IFELSE([#include <boost/python/module.hpp>
                                    using namespace boost::python;
                                    BOOST_PYTHON_MODULE(test) { throw "Boost::Python test."; }
                                    int main() {return 0;}],
                                   [AS_VAR_SET([ax_Search], [$ax_res])])
                    AS_VAR_SET_IF([ax_Search], [break])dnl
                  done
                  AS_VAR_SET_IF([ax_Search], , [AS_VAR_SET([ax_Search], [no])])
                  LIBS=$ax_cv_search_save_LIBS
                  AC_LANG_POP([C++])]
  )

  ax_res=AS_VAR_GET([ax_Search])
  AS_IF([test "$ax_res" != "no"],
        [BOOST_PYTHON_LIBS="$ax_res"
         AC_SUBST(BOOST_PYTHON_LIBS)
         AC_DEFINE([HAVE_BOOST_PYTHON],,[define if the Boost::Python library is available])],
        [AS_WARN([No suitable Boost::Python library found])])dnl
  AS_VAR_POPDEF([ax_Search])dnl
])
