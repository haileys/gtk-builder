version="4.13.7"
depends=(glib pango harfbuzz cairo fribidi gdk-pixbuf libepoxy graphene libpng libtiff libjpeg-turbo)

prepare() {
    fetch-archive \
        "https://download.gnome.org/sources/gtk/$(major-minor)/gtk-${version}.tar.xz" \
        "cbcbdcc71ef25136169f0697e616bc29a9d246541f13cac19f5c9c0df369bf41"
}

meson-project "gtk-${version}"

meson_args+=(
    -Dintrospection=disabled
    -Dbuild-tests=false
    -Dbuild-testsuite=false
    -Dbuild-demos=true
    -Dbuild-examples=true
    -Dmedia-gstreamer=disabled
    -Dx11-backend=false
)
