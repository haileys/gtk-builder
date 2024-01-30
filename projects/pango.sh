version="1.51.0"

prepare() {
    fetch-archive \
        "https://download.gnome.org/sources/pango/$(major-minor)/pango-${version}.tar.xz" \
        "74efc109ae6f903bbe6af77eaa2ac6094b8ee245a2e23f132a7a8f0862d1a9f5"
}

meson-project "pango-${version}"

meson_args+=(
    -Dintrospection=disabled
    -Dlibthai=disabled
    -Dxft=disabled
)
