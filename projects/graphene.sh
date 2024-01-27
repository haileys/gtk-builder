version="1.10.8"

prepare() {
    fetch-archive \
        "https://github.com/ebassi/graphene/archive/refs/tags/${version}.tar.gz" \
        "922dc109d2dc5dc56617a29bd716c79dd84db31721a8493a13a5f79109a4a4ed"
}

configure() {
    cd "graphene-${version}"
    meson setup \
        --reconfigure \
        --prefix="$PREFIX" \
        -Ddefault_library=static \
        -Dintrospection=disabled \
        ../build
}

build() {
    meson compile -C build
}

install() {
    meson install -C build
}
