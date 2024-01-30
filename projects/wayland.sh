version="1.22.0"

prepare() {
    fetch-archive \
        "https://gitlab.freedesktop.org/wayland/wayland/-/releases/${version}/downloads/wayland-${version}.tar.xz" \
        "1540af1ea698a471c2d8e9d288332c7e0fd360c8f1d12936ebb7e7cbc2425842"
}

meson-project "wayland-${version}"

meson_args+=(
    -Dlibraries=true
    -Dscanner=true
    -Dtests=false
    -Ddocumentation=false
    -Ddtd_validation=false
)
