version="2.12.3"

prepare() {
    fetch-archive \
        "https://download.gnome.org/sources/libxml2/$(major-minor)/libxml2-${version}.tar.xz" \
        "8c8f1092340a89ff32bc44ad5c9693aff9bc8a7a3e161bb239666e5d15ac9aaa"
}

cmake-project "libxml2-${version}"

cmake_args+=(
    -DLIBXML2_WITH_PYTHON=OFF
    -DLIBXML2_WITH_LZMA=OFF
)

install() {
    cmake-install

    # fix-rpath xmllint
}
