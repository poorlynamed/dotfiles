FROM ubuntu:22.04

ENV HOME=/home/dev
ENV DEBIAN_FRONTEND=noninteractive

#RUN yes | unminimize

# for neovim > v0.2
RUN apt update >/dev/null && \
  apt install -y software-properties-common >/dev/null && \
  add-apt-repository ppa:neovim-ppa/stable >/dev/null

# Package setup
RUN apt update && apt install -y \
  bind9utils                     \
  build-essential                \
  curl                           \
  fzf                            \
  gcc                            \
  git                            \
  iputils-ping                   \
  ipython3                       \
  make                           \
  man-db                         \
  neovim                         \
  ripgrep                        \
  shellcheck                     \
  sudo                           \
  tmux                           \
  weechat                        \
  wget                           \
  whois                          >/dev/null

# Install latest golang
RUN LATEST_GO=$(curl -s https://go.dev/VERSION?m=text);          \
  wget -q https://golang.org/dl/${LATEST_GO}.linux-amd64.tar.gz; \
  tar -C /usr/local -xzf ${LATEST_GO}.linux-amd64.tar.gz;        \
  rm ${LATEST_GO}.linux-amd64.tar.gz

# Install latest rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

# Install latest nodejs
RUN curl -sL install-node.now.sh/lts > /install-node && chmod +x /install-node && ./install-node --yes

## User setup
RUN groupadd -r dev && useradd -lmrg dev dev -s /bin/bash
RUN usermod -aG sudo dev

## Disable su root
RUN chsh -s /usr/sbin/nologin root

# Chnage all permissions
RUN bash -c 'chown -R dev:dev /home/dev'

# Switch to dev user
USER dev

## Neovim setup
RUN rm -rf /home/dev/.config/nvim
RUN git clone https://github.com/AstroNvim/AstroNvim /home/dev/.config/nvim
RUN nvim --headless +PackerSync +qall

# config files
COPY bashrc /home/dev/.bashrc
COPY screenrc /home/dev/.screenrc
COPY tmux.conf /home/dev/.tmux.conf
