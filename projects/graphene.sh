version="1.10.8"
depends=(glib)

prepare() {
    fetch-archive \
        "https://github.com/ebassi/graphene/archive/refs/tags/${version}.tar.gz" \
        "922dc109d2dc5dc56617a29bd716c79dd84db31721a8493a13a5f79109a4a4ed"
}

meson-project "graphene-${version}"

meson_args+=(
    -Dintrospection=disabled
)
