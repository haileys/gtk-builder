version="2.42.10"
depends=(glib shared-mime-info libpng libjpeg-turbo libtiff)

prepare() {
    fetch-archive \
        "https://download.gnome.org/sources/gdk-pixbuf/2.42/gdk-pixbuf-${version}.tar.xz" \
        "ee9b6c75d13ba096907a2e3c6b27b61bcd17f5c7ebeab5a5b439d2f2e39fe44b"
}

meson-project "gdk-pixbuf-${version}"

meson_args+=(
    -Dbuiltin_loaders=all
    -Ddocs=false
    -Dgtk_doc=false
    -Dintrospection=disabled
    -Dman=false
    -Dtests=false
    -Drelocatable=true
)
