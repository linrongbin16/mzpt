# lin-zsh-prompt

A zsh prompt theme implementation, inspired by [powerlevel10k](https://github.com/romkatv/powerlevel10k).

# Introduction

![screenshot.png](https://raw.githubusercontent.com/linrongbin16/lin-zsh-prompt-screenshot/main/screenshot-basic2.png)

- Left Side:
  - `username@hostname`: username and hostname.
  - ` ~/.lin-zsh-prompt`: operating system and working directory.
  - `( main*)`: git branch and modified/deleted/untracted files if exist.
  - `[√]/[?130]`: last command exit status.
- Right Side:
  - `( base)`: [miniconda](https://docs.conda.io/en/latest/miniconda.html) environment.
  - `09:31`: 24h-format local time (HH:mm).

# Requirement

- [nerd-fonts](https://github.com/ryanoasis/nerd-fonts) for icons.

# Installation

```bash
git clone https://github.com/linrongbin16/lin-zsh-prompt.git ~/.lin-zsh-prompt
echo '[ -f ~/.lin-zsh-prompt/lin-zsh-prompt.sh ] && source ~/.lin-zsh-prompt/lin-zsh-prompt.sh' >> ~/.zshrc
echo 'changeps1: False' >> ~/.condarc
```

# Reference

- [zsh - Functions](https://zsh.sourceforge.io/Doc/Release/Functions.html)
