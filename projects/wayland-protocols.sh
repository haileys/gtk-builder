version="1.33"

prepare() {
    fetch-archive \
        "https://gitlab.freedesktop.org/wayland/wayland-protocols/-/releases/${version}/downloads/wayland-protocols-${version}.tar.xz" \
        "94f0c50b090d6e61a03f62048467b19abbe851be4e11ae7b36f65f8b98c3963a"
}

configure() {
    cd "wayland-protocols-${version}"
    meson setup \
        --reconfigure \
        --prefix="$PREFIX" \
        -Ddefault_library=static \
        -Dtests=false \
        ../build
}

build() {
    meson compile -C build
}

install() {
    meson install -C build
}
