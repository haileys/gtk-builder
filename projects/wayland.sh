version="1.22.0"

prepare() {
    fetch-archive \
        "https://gitlab.freedesktop.org/wayland/wayland/-/releases/${version}/downloads/wayland-${version}.tar.xz" \
        "1540af1ea698a471c2d8e9d288332c7e0fd360c8f1d12936ebb7e7cbc2425842"
}

configure() {
    cd "wayland-${version}"
    meson setup \
        --reconfigure \
        --prefix="$PREFIX" \
        -Ddefault_library=static \
        -Dlibraries=true \
        -Dscanner=true \
        -Dtests=false \
        -Ddocumentation=false \
        -Ddtd_validation=false \
        ../build
}

build() {
    meson compile -C build
}

install() {
    meson install -C build
}
