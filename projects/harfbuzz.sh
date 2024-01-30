version="8.3.0"

prepare() {
    fetch-archive \
        "https://github.com/harfbuzz/harfbuzz/releases/download/${version}/harfbuzz-${version}.tar.xz" \
        "109501eaeb8bde3eadb25fab4164e993fbace29c3d775bcaa1c1e58e2f15f847"
}

meson-project "harfbuzz-${version}"

meson_args+=(
    -Dbenchmark=disabled
    -Ddocs=disabled
    -Dicu=disabled
    -Dintrospection=disabled
    -Dtests=disabled
    -Dutilities=disabled
)
