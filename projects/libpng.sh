version="1.6.41"
depends=(zlib)

prepare() {
    fetch-archive \
        "http://prdownloads.sourceforge.net/libpng/libpng-${version}.tar.xz" \
        "d6a49a7a4abca7e44f72542030e53319c081fea508daccf4ecc7c6d9958d190f"
}

cmake-project "libpng-${version}"
