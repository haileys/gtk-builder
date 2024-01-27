version="git submodule"

prepare() {
    # uses git submodule
    true

    # needs certain python dependencies
    poetry install --no-root
}

configure() {
    cd "$BUILDER_ROOT/submodules/gtk"

    poetry run meson setup \
        --reconfigure \
        --prefix="$PREFIX" \
        -Ddefault_library=static \
        -Dintrospection=disabled \
        -Dbuild-tests=false \
        -Dbuild-testsuite=false \
        -Dbuild-demos=false \
        -Dbuild-examples=false \
        -Dmedia-gstreamer=disabled \
        -Dx11-backend=false \
        "$project_dir/build"
}

build() {
    poetry run meson compile -C build
}

install() {
    meson install -C build
}
