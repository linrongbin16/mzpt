# zsh-prompt

A zsh prompt theme implementation, inspired by [powerlevel10k](https://github.com/romkatv/powerlevel10k).

# Introduction

![screenshot.png](https://raw.githubusercontent.com/linrongbin16/zsh-prompt-screenshot/main/screenshot-basic2.png)

- Left Side:
  - `username@hostname`: username and hostname.
  - ` ~/.zsh-prompt`: operating system and working directory.
  - `( main*)`: git branch and modified/deleted/untracted files if exist.
  - `[√]/[?130]`: last command exit status.
- Right Side:
  - `( base)`: [miniconda](https://docs.conda.io/en/latest/miniconda.html) environment.
  - `09:31`: 24h-format local time (HH:mm).

# Requirement

- [nerd-fonts](https://github.com/ryanoasis/nerd-fonts) for icons.

# Installation

```bash
git clone https://github.com/linrongbin16/zsh-prompt.git ~/.zsh-prompt
echo '[ -f ~/.zsh-prompt/zsh-prompt.sh ] && source ~/.zsh-prompt/zsh-prompt.sh' >> ~/.zshrc
echo 'changeps1: False' >> ~/.condarc
```

# Reference

- [zsh - Functions](https://zsh.sourceforge.io/Doc/Release/Functions.html)
