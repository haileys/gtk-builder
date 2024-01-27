version="10.42"

prepare() {
    fetch-archive \
        "https://github.com/PCRE2Project/pcre2/releases/download/pcre2-${version}/pcre2-${version}.tar.gz" \
        "c33b418e3b936ee3153de2c61cc638e7e4fe3156022a5c77d0711bcbb9d64f1f"
}

configure() {
    cd build
    cmake \
        -DCMAKE_INSTALL_PREFIX="$PREFIX" \
        -DBUILD_STATIC_LIBS=ON \
        -DBUILD_SHARED_LIBS=OFF \
        "../pcre2-${version}"
}

build() {
    make -C build -j "$(nproc)"
}

install() {
    make -C build install
}
