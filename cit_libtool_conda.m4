# CIT_LIBTOOL_CONDA_FIX_CRT_OBJECTS
# Override libtool's CRT object handling for conda environments
AC_DEFUN([CIT_LIBTOOL_CONDA_FIX_CRT_OBJECTS], [
  AC_REQUIRE([LT_INIT])
  
  AC_ARG_ENABLE([libtool-crt-fix],
    [AS_HELP_STRING([--enable-libtool-crt-fix],
      [disable libtool CRT object handling for conda environments (default: auto)])],
    [enable_libtool_crt_fix=$enableval],
    [enable_libtool_crt_fix=auto])
  
  if test "$enable_libtool_crt_fix" = "auto"; then
    # Auto-detect: check both environment and compiler path
    if test -n "$CONDA_PREFIX" || test -n "$MAMBA_ROOT_PREFIX"; then
      enable_libtool_crt_fix=yes
    elif echo "$CC" | grep -q "conda\|micromamba"; then
      enable_libtool_crt_fix=yes
    else
      enable_libtool_crt_fix=no
    fi
  fi
  
  if test "$enable_libtool_crt_fix" = "yes"; then
    case "$host_os" in
      linux*)
        predep_objects=""
        postdep_objects=""
        postdeps=""
        predeps=""
        AC_MSG_NOTICE([Disabling libtool CRT objects])
        ;;
    esac
  fi
])

