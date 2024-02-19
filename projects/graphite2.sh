version="1.3.14"
depends=()

prepare() {
    fetch-archive \
        "https://github.com/silnrsi/graphite/releases/download/${version}/graphite2-${version}.tgz" \
        "f99d1c13aa5fa296898a181dff9b82fb25f6cc0933dbaa7a475d8109bd54209d"
}

cmake-project "graphite2-${version}"

cmake_args+=(
    -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON
)
