version="git submodule"

prepare() {
    # fetch-archive \
    #     "https://github.com/silnrsi/graphite/releases/download/${version}/graphite2-${version}.tgz" \
    #     "f99d1c13aa5fa296898a181dff9b82fb25f6cc0933dbaa7a475d8109bd54209d"

    true
}

cmake-project "$submodules/graphite2"

cmake_args+=(
    -DBUILD_SHARED_LIBS=OFF
    -DCMAKE_VERBOSE_MAKEFILE:BOOL=ON
)
