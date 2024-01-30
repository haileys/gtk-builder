[ -n "$GLIB_INTROSPECTION" ] || die "do not invoke glib-common.sh directly"

version="git submodule"

prepare() {
    # fetch-archive \
    #     "https://download.gnome.org/sources/glib/2.79/glib-${version}.tar.xz" \
    #     "b3764dd6e29b664085921dd4dd6ba2430fc19760ab6857ecfa3ebd4e8c1d114c"

    true
}

meson-project "$submodules/glib"

meson_args+=(
    -Dintrospection="$GLIB_INTROSPECTION"
    -Dtests=false
)
