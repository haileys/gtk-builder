version="3.4.4"

prepare() {
    fetch-archive \
        "https://github.com/libffi/libffi/releases/download/v${version}/libffi-${version}.tar.gz" \
        "-"
}

configure() {
    cd build
    "../libffi-${version}/configure" \
        --prefix="$PREFIX" \
        --enable-static \
        --disable-shared
}

build() {
    make -C build -j "$(nproc)"
}

install() {
    make -C build install
}
