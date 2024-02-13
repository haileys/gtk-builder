meson_source_dir=""
declare -g -a meson_args

meson-project() {
    local source_dir="$1"

    meson_source_dir="$source_dir"

    meson-configure() {
        cd "$meson_source_dir"

        meson setup \
            --reconfigure \
            --prefix="$PREFIX" \
            "${meson_args[@]}" \
            "$project_dir/build"
    }

    meson-build() {
        meson compile -C build
    }

    meson-install() {
        meson install -C build
    }

    configure() { meson-configure; }
    build() { meson-build; }
    install() { meson-install; }
}
