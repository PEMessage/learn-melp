#!/bin/bash


set -e -x


apt_dep() {
    sudo apt-get install -y \
        autoconf \
        automake \
        bison \
        bzip2 \
        cmake \
        flex \
        g++ \
        gawk \
        gcc \
        gettext \
        git \
        gperf \
        help2man \
        libncurses5-dev \
        libtool \
        libtool-bin \
        make \
        patch \
        python3-dev \
        rsync \
        texinfo \
        unzip \
        wget \
        xz-utils
        # libstdc++6
}

crosstool-ng() {
    # other toolchain you could find
    # Vendor: Linaro Mentor_Graphic TimeSys MontaVista
    # Dirstro: Debian package system 
    # Cross Linux from scratch: trac.clfs.org
    # Yocto: https://downloads.yoctoproject.org/releases/yocto/yocto-4.3.2/toolchain/
    git clone https://github.com/crosstool-ng/crosstool-ng
    (
        cd crosstool-ng
        # git checkout crosstool-ng-1.24.0
        git checkout crosstool-ng-1.26.0
        ./bootstrap
        CFLAGS="-Og -ggdb" CXXFLAGS="-Og -ggdb" \
            ./configure --prefix=${PWD}
        make 
        make install
    )
}

# BeagleBone Black use another setup, This is for qemu
qemu_tool() {
    (
        cd crosstool-ng/bin
        bin/ct-ng list-samples
        # melp guide in book:
        #   bin/ct-ng show-arm-unkown-linux-gnueabi
        #   bin/ct-ng arm-unkown-linux-gnueabi
        bin/ct-ng show-aarch64-unknown-linux-gnu
        bin/ct-ng aarch64-unknown-linux-gnu
        # extra fix in order to build linux:
        #   # CT_PREFIX_DIR_RO is not set
        sed -i '/CT_PREFIX_DIR_RO/d' .config
        # Also setting this to under stand how it work
        # CT_DEBUG_CT=y
        # CT_DEBUG_PAUSE_STEPS=y

        bin/ct-ng build
        # =============================================
        # First: download and extract them
        # =============================================
        # Retrieving 'linux-6.4'
        # Verifying SHA512 checksum for 'linux-6.4.tar.xz'
        # Retrieving 'zlib-1.2.13'
        # Verifying SHA512 checksum for 'zlib-1.2.13.tar.xz'
        # Retrieving 'zstd-1.5.5'
        # Verifying SHA512 checksum for 'zstd-1.5.5.tar.gz'
        # Retrieving 'gmp-6.2.1'
        # Verifying SHA512 checksum for 'gmp-6.2.1.tar.xz'
        # Retrieving 'mpfr-4.2.1'
        # Verifying SHA512 checksum for 'mpfr-4.2.1.tar.xz'
        # Retrieving 'isl-0.26'
        # Verifying SHA512 checksum for 'isl-0.26.tar.xz'
        # Retrieving 'mpc-1.2.1'
        # Verifying SHA512 checksum for 'mpc-1.2.1.tar.gz'
        # Retrieving 'expat-2.5.0'
        # Verifying SHA512 checksum for 'expat-2.5.0.tar.xz'
        # Retrieving 'ncurses-6.4'
        # Verifying SHA512 checksum for 'ncurses-6.4.tar.gz'
        # Retrieving 'libiconv-1.16'
        # Verifying SHA512 checksum for 'libiconv-1.16.tar.gz'
        # Retrieving 'gettext-0.21'
        # Verifying SHA512 checksum for 'gettext-0.21.tar.xz'
        # Retrieving 'binutils-2.40'
        # Verifying SHA512 checksum for 'binutils-2.40.tar.xz'
        # Retrieving 'gcc-13.2.0'
        # Verifying SHA512 checksum for 'gcc-13.2.0.tar.xz'
        # Retrieving 'glibc-2.38'
        # OpenSSL: error:0A000126:SSL routines::unexpected eof while reading
        # Verifying SHA512 checksum for 'glibc-2.38.tar.xz'
        # Retrieving 'gdb-13.2'
        # Verifying SHA512 checksum for 'gdb-13.2.tar.xz'
        # =============================================
        # Second: Installing ncurses for build
        # =============================================
        # =============================================
        # Third: Installing zlib/zstd/gmp/mpc for host
        # more: expat ncurses libiconv gettext
        # =============================================
        # =============================================
        # Forth: Installing binutils/libc_headers for build
        # =============================================
        # =============================================
        # Fifth: Installing kernel headers/core C gcc compiler
        # =============================================


    )
}





entry="$1"
shift
"$entry" "$@"
