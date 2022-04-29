set -x

_zsh_prompt_detect_conda() {
    if [[ -n "$CONDA_DEFAULT_ENV" ]]; then
        _ZSH_PROMPT_CONDA="( $CONDA_DEFAULT_ENV) "
    else
        _ZSH_PROMPT_CONDA=""
    fi
}

_zsh_prompt_detect_git_branch1() {
    git branch --show-current 2>/dev/null
}

_zsh_prompt_detect_git_branch2() {
    local _save_dir=$(pwd)
    while true; do
        local _current_dir=$(pwd)
        if [[ "$_current_dir" == "/" ]]; then
            local _head="$_current_dir.git/HEAD"
        else
            local _head="$_current_dir/.git/HEAD"
        fi
        if [ -r $_head ]; then
            local _branch=$(cat "$_head")
            if [[ "$_branch" =~ "^ref: refs/heads/.*" ]]; then
                echo ${_branch:16}
            fi
            break
        fi
        if [[ "$_current_dir" == "/" ]]; then
            echo ""
            break
        fi
        cd ..
    done
    cd $_save_dir 2>/dev/null
}

_zsh_prompt_detect_git() {
    local _git_branch=$(_zsh_prompt_detect_git_branch2)
    if [ ! -z "$_git_branch" ]; then
        if [ ! -z "$(git ls-files --exclude-standard --others -md 2>/dev/null)" ]; then
            _ZSH_PROMPT_GIT="( $_git_branch*) "
        else
            _ZSH_PROMPT_GIT="( $_git_branch) "
        fi
    else
        _ZSH_PROMPT_GIT=""
    fi
}

_zsh_prompt_detect_os() {
    local _os_name="$(uname -s)"
    case "$_os_name" in
        Linux)
            if [ -f /etc/arch-release ] || [ -f /etc/artix-release ]; then
                _ZSH_PROMPT_OS=" "
            elif [ -f /etc/fedora-release ]; then
                _ZSH_PROMPT_OS=" "
            elif [ -f /etc/redhat-release ]; then
                _ZSH_PROMPT_OS=" "
            elif [ -f /etc/gentoo-release ]; then
                _ZSH_PROMPT_OS=" "
            elif [ -r /etc/os-release ]; then
                while IFS= read -r _one_line; do
                    if [[ "$_one_line" =~ ^ID=.* ]]; then
                        local _distribution_name=${_one_line:3}
                        case "$_distribution_name"  in
                            *debian*) _ZSH_PROMPT_OS=" " ;;
                            *ubuntu*) _ZSH_PROMPT_OS=" " ;;
                            *linuxmint*) _ZSH_PROMPT_OS=" " ;;
                            *fedora*) _ZSH_PROMPT_OS=" " ;;
                            *centos*) _ZSH_PROMPT_OS=" " ;;
                            *opensuse*|*tumbleweed*) _ZSH_PROMPT_OS=" " ;;
                            *arch*) _ZSH_PROMPT_OS=" " ;;
                            *manjaro*) _ZSH_PROMPT_OS=" " ;;
                            *gentoo*) _ZSH_PROMPT_OS=" " ;;
                            *elementary*) _ZSH_PROMPT_OS=" " ;;
                            *) _ZSH_PROMPT_OS=" " ;;
                        esac
                        break
                    fi
                done < "/etc/os-release"
            else
                _ZSH_PROMPT_OS=" "
            fi
            ;;
        *BSD|DragonFly) _ZSH_PROMPT_OS=" " ;;
        Darwin) _ZSH_PROMPT_OS=" " ;;
        Windows*|CYGWINN*|MSYS*) _ZSH_PROMPT_OS=" " ;;
        *) _ZSH_PROMPT_OS=" " ;;
    esac
}

_zsh_prompt_detect_hostname() {
    _ZSH_PROMPT_HOSTNAME=$(hostname)
}

_zsh_prompt_delimiter() {
    # detect exit code first since
    local _exit_code_len=${#_ZSH_PROMPT_EXIT_CODE}
    if [ $_ZSH_PROMPT_EXIT_CODE -ne 0 ]; then
        _exit_code_len=$(($_exit_code_len+1))
    fi
    local _conda_len=${#_ZSH_PROMPT_CONDA}
    local _username_len=${#USERNAME}
    local _hostname_len=${#_ZSH_PROMPT_HOSTNAME}
    local _os_len=${#_ZSH_PROMPT_OS}
    local _dir_value=$(dirs)
    local _dir_len=${#_dir_value}
    local _git_len=${#_ZSH_PROMPT_GIT}
    local _left_len=$(($_username_len+1+$_hostname_len+1+$_os_len+$_dir_len+1+$_git_len))
    local _right_len=$((1+$_conda_len+6+2+$_exit_code_len))
    local _delimiter_len=$(($COLUMNS-$_left_len-$_right_len))
    _ZSH_PROMPT_DELIMITER=$(printf "%${_delimiter_len}s" | tr " " "─")
}

_zsh_prompt_precmd() {
    # cache exit code immediately
    _ZSH_PROMPT_EXIT_CODE=$?
    _zsh_prompt_detect_os
    _zsh_prompt_detect_hostname
    _zsh_prompt_detect_conda
    _zsh_prompt_detect_git
    _zsh_prompt_delimiter
}

precmd_functions+=( _zsh_prompt_precmd )

setopt prompt_subst

export PROMPT='%F{cyan}%n%f@%F{#9933FF}%M%f %F{blue}${_ZSH_PROMPT_OS}%~%f %F{magenta}${_ZSH_PROMPT_GIT}%f%F{#606060}${_ZSH_PROMPT_DELIMITER}%f %F{#FF8000}${_ZSH_PROMPT_CONDA}%f%D{%H:%M} [%(?.%F{green}√.%F{red}?%?)%f]
%F{blue}%(!.#.$)%f '
