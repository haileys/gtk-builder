version="2.4"

prepare() {
    fetch-archive \
        "https://gitlab.freedesktop.org/xdg/shared-mime-info/-/archive/${version}/shared-mime-info-${version}.tar.gz" \
        "531291d0387eb94e16e775d7e73788d06d2b2fdd8cd2ac6b6b15287593b6a2de"
}

meson-project "shared-mime-info-${version}"

meson_args+=(
    -Dbuild-translations=false
    -Dbuild-tests=false
    -Dupdate-mimedb=false
)
