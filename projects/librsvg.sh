version="2.57.91"

prepare() {
    fetch-archive \
        "https://download.gnome.org/sources/librsvg/$(major-minor)/librsvg-${version}.tar.xz" \
        "e0f9346258ba1c1299aee8abd7b0218ab2ef45fa83bb078a636c1ebb2ecdb6b2"
}

autotools-project "librsvg-${version}"
