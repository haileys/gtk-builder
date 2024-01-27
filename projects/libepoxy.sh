version="1.5.10"

prepare() {
    fetch-archive \
        "https://github.com/anholt/libepoxy/archive/refs/tags/${version}.tar.gz" \
        "a7ced37f4102b745ac86d6a70a9da399cc139ff168ba6b8002b4d8d43c900c15"
}

configure() {
    cd "libepoxy-${version}"
    meson setup \
        --reconfigure \
        --prefix="$PREFIX" \
        -Ddefault_library=static \
        -Dx11=false \
        -Dglx=no \
        -Degl=yes \
        -Dtests=false \
        -Ddocs=false \
        ../build
}

build() {
    meson compile -C build
}

install() {
    meson install -C build
}
