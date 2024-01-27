version="1.18.0"

prepare() {
    fetch-archive \
        "https://gitlab.freedesktop.org/cairo/cairo/-/archive/${version}/cairo-${version}.tar.gz" \
        "39a78afdc33a435c0f2ab53a5ec2a693c3c9b6d2ec9783ceecb2b94d54d942b0"
}

configure() {
    cd "cairo-${version}"

    meson setup \
        --reconfigure \
        --prefix="$PREFIX" \
        -Ddefault_library=static \
        -Dfreetype=enabled \
        ../build
}

build() {
    meson compile -C build
}

install() {
    meson install -C build
}
