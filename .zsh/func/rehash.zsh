if [[ $OSTYPE == linux* ]]; then
  function mean {
    ionice -c1 -n0 chrt -r 99 nice -n -20 "$@"
  }
fi

() {
  emulate -L zsh
  setopt function_argzero err_return no_unset warn_create_global
  # We set 0 to RANDOM here to prevent name clashes since an anonymous
  # function is always called (anon)
  local 0="$0_$RANDOM"
  zmodload -F zsh/stat +b:zstat
  typeset -gi LAST_REHASH
  function rehash-if-needed {
    emulate -L zsh
    setopt err_return warn_create_global
    local rehash_trigger=${TMPDIR:-/tmp}/zsh-needs-rehash
    if [[ -f $rehash_trigger ]]; then
      typeset -A stats
      zstat -H stats +mtime $rehash_trigger
      if [[ $LAST_REHASH -lt $stats[mtime] ]]; then
        hash -r
        LAST_REHASH=$stats[mtime]
      fi
    fi
  }
  add-zsh-hook preexec rehash-if-needed

  function exec-and-trigger-rehash {
    emulate -L zsh
    setopt err_return warn_create_global
    local rehash_trigger=${TMPDIR:-/tmp}/zsh-needs-rehash
    integer code
    local cmd=$1
    shift
    command $cmd "$@" || code=$?
    builtin echo -n > $rehash_trigger
    return $code
  }

  function $0_wrap_if_found {
    local cmd
    for cmd in "$@"; do
      if (( $+commands[$cmd] )); then
        function $cmd {
          setopt local_options function_argzero
          exec-and-trigger-rehash $0 "$@"
        }
      fi
    done
  }

  $0_wrap_if_found brew dpkg apt-get aptitude yum rpm
  } always {
    builtin unfunction unfunction
    unfunction unalias
    unfunction -m "$0_*"
  }
}

