version=0.42.2

prepare() {
    fetch-archive \
        "http://cairographics.org/releases/pixman-${version}.tar.gz" \
        "ea1480efada2fd948bc75366f7c349e1c96d3297d09a3fe62626e38e234a625e"
}

configure() {
    cd "pixman-${version}"

    local mmx=disabled
    [[ "$(target-arch)" == "x86_64" ]] && mmx=enabled

    meson setup \
        --reconfigure \
        --prefix="$PREFIX" \
        -Ddefault_library=static \
        -Dsse2=enabled \
        -Dssse3=enabled \
        -Dmmx="$mmx" \
        -Dtests=disabled \
        ../build
}

build() {
    meson compile -C build
}

install() {
    meson install -C build
}
