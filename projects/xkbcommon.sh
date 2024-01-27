version="1.6.0"

prepare() {
    fetch-archive \
        "https://xkbcommon.org/download/libxkbcommon-${version}.tar.xz" \
        "0edc14eccdd391514458bc5f5a4b99863ed2d651e4dd761a90abf4f46ef99c2b"
}

configure() {
    cd "libxkbcommon-${version}"
    meson setup \
        --reconfigure \
        --prefix="$PREFIX" \
        -Ddefault_library=static \
        -Denable-wayland=false \
        -Denable-x11=false \
        -Denable-docs=false \
        ../build
}

build() {
    meson compile -C build
}

install() {
    meson install -C build
}
