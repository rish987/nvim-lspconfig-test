FROM ubuntu:latest AS base

RUN yes | unminimize

RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime && \
    apt-get install -y tzdata && \
    dpkg-reconfigure --frontend noninteractive tzdata

# Base deps
RUN apt update
RUN apt install -y \
    curl \
    git \
    gzip \
    haskell-platform \
    python3 \
    python3-pip \
    software-properties-common \
    tar \
    unzip \
    wget

# Dart
RUN wget -qO- https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - && \
    wget -qO- https://storage.googleapis.com/download.dartlang.org/linux/debian/dart_stable.list > /etc/apt/sources.list.d/dart_stable.list

# Dotnet
RUN wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb

# Ocaml
RUN add-apt-repository ppa:avsm/ppa

RUN apt update
RUN apt install -y dart
RUN apt install -y dotnet-sdk-5.0
RUN apt install -y ocaml opam

RUN opam init -y && opam install -y merlin

# Neovim
RUN wget -O /opt/nvim-linux64.tar.gz https://github.com/neovim/neovim/releases/download/nightly/nvim-linux64.tar.gz && \
    tar -xvf /opt/nvim-linux64.tar.gz -C /opt

# Ruby
RUN apt install -y ruby ruby-dev

# PHP
RUN apt install -y php-cli && \
    curl -fsSL https://getcomposer.org/installer -o /tmp/composer-setup.php && \
    php /tmp/composer-setup.php --install-dir=/usr/local/bin --filename=composer

# Node.js
RUN KEYRING=/usr/share/keyrings/nodesource.gpg; VERSION=node_16.x; DISTRO="$(lsb_release -s -c)"; \
    curl -fsSL https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --dearmor | tee "$KEYRING" > /dev/null && \
    gpg --no-default-keyring --keyring "$KEYRING" --list-keys && \
    echo "deb [signed-by=$KEYRING] https://deb.nodesource.com/$VERSION $DISTRO main" | tee /etc/apt/sources.list.d/nodesource.list && \
    echo "deb-src [signed-by=$KEYRING] https://deb.nodesource.com/$VERSION $DISTRO main" | tee -a /etc/apt/sources.list.d/nodesource.list && \
    apt update && apt install -y nodejs

ENV PATH "/root/.opam/default/bin:/usr/lib/dart/bin:/opt/nvim-linux64/bin:${PATH}"
