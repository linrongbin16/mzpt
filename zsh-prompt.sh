# zsh theme
my_precmd_detect_conda() {
    if [[ -n $CONDA_PREFIX ]]; then
        if [[ $(basename $CONDA_PREFIX) == "miniconda3" ]]; then
            # Without this, it would display conda version
            MY_PROMPT_CONDA_ENV="base"
        else
            # For all environments that aren't (base)
            MY_PROMPT_CONDA_ENV="$(basename $CONDA_PREFIX)"
        fi
        MY_PROMPT_CONDA_ENV="( ${MY_PROMPT_CONDA_ENV}) "
    else
        # When no conda environment is active, don't show anything
        MY_PROMPT_CONDA_ENV=""
    fi
}

my_precmd_detect_git() {
    if git status >/dev/null 2>&1; then
        MY_PROMPT_GIT_BRANCH_ENV="$(git symbolic-ref HEAD 2>/dev/null|cut -d/ -f3-)"
        if [ ! -z "$(git ls-files -d)" ]; then
            MY_PROMPT_GIT_BRANCH_ENV="${MY_PROMPT_GIT_BRANCH_ENV}*"
        elif [ ! -z "$(git ls-files -m)" ]; then
            MY_PROMPT_GIT_BRANCH_ENV="${MY_PROMPT_GIT_BRANCH_ENV}*"
        elif [ ! -z "$(git ls-files . --exclude-standard --others)" ]; then
            MY_PROMPT_GIT_BRANCH_ENV="${MY_PROMPT_GIT_BRANCH_ENV}*"
        fi
        MY_PROMPT_GIT_BRANCH_ENV="( ${MY_PROMPT_GIT_BRANCH_ENV}) "
    else
        MY_PROMPT_GIT_BRANCH_ENV=""
    fi
}

my_precmd_detect_os() {
    local MY_PROMPT_OS_NAME="$(uname -s)"
    MY_PROMPT_OS_ENV=""
    case "$MY_PROMPT_OS_NAME" in
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
