version=0.42.2

prepare() {
    fetch-archive \
        "http://cairographics.org/releases/pixman-${version}.tar.gz" \
        "ea1480efada2fd948bc75366f7c349e1c96d3297d09a3fe62626e38e234a625e"
}

meson-project "pixman-${version}"

meson_args+=(
    -Dtests=disabled
)

case "$(target-arch)" in
    x86)
        meson_args+=(
            -Dsse2=enabled
            -Dssse3=enabled
        )
        ;;
    x86_64)
        meson_args+=(
            -Dsse2=enabled
            -Dssse3=enabled
            -Dmmx=enabled
        )
        ;;
    *)
        warn "building pixman for unknown architecture, using default intrinsics: $(target-arch)"
        ;;
esac
