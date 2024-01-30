version="git submodule"

prepare() {
    # uses git submodule
    true
}

meson-project "$submodules/gtk"

meson_args+=(
    -Dintrospection=disabled
    -Dbuild-tests=false
    -Dbuild-testsuite=false
    -Dbuild-demos=true
    -Dbuild-examples=true
    -Dmedia-gstreamer=disabled
    -Dx11-backend=false
)
