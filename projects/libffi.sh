version="3.4.4"

prepare() {
    fetch-archive \
        "https://github.com/libffi/libffi/releases/download/v${version}/libffi-${version}.tar.gz" \
        "d66c56ad259a82cf2a9dfc408b32bf5da52371500b84745f7fb8b645712df676"
}

configure() {
    declare -a configure_args

    if [ -n "$TARGET" ]; then
        configure_args+=("--host=$TARGET")
    fi

    cd build

    "../libffi-${version}/configure" \
        --prefix="$PREFIX" \
        --enable-static \
        --disable-shared \
        "${configure_args[@]}"
}

build() {
    make -C build -j "$(nproc)"
}

install() {
    make -C build install
}
