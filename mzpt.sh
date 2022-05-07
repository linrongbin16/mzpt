_mzpt_conda() {
    if [[ -n "$CONDA_DEFAULT_ENV" ]]; then
        _MZPT_CONDA="( $CONDA_DEFAULT_ENV) "
    else
        _MZPT_CONDA=""
    fi
}

_mzpt_git_cmd() {
    _MZPT_GIT=''
    _MZPT_GIT_LEN=0
    local branch=$(git branch --show-current 2>/dev/null)
    if [ ! -z "$branch" ]; then
        local status=$(git status --short 2>/dev/null)
        if [ ! -z "$status" ]; then
            local p="( $branch*) "
        else
            local p="( $branch) "
        fi
        _MZPT_GIT="%F{magenta}$p%f"
        _MZPT_GIT_LEN=${#p}
    fi
}

_mzpt_gitstatus() {
    _MZPT_GIT=''
    _MZPT_GIT_LEN=0
    if [ $GITSTATUS_PROMPT_LEN -gt 0 ]; then
        local branch=${GITSTATUS_PROMPT//"%76F"/"%F{magenta}"}
        _MZPT_GIT="%F{magenta}( $branch%F{magenta})%f "
        _MZPT_GIT_LEN=$(($GITSTATUS_PROMPT_LEN+5))
    fi
}

_mzpt_git() {
    local exist=${GITSTATUS_PROMPT_LEN+x}
    if [ ${#exist} -gt 0 ]; then
        _mzpt_gitstatus
    else
        _mzpt_git_cmd
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

_mzpt_hostname() {
    local _hostname=$(hostname)
    _MZPT_HOSTNAME_LEN=${#_hostname}
}

_mzpt_delimiter() {
    local _exit_code_len=${#_MZPT_SAVED_EXIT_CODE}
    if [ $_MZPT_SAVED_EXIT_CODE -ne 0 ]; then
        _exit_code_len=$(($_exit_code_len+1))
    fi
    local _conda_len=${#_MZPT_CONDA}
    local _username_len=${#USERNAME}
    local _os_len=${#_MZPT_OS}
    local _dir_value=$(dirs)
    local _dir_len=${#_dir_value}
    local _left_len=$(($_username_len+1+$_MZPT_HOSTNAME_LEN+1+$_os_len+$_dir_len+1+$_MZPT_GIT_LEN+2+$_exit_code_len))
    local _right_len=$((1+$_conda_len+6))
    local _delimiter_len=$(($COLUMNS-$_left_len-$_right_len))
    _MZPT_DELIMITER=$(printf "%${_delimiter_len}s" | tr " " "─")
}

_mzpt_precmd() {
    # cache exit code immediately
    _MZPT_SAVED_EXIT_CODE=$?
    _mzpt_git
    _mzpt_conda
    _mzpt_delimiter
}

_mzpt_os
_mzpt_hostname

precmd_functions+=( _mzpt_precmd )

setopt prompt_subst

export PROMPT='%F{cyan}%n%f@%F{#9933FF}%M%f %F{blue}${_MZPT_OS}%~%f ${_MZPT_GIT}[%(?.%F{green}√.%F{red}?%?)%f] %F{#606060}${_MZPT_DELIMITER}%f %F{#FF8000}${_MZPT_CONDA}%f%D{%H:%M}
%F{blue}%(!.#.$)%f '
