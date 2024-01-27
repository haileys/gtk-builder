version="git-submodule"

prepare() {
    ## use git submodule of this repo instead:

    # fetch-http \
    #     "https://www.freedesktop.org/software/fontconfig/release/fontconfig-${version}.tar.gz" \
    #     "3ba2dd92158718acec5caaf1a716043b5aa055c27b081d914af3ccb40dce8a55"

    # tar xf "fontconfig-${version}.tar.gz"
    true
}

configure() {
    cd "$BUILDER_ROOT/submodules/fontconfig"

    meson setup \
        --reconfigure \
        --prefix="$PREFIX" \
        -Ddefault_library=static \
        -Dtests=disabled \
        "$project_dir/build"
}

build() {
    meson compile -C build
}

install() {
    meson install -C build
}
