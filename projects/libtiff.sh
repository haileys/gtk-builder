version="4.6.0"

prepare() {
    fetch-archive \
        "http://download.osgeo.org/libtiff/tiff-${version}.tar.gz" \
        "88b3979e6d5c7e32b50d7ec72fb15af724f6ab2cbf7e10880c360a77e4b5d99a"
}

cmake-project "tiff-${version}"

cmake_args+=(
    -Dlzma=False
    -Dzstd=False
    -Dwebp=False
    -Djbig=False
    -Dlibdeflate=False
)
