FROM ubuntu:18.04

ENV HOME=/home/dev
ENV DEBIAN_FRONTEND=noninteractive

#RUN yes | unminimize

# for neovim > v0.2
RUN apt update && apt install -y software-properties-common && add-apt-repository ppa:neovim-ppa/stable 
# Package setup
RUN apt update && apt install -y \
  build-essential \
  curl \
  tmux \
  gcc \
  iputils-ping \
  git \
  sudo \
  man-db \
  golang \
  neovim \
  curl \
  make \
  bind9utils \
  python3-pip \
  pylint3 \
  ipython3 \
  shellcheck \
  weechat

# nodejs v8.10.0 won't cut it for coc.nvim
RUN curl -sL install-node.now.sh/lts > /install-node && chmod +x /install-node && ./install-node --yes

## User setup
RUN groupadd -r dev && useradd -lmrg dev dev -s /bin/bash
RUN usermod -aG sudo dev

## Disable su root
RUN chsh -s /usr/sbin/nologin root

# Switch to dev user
USER dev

# config files
RUN mkdir -p /home/dev/.config/nvim
COPY bashrc /home/dev/.bashrc
COPY screenrc /home/dev/.screenrc
COPY tmux.conf /home/dev/.tmux.conf
COPY vimrc /home/dev/.config/nvim/init.vim

## Neovim setup
# vim-plug
RUN sh -c 'curl -fLo /home/dev/.local/share/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
RUN nvim --headless +PlugInstall +qall

# neovim pip package
RUN pip3 install -U neovim

# CoC nvim language completion packages
RUN nvim --headless +'CocInstall -sync coc-markdownlint coc-tsserver coc-json coc-html coc-css coc-pyright coc-go coc-sh coc-clangd coc-cmake sql-language-server'   +qall

