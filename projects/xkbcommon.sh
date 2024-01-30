version="1.6.0"

prepare() {
    fetch-archive \
        "https://xkbcommon.org/download/libxkbcommon-${version}.tar.xz" \
        "0edc14eccdd391514458bc5f5a4b99863ed2d651e4dd761a90abf4f46ef99c2b"
}

meson-project "libxkbcommon-${version}"

meson_args+=(
    -Denable-wayland=true
    -Denable-x11=false
    -Denable-docs=false
)
