version=0.42.2

prepare() {
    fetch-archive \
        "http://cairographics.org/releases/pixman-${version}.tar.gz" \
        "ea1480efada2fd948bc75366f7c349e1c96d3297d09a3fe62626e38e234a625e"
}

meson-project "pixman-${version}"

meson_args+=(
    -Ddefault_library=static
    -Dsse2=enabled
    -Dssse3=enabled
    -Dtests=disabled
)

if [[ "$(target-arch)" == "x86_64" ]]; then
    meson_args+=(-Dmmx=enabled)
fi
