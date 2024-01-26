version="1.79.1"

fetch-http \
    "https://download.gnome.org/sources/gobject-introspection/1.79/gobject-introspection-${version}.tar.xz" \
    "f80ea33ee05ca48fb997952bb46131cfbdd3751f7f5da068888739cbeb2d5443"

tar -xJf "gobject-introspection-${version}.tar.xz"

cd "gobject-introspection-${version}"

log "Configuring gobject-introspection $version"
meson setup \
    --reconfigure \
    --prefix="$PREFIX" \
    -Ddefault_library=static \
    build

log "Building gobject-introspection $version"
meson compile -C build

log "Installing gobject-introspection $version"
meson install -C build
