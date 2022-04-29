# zsh-prompt

A prompt theme for zsh

# Introduction

![screenshot.png](https://raw.githubusercontent.com/linrongbin16/zsh-prompt-screenshot/main/screenshot-basic1.png)

- `( base)`: [miniconda](https://docs.conda.io/en/latest/miniconda.html) environment.
- `username@hostname`: username and hostname.
- ` ~/.zsh-prompt`: operating system and working directory.
- `( main*)`: git branch and changes if exist.
- `09:31`: 24h-format local time (HH:mm).
- `[√]/[?130]`: last command exit status.

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
