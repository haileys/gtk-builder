version="2.79.1"
depends=(libffi pcre2)

prepare() {
    fetch-archive \
        "https://download.gnome.org/sources/glib/$(major-minor)/glib-${version}.tar.xz" \
        "b3764dd6e29b664085921dd4dd6ba2430fc19760ab6857ecfa3ebd4e8c1d114c"
}

meson-project "glib-${version}"

meson_args+=(
    -Dintrospection=disabled
    -Dtests=false
)
