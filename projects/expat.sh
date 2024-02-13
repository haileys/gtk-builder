version="2.5.0"

prepare() {
    fetch-archive \
        "https://github.com/libexpat/libexpat/releases/download/R_2_5_0/expat-${version}.tar.xz" \
        "ef2420f0232c087801abf705e89ae65f6257df6b7931d37846a193ef2e8cdcbe"
}

cmake-project "expat-${version}"

cmake_args+=(
    -DEXPAT_BUILD_PKGCONFIG=ON
)
