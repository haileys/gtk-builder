version="2.4"

# on macOS put gettext bins in PATH just for this one build.
# we never want to link to gettext
if command -v brew >/dev/null; then
    export PATH="$(brew --prefix gettext)/bin:$PATH"
fi

prepare() {
    fetch-archive \
        "https://gitlab.freedesktop.org/xdg/shared-mime-info/-/archive/${version}/shared-mime-info-${version}.tar.gz" \
        "531291d0387eb94e16e775d7e73788d06d2b2fdd8cd2ac6b6b15287593b6a2de"
}

meson-project "shared-mime-info-${version}"

meson_args+=(
    -Dbuild-tests=false
    -Dbuild-tools=false
    -Dbuild-translations=false
    -Dupdate-mimedb=false
)
