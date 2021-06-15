#!/bin/bash
#shellcheck disable=2068

osxPkgs=('git' 'neovim' 'nodejs' 'npm' 'golang' 'viscosity' 'tmux' 'lulu' 'rectangle'                 \
         'easy-move-plus-resize' 'firefox' 'docker' 'coreutils' 'wget' 'weechat' 'zsh')

linuxPkgs=('git' 'neovim' 'nodejs' 'npm' 'golang' 'tmux' 'docker' 'coreutils' 'wget' 'weechat' 'zsh')

# If this is a mac, install homebrew & common pkg's
[[ $OSTYPE =~ "darwin"* ]] && {                                                                       \
  echo 'installing homebrew';                                                                         \
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"     \
    || exit 1;                                                                                        \
  echo 'installing packages';                                                                         \
  brew install ${osxPkgs[@]};                                                                         \
}

# If this is linux, figure out pkg manager & install common pkg's
[[ $OSTYPE =~ "linux"* ]] && {                                                                        \
  [[ $(id -u) == 0 ]] || { echo Must run as root; exit 1; };                                          \
  echo 'installing packages';                                                                         \
  grep -iq ubuntu /etc/issue && apt install -y ${linuxPkgs[@]} bind9utils build-essential;            \
  grep -iq 'Pop!_OS' /etc/issue && apt install -y ${linuxPkgs[@]} bind9utils build-essential;         \
  grep -iq arch /etc/issue && apt install -y ${linuxPkgs[@]} base-devel;                              \
}

printf 'installing oh-my-zsh for user: %s\n' "$SUDO_USER"
sudo -u "$SUDO_USER" -H \
  sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

exit 0
