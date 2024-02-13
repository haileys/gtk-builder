version="2.15.0"

prepare() {
    fetch-archive \
        "https://www.freedesktop.org/software/fontconfig/release/fontconfig-${version}.tar.gz" \
        "3ba2dd92158718acec5caaf1a716043b5aa055c27b081d914af3ccb40dce8a55"
}

meson-project "fontconfig-2.15.0"

meson_args+=(
    -Dtests=disabled
)
