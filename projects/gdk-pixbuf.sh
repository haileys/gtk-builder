version="2.42.10"

prepare() {
    fetch-archive \
        "https://download.gnome.org/sources/gdk-pixbuf/2.42/gdk-pixbuf-${version}.tar.xz" \
        "ee9b6c75d13ba096907a2e3c6b27b61bcd17f5c7ebeab5a5b439d2f2e39fe44b"

    cd "gdk-pixbuf-${version}"
    patch -p1 < "$BUILDER_ROOT/patches/gdk-pixbuf/0001-dep-fix.patch"
}

configure() {
    cd "gdk-pixbuf-${version}"
    meson setup \
        --reconfigure \
        --prefix="$PREFIX" \
        -Dintrospection=disabled \
        -Ddefault_library=static \
        -Dman=false \
        -Dbuiltin_loaders=all \
        ../build
}

build() {
    meson compile -C build
}

install() {
    meson install -C build
}
