
# autoload function path
fpath=($fpath ~/.zsh-prompt)
autoload -Uz _detect_conda
autoload -Uz _detect_git
autoload -Uz _detect_os

_detect() {
    _detect_conda
    _detect_git
    _detect_os
}

precmd_functions+=( _detect_os )
chpwd_functions+=( _detect_git )
preexec_functions+=( _detect_conda )
preexec_functions+=( _detect_git )

setopt prompt_subst

export PROMPT='%F{#FF8000}${_PROMPT_CONDA_ENV}%f%F{cyan}%n%f@%F{#9933FF}%M%f %F{blue}${_PROMPT_OS_ENV}%~%f %F{magenta}${_PROMPT_GIT_ENV}%f%D{%H:%M} [%(?.%F{green}√.%F{red}?%?)%f]
%F{blue}%(!.#.$)%f '
