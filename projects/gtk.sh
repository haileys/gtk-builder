version="git submodule"

prepare() {
    # uses git submodule
    true
}

configure() {
    cd "$BUILDER_ROOT/submodules/gtk"

    meson setup \
        --reconfigure \
        --prefix="$PREFIX" \
        -Ddefault_library=static \
        -Dintrospection=disabled \
        -Dbuild-tests=false \
        -Dbuild-testsuite=false \
        -Dbuild-demos=true \
        -Dbuild-examples=true \
        -Dmedia-gstreamer=disabled \
        -Dx11-backend=false \
        "$project_dir/build"
}

build() {
    meson compile -C build
}

install() {
    meson install -C build
}
