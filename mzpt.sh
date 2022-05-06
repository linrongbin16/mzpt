_mzpt_conda() {
    if [[ -n "$CONDA_DEFAULT_ENV" ]]; then
        _MZPT_CONDA="( $CONDA_DEFAULT_ENV) "
    else
        _MZPT_CONDA=""
    fi
}

_mzpt_git() {
    local _git_branch=$(git branch --show-current 2>/dev/null)
    if [ ! -z "$_git_branch" ]; then
        local _git_status=$(git status --short 2>/dev/null)
        if [ ! -z "$_git_status" ]; then
            _MZPT_GIT="( $_git_branch*) "
        else
            _MZPT_GIT="( $_git_branch) "
        fi
    else
        _MZPT_GIT=""
    fi
}

_mzpt_os() {
    local _os_name="$(uname -s)"
    case "$_os_name" in
        Linux)
            if [ -f /etc/arch-release ] || [ -f /etc/artix-release ]; then
                _MZPT_OS=" "
            elif [ -f /etc/fedora-release ]; then
                _MZPT_OS=" "
            elif [ -f /etc/redhat-release ]; then
                _MZPT_OS=" "
            elif [ -f /etc/gentoo-release ]; then
                _MZPT_OS=" "
            elif [ -r /etc/os-release ]; then
                while IFS= read -r _one_line; do
                    if [[ "$_one_line" =~ ^ID=.* ]]; then
                        local _distribution_name=${_one_line:3}
                        case "$_distribution_name"  in
                            *debian*) _MZPT_OS=" " ;;
                            *ubuntu*) _MZPT_OS=" " ;;
                            *linuxmint*) _MZPT_OS=" " ;;
                            *fedora*) _MZPT_OS=" " ;;
                            *centos*) _MZPT_OS=" " ;;
                            *opensuse*|*tumbleweed*) _MZPT_OS=" " ;;
                            *arch*) _MZPT_OS=" " ;;
                            *manjaro*) _MZPT_OS=" " ;;
                            *gentoo*) _MZPT_OS=" " ;;
                            *elementary*) _MZPT_OS=" " ;;
                            *) _MZPT_OS=" " ;;
                        esac
                        break
                    fi
                done < "/etc/os-release"
            else
                _MZPT_OS=" "
            fi
            ;;
        *BSD|DragonFly) _MZPT_OS=" " ;;
        Darwin) _MZPT_OS=" " ;;
        Windows*|CYGWINN*|MSYS*) _MZPT_OS=" " ;;
        *) _MZPT_OS=" " ;;
    esac
}

_mzpt_delimiter() {
    # detect exit code first since
    local _exit_code_len=${#_MZPT_EXIT_CODE}
    if [ $_MZPT_EXIT_CODE -ne 0 ]; then
        _exit_code_len=$(($_exit_code_len+1))
    fi
    local _conda_len=${#_MZPT_CONDA}
    local _username_len=${#USERNAME}
    local _hostname=$(hostname)
    local _hostname_len=${#_hostname}
    local _os_len=${#_MZPT_OS}
    local _dir_value=$(dirs)
    local _dir_len=${#_dir_value}
    local _git_len=${#_MZPT_GIT}
    local _left_len=$(($_username_len+1+$_hostname_len+1+$_os_len+$_dir_len+1+$_git_len+2+$_exit_code_len))
    local _right_len=$((1+$_conda_len+6))
    local _delimiter_len=$(($COLUMNS-$_left_len-$_right_len))
    _MZPT_DELIMITER=$(printf "%${_delimiter_len}s" | tr " " "─")
}

_mzpt_precmd() {
    # cache exit code immediately
    _MZPT_EXIT_CODE=$?
    _mzpt_os
    _mzpt_conda
    _mzpt_git
    _mzpt_delimiter
}

precmd_functions+=( _mzpt_precmd )

setopt prompt_subst

export PROMPT='%F{cyan}%n%f@%F{#9933FF}%M%f %F{blue}${_MZPT_OS}%~%f %F{magenta}${_MZPT_GIT}%f[%(?.%F{green}√.%F{red}?%?)%f] %F{#606060}${_MZPT_DELIMITER}%f %F{#FF8000}${_MZPT_CONDA}%f%D{%H:%M}
%F{blue}%(!.#.$)%f '
