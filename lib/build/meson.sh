declare -g meson_source_dir
declare -g -a meson_args

meson-project() {
    meson_source_dir="$1"

    configure() { meson::configure; }
    build() { meson::build; }
    install() { meson::install; }
}

meson::configure() {
    cd "$meson_source_dir"

    meson setup \
        --reconfigure \
        --prefix="$PREFIX" \
        "${meson_args[@]}" \
        "$project_dir/build"
}

meson::build() {
    meson compile -C build
}

meson::install() {
    meson install -C build
}
