# zsh theme
my_precmd_detect_conda() {
    if [[ -n "$CONDA_PREFIX" ]]; then
        local conda_name="$(basename $CONDA_PREFIX)"
        if [[ "$conda_name" == "miniconda3" ]]; then
            # Without this, it would display conda version
            MY_PROMPT_CONDA_ENV="( base)"
        else
            # For all environments that aren't (base)
            MY_PROMPT_CONDA_ENV="( $conda_name)"
        fi
    else
        # When no conda environment is active, don't show anything
        MY_PROMPT_CONDA_ENV=""
    fi
}

my_precmd_detect_git() {
    local git_branch_name="$(git branch --show-current 2>/dev/null)"
    if [ ! -z "$git_branch_name" ]; then
        if [ ! -z "$(git ls-files --exclude-standard --others -md)" ]; then
            MY_PROMPT_GIT_BRANCH_ENV="( $git_branch_name*)"
        else
            MY_PROMPT_GIT_BRANCH_ENV="( $git_branch_name)"
        fi
    else
        MY_PROMPT_GIT_BRANCH_ENV=""
    fi
}

my_precmd_detect_os() {
    # cache OS env since it's not change
    if [ ! -z "$MY_PROMPT_OS_ENV" ]; then
        return
    fi
    local os_name="$(uname -s)"
    case "$os_name" in
        Linux)
            if [ -f "/etc/arch-release" ] || [ -f "/etc/artix-release" ]; then
                MY_PROMPT_OS_ENV=" "
            elif [ -f "/etc/fedora-release" ]; then
                MY_PROMPT_OS_ENV=" "
            elif [ -f "/etc/redhat-release" ]; then
                MY_PROMPT_OS_ENV=" "
            elif [ -f "/etc/gentoo-release" ]; then
                MY_PROMPT_OS_ENV=" "
            elif [ -f "/etc/os-release" ]; then
                if cat /etc/os-release | grep Ubuntu >/dev/null 2>&1; then
                    MY_PROMPT_OS_ENV=" "
                elif cat /etc/os-release | grep Debian >/dev/null 2>&1; then 
                    MY_PROMPT_OS_ENV=" "
                elif cat /etc/os-release | grep CentOS >/dev/null 2>&1; then 
                    MY_PROMPT_OS_ENV=" "
                else
                    MY_PROMPT_OS_ENV=" "
                fi
            else
                MY_PROMPT_OS_ENV=" "
            fi
            ;;
        *BSD)
            MY_PROMPT_OS_ENV=" "
            ;;
        Darwin)
            MY_PROMPT_OS_ENV=" "
            ;;
        WindowsNT)
            MY_PROMPT_OS_ENV=" "
            ;;
        *)
            MY_PROMPT_OS_ENV=" "
            ;;
    esac
}

# Run the previously defined function before each prompt
precmd_functions+=( my_precmd_detect_conda )
precmd_functions+=( my_precmd_detect_git)
precmd_functions+=( my_precmd_detect_os )

setopt prompt_subst

export PROMPT='%F{#FF8000}${MY_PROMPT_CONDA_ENV}%f%F{cyan}%n%f@%F{#9933FF}%M%f %F{blue}${MY_PROMPT_OS_ENV}%~%f %F{magenta}${MY_PROMPT_GIT_BRANCH_ENV}%f%D{%H:%M} [%(?.%F{green}√.%F{red}?%?)%f]
%F{blue}%(!.#.$)%f '
