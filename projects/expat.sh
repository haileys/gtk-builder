version="2.5.0"

prepare() {
    fetch-http \
        "https://github.com/libexpat/libexpat/releases/download/R_2_5_0/expat-${version}.tar.xz" \
        "ef2420f0232c087801abf705e89ae65f6257df6b7931d37846a193ef2e8cdcbe"

    tar xf "expat-${version}.tar.xz"
}

configure() {
    cd build
    cmake \
        -DCMAKE_INSTALL_PREFIX="$PREFIX" \
        -DBUILD_SHARED_LIBS=OFF \
        -DEXPAT_BUILD_PKGCONFIG=ON \
        "../expat-${version}"
}

build() {
    make -C build -j "$(nproc)"
}

install() {
    make -C build install
}
