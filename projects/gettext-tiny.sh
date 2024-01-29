version="0.3.2"

prepare() {
    fetch-archive \
        "http://ftp.barfooze.de/pub/sabotage/tarballs/gettext-tiny-0.3.2.tar.xz" \
        "a9a72cfa21853f7d249592a3c6f6d36f5117028e24573d092f9184ab72bbe187"
}

configure() {
    # we can't build out of source tree, so copy source into build dir to
    # build there:
    cp -r gettext-tiny-0.3.2/* build/

    # we need to set our own CFLAGS, but the stock Makefile always overrides
    # CFLAGS with = assignment. change it to +=
    sed -ie 's/CFLAGS=/CFLAGS+=/' build/Makefile
}

build() {
    build-env-exec make -C build LIBINTL=MUSL -j "$(nproc)"
}

install() {
    build-env-exec make -C build LIBINTL=MUSL "DESTDIR=$PREFIX" prefix= install
}

build-env-exec() {
    if [ -n "$TARGET" ]; then
        export CROSS_COMPILE="${TARGET}-"
        export CC="${TARGET}-cc"
        export AR="${TARGET}-ar"
        export RANLIB="${TARGET}-ranlib"
    fi

    export CFLAGS="-static"
    export LDFLAGS="-static"

    "$@"
}
