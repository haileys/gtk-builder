version="git submodule"
depends=(glib fribidi gtk pango graphene)

prepare() {
    # fetch-archive \
    #     "https://download.gnome.org/sources/libadwaita/$(major-minor)/libadwaita-${version}.tar.xz" \
    #     "ae9622222b0eb18e23675655ad2ba01741db4d8655a796f4cf077b093e2f5841"

    true
}

meson-project "$submodules/libadwaita"

meson_args+=(
    -Dexamples=false
    -Dtests=false
    -Dintrospection=disabled
)
