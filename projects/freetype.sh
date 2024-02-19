version=2.13.2
depends=(zlib libpng)

prepare() {
    fetch-archive \
        "https://gitlab.freedesktop.org/freetype/freetype/-/archive/VER-2-13-2/freetype-VER-2-13-2.tar.gz" \
        "427201f5d5151670d05c1f5b45bef5dda1f2e7dd971ef54f0feaaa7ffd2ab90c"
}

meson-project "freetype-VER-2-13-2"

meson_args+=(
    -Dbzip2=disabled
    -Dbrotli=disabled
)
