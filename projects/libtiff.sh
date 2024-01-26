version="4.6.0"

prepare() {
    fetch-http \
        "http://download.osgeo.org/libtiff/tiff-${version}.tar.gz" \
        "88b3979e6d5c7e32b50d7ec72fb15af724f6ab2cbf7e10880c360a77e4b5d99a"

    tar xf "tiff-${version}.tar.gz"

    cd "tiff-${version}"
}

configure() {
    cd build
    cmake \
        -DCMAKE_INSTALL_PREFIX="$PREFIX" \
        -DBUILD_SHARED_LIBS=OFF \
        -Dlzma=False \
        -Dzstd=False \
        -Dwebp=False \
        -Djbig=False \
        -Dlibdeflate=False \
        "../tiff-${version}"
}

build() {
    make -C build -j "$(nproc)"
}

install() {
    make -C build install
}
