#!/bin/sh

# this is the latest commit i've found
# that all my patches apply cleanly
#COMMIT=723ff26

download() {
    rm -rf $name 2> /dev/null
    git clone https://git.suckless.org/$name
    cd $name
    #git fetch --all
#    git reset --hard $COMMIT
    cd - > /dev/null
}

patchall() {
    for patch in $(ls patches) ; do
        patch -p0 < patches/$patch
    done
}

build() {
    cd $name
    make
    make install
    cd - > /dev/null
}

clean() {
    cd $name
    for junk in FAQ LEGACY TODO.md README '*.orig' '*.rej' ; do
        rm -f $junk 2> /dev/null
    done
    make clean
    cd - > /dev/null
}

main() {
    download
    patchall
    cp -f config/config.h $name/config.h
    cp -f config/config.mk $name/config.mk
    build
    clean > /dev/null
}

name=st main