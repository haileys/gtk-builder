version="1.51.0"

prepare() {
    fetch-archive \
        "https://download.gnome.org/sources/pango/$(major-minor)/pango-${version}.tar.xz" \
        "74efc109ae6f903bbe6af77eaa2ac6094b8ee245a2e23f132a7a8f0862d1a9f5"
}

configure() {
    cd "pango-${version}"
    meson setup \
        --reconfigure \
        --prefix="$PREFIX" \
        -Ddefault_library=static \
        -Dintrospection=disabled \
        -Dlibthai=disabled \
        ../build
}

build() {
    meson compile -C build
}

install() {
    meson install -C build
}
