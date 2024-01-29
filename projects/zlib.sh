version="1.3"

prepare() {
    fetch-archive \
        "https://github.com/madler/zlib/releases/download/v${version}/zlib-${version}.tar.xz" \
        "8a9ba2898e1d0d774eca6ba5b4627a11e5588ba85c8851336eb38de4683050a7"
}

configure() {
    if [ -n "$TARGET" ]; then
        export CHOST="$TARGET"
    fi

    export CFLAGS+="-static"

    cd build

    "../zlib-${version}/configure" \
        --static \
        --prefix="$PREFIX"
}

build() {
    make -C build -j "$(nproc)"
}

install() {
    make -C build install
}
