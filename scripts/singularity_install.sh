#! /bin/bash

GO_VERSION=1.13
SINGULARITY_VERSION=v3.6.3
OS=linux
ARCH=amd64

install_dependencies() {
    sudo apt-get update && sudo apt-get install -y \
        build-essential \
        libssl-dev \
        uuid-dev \
        libgpgme11-dev \
        squashfs-tools \
        libseccomp-dev \
        pkg-config
}

install_go() {
    wget https://dl.google.com/go/go$GO_VERSION.$OS-$ARCH.tar.gz
    sudo tar -C /usr/local -xzvf go$GO_VERSION.$OS-$ARCH.tar.gz
    rm go$GO_VERSION.$OS-$ARCH.tar.gz
    echo "export GOPATH=${HOME}/go" >> ~/.bashrc
    echo "export PATH=/usr/local/go/bin:${PATH}:${GOPATH}/bin" >> ~/.bashrc
    . ~/.bashrc
}

install_singularity() {
    export GOPATH=${HOME}/go
    export PATH=/usr/local/go/bin:${PATH}:${GOPATH}/bin
    go get -u github.com/golang/dep/cmd/dep
    go get -d github.com/sylabs/singularity
    cd "$GOPATH/src/github.com/sylabs/singularity" || exit
    git fetch
    git checkout "$SINGULARITY_VERSION" 
    ./mconfig
    make -C ./builddir
    sudo make -C ./builddir install
}

install_dependencies
install_go
install_singularity
