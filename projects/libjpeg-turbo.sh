version="3.0.1"

prepare() {
    fetch-http \
        "https://sourceforge.net/projects/libjpeg-turbo/files/${version}/libjpeg-turbo-${version}.tar.gz" \
        "22429507714ae147b3acacd299e82099fce5d9f456882fc28e252e4579ba2a75"

    tar xf "libjpeg-turbo-${version}.tar.gz"
}

configure() {
    cd build

    cmake \
        -DCMAKE_INSTALL_PREFIX="$PREFIX" \
        -DENABLE_STATIC=TRUE \
        -DENABLE_SHARED=FALSE \
        "../libjpeg-turbo-${version}"
}

build() {
    make -C build -j "$(nproc)"
}

install() {
    make -C build install
}
