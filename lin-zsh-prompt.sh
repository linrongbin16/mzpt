_lin_zsh_prompt_detect_conda() {
    if [[ -n "$CONDA_DEFAULT_ENV" ]]; then
        _LIN_ZSH_PROMPT_CONDA="( $CONDA_DEFAULT_ENV) "
    else
        _LIN_ZSH_PROMPT_CONDA=""
    fi
}

_lin_zsh_prompt_detect_git_branch1() {
    git branch --show-current 2>/dev/null
}

_lin_zsh_prompt_detect_git_branch2() {
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

_lin_zsh_prompt_detect_git() {
    local _git_branch=$(_lin_zsh_prompt_detect_git_branch2)
    if [ ! -z "$_git_branch" ]; then
        if [ ! -z "$(git ls-files --exclude-standard --others -md 2>/dev/null)" ]; then
            _LIN_ZSH_PROMPT_GIT="( $_git_branch*) "
        else
            _LIN_ZSH_PROMPT_GIT="( $_git_branch) "
        fi
    else
        _LIN_ZSH_PROMPT_GIT=""
    fi
}

_lin_zsh_prompt_detect_os() {
    local _os_name="$(uname -s)"
    case "$_os_name" in
        Linux)
            if [ -f /etc/arch-release ] || [ -f /etc/artix-release ]; then
                _LIN_ZSH_PROMPT_OS=" "
            elif [ -f /etc/fedora-release ]; then
                _LIN_ZSH_PROMPT_OS=" "
            elif [ -f /etc/redhat-release ]; then
                _LIN_ZSH_PROMPT_OS=" "
            elif [ -f /etc/gentoo-release ]; then
                _LIN_ZSH_PROMPT_OS=" "
            elif [ -r /etc/os-release ]; then
                while IFS= read -r _one_line; do
                    if [[ "$_one_line" =~ ^ID=.* ]]; then
                        local _distribution_name=${_one_line:3}
                        case "$_distribution_name"  in
                            *debian*) _LIN_ZSH_PROMPT_OS=" " ;;
                            *ubuntu*) _LIN_ZSH_PROMPT_OS=" " ;;
                            *linuxmint*) _LIN_ZSH_PROMPT_OS=" " ;;
                            *fedora*) _LIN_ZSH_PROMPT_OS=" " ;;
                            *centos*) _LIN_ZSH_PROMPT_OS=" " ;;
                            *opensuse*|*tumbleweed*) _LIN_ZSH_PROMPT_OS=" " ;;
                            *arch*) _LIN_ZSH_PROMPT_OS=" " ;;
                            *manjaro*) _LIN_ZSH_PROMPT_OS=" " ;;
                            *gentoo*) _LIN_ZSH_PROMPT_OS=" " ;;
                            *elementary*) _LIN_ZSH_PROMPT_OS=" " ;;
                            *) _LIN_ZSH_PROMPT_OS=" " ;;
                        esac
                        break
                    fi
                done < "/etc/os-release"
            else
                _LIN_ZSH_PROMPT_OS=" "
            fi
            ;;
        *BSD|DragonFly) _LIN_ZSH_PROMPT_OS=" " ;;
        Darwin) _LIN_ZSH_PROMPT_OS=" " ;;
        Windows*|CYGWINN*|MSYS*) _LIN_ZSH_PROMPT_OS=" " ;;
        *) _LIN_ZSH_PROMPT_OS=" " ;;
    esac
}

_lin_zsh_prompt_detect_hostname() {
    _LIN_ZSH_PROMPT_HOSTNAME=$(hostname)
}

_lin_zsh_prompt_delimiter() {
    # detect exit code first since
    local _exit_code_len=${#_LIN_ZSH_PROMPT_EXIT_CODE}
    if [ $_LIN_ZSH_PROMPT_EXIT_CODE -ne 0 ]; then
        _exit_code_len=$(($_exit_code_len+1))
    fi
    local _conda_len=${#_LIN_ZSH_PROMPT_CONDA}
    local _username_len=${#USERNAME}
    local _hostname_len=${#_LIN_ZSH_PROMPT_HOSTNAME}
    local _os_len=${#_LIN_ZSH_PROMPT_OS}
    local _dir_value=$(dirs)
    local _dir_len=${#_dir_value}
    local _git_len=${#_LIN_ZSH_PROMPT_GIT}
    local _left_len=$(($_username_len+1+$_hostname_len+1+$_os_len+$_dir_len+1+$_git_len+2+$_exit_code_len))
    local _right_len=$((1+$_conda_len+6))
    local _delimiter_len=$(($COLUMNS-$_left_len-$_right_len))
    _LIN_ZSH_PROMPT_DELIMITER=$(printf "%${_delimiter_len}s" | tr " " "─")
}

_lin_zsh_prompt_precmd() {
    # cache exit code immediately
    _LIN_ZSH_PROMPT_EXIT_CODE=$?
    _lin_zsh_prompt_detect_os
    _lin_zsh_prompt_detect_hostname
    _lin_zsh_prompt_detect_conda
    _lin_zsh_prompt_detect_git
    _lin_zsh_prompt_delimiter
}

precmd_functions+=( _lin_zsh_prompt_precmd )

setopt prompt_subst

export PROMPT='%F{cyan}%n%f@%F{#9933FF}%M%f %F{blue}${_LIN_ZSH_PROMPT_OS}%~%f %F{magenta}${_LIN_ZSH_PROMPT_GIT}%f[%(?.%F{green}√.%F{red}?%?)%f] %F{#606060}${_LIN_ZSH_PROMPT_DELIMITER}%f %F{#FF8000}${_LIN_ZSH_PROMPT_CONDA}%f%D{%H:%M}
%F{blue}%(!.#.$)%f '
