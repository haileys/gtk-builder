version="1.18.0"

prepare() {
    fetch-archive \
        "https://gitlab.freedesktop.org/cairo/cairo/-/archive/${version}/cairo-${version}.tar.gz" \
        "39a78afdc33a435c0f2ab53a5ec2a693c3c9b6d2ec9783ceecb2b94d54d942b0"
}

meson-project "cairo-${version}"

meson_args+=(
    -Dfreetype=enabled
    -Dlzo2=disabled
    -Dtests=disabled
    -Dxcb=disabled
    -Dxlib-xcb=disabled
    -Dxlib=disabled
)
