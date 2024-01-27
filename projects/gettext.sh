version="0.22.4"

prepare() {
    fetch-archive \
        "https://ftp.gnu.org/pub/gnu/gettext/gettext-${version}.tar.gz" \
        "c1e0bb2a4427a9024390c662cd532d664c4b36b8ff444ed5e54b115fdb7a1aea"
}

configure() {
    cd build
    "../gettext-${version}/configure" \
        --prefix="$PREFIX" \
        --enable-static \
        --disable-shared \
        --disable-libasprintf \
        --disable-java \
        --disable-csharp
}

build() {
    make -C build -j "$(nproc)"
}

install() {
    make -C build install
}
