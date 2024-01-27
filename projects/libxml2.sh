version="2.12.3"

prepare() {
    fetch-archive \
        "https://download.gnome.org/sources/libxml2/$(major-minor)/libxml2-${version}.tar.xz" \
        "8c8f1092340a89ff32bc44ad5c9693aff9bc8a7a3e161bb239666e5d15ac9aaa"
}

configure() {
    cd build
    cmake \
        -DCMAKE_INSTALL_PREFIX="$PREFIX" \
        -DBUILD_STATIC_LIBS=ON \
        -DBUILD_SHARED_LIBS=OFF \
        -DLIBXML2_WITH_PYTHON=OFF \
        -DLIBXML2_WITH_LZMA=OFF \
        "../libxml2-${version}"
}

build() {
    make -C build -j "$(nproc)"
}

install() {
    make -C build install
}
