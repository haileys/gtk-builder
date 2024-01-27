version="8.3.0"

prepare() {
    fetch-archive \
        "https://github.com/harfbuzz/harfbuzz/releases/download/${version}/harfbuzz-${version}.tar.xz" \
        "109501eaeb8bde3eadb25fab4164e993fbace29c3d775bcaa1c1e58e2f15f847"
}

configure() {
    cd "harfbuzz-${version}"
    meson setup \
        --reconfigure \
        --prefix="$PREFIX" \
        -Ddefault_library=static \
        -Dintrospection=disabled \
        -Dtests=disabled \
        -Dutilities=disabled \
        -Dbenchmark=disabled \
        -Ddocs=disabled \
        ../build
}

build() {
    meson compile -C build
}

install() {
    meson install -C build
}
