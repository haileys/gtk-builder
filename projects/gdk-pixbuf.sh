version="git submodule"

prepare() {
    # fetch-archive \
    #     "https://download.gnome.org/sources/gdk-pixbuf/2.42/gdk-pixbuf-${version}.tar.xz" \
    #     "ee9b6c75d13ba096907a2e3c6b27b61bcd17f5c7ebeab5a5b439d2f2e39fe44b"

    true
}

configure() {
    cd "$BUILDER_ROOT/submodules/gdk-pixbuf"
    meson setup \
        --reconfigure \
        --prefix="$PREFIX" \
        -Dintrospection=disabled \
        -Ddefault_library=static \
        -Dman=false \
        -Dbuiltin_loaders=all \
        "$project_dir/build"
}

build() {
    meson compile -C build
}

install() {
    meson install -C build
}
