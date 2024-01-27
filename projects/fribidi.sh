version="1.0.13"

prepare() {
    fetch-archive \
        "https://github.com/fribidi/fribidi/releases/download/v${version}/fribidi-${version}.tar.xz" \
        "7fa16c80c81bd622f7b198d31356da139cc318a63fc7761217af4130903f54a2"
}

configure() {
    cd "fribidi-${version}"
    meson setup \
        --reconfigure \
        --prefix="$PREFIX" \
        -Ddefault_library=static \
        -Ddocs=false \
        ../build
}

build() {
    meson compile -C build
}

install() {
    meson install -C build
}
