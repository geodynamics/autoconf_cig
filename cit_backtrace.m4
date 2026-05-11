AC_DEFUN([CIT_CHECK_BACKTRACE],
[
    AC_MSG_CHECKING([for execinfo.h and backtrace support])

    dnl --------------------------------------------------------
    dnl Check for the execinfo.h header
    dnl --------------------------------------------------------
    AC_CHECK_HEADERS([execinfo.h],
        [ax_have_execinfo_h=yes],
        [ax_have_execinfo_h=no])

    dnl --------------------------------------------------------
    dnl Check for backtrace() and backtrace_symbols()
    dnl --------------------------------------------------------
    AC_CHECK_FUNCS([backtrace backtrace_symbols],
        [ax_have_backtrace_funcs=yes],
        [ax_have_backtrace_funcs=no])

    dnl --------------------------------------------------------
    dnl Combine results
    dnl --------------------------------------------------------
    if test "x$ax_have_execinfo_h" = "xyes" && \
       test "x$ax_have_backtrace_funcs" = "xyes"; then
        AC_DEFINE([HAVE_BACKTRACE], [1],
                  [Define if backtrace() and execinfo.h are available])
        ax_have_backtrace=yes
        AC_MSG_RESULT([yes])
    else
        ax_have_backtrace=no
        AC_MSG_RESULT([no])
    fi
])
