version="git-submodule"

prepare() {
    ## use git submodule of this repo instead:

    # fetch-http \
    #     "https://www.freedesktop.org/software/fontconfig/release/fontconfig-${version}.tar.gz" \
    #     "3ba2dd92158718acec5caaf1a716043b5aa055c27b081d914af3ccb40dce8a55"

    # tar xf "fontconfig-${version}.tar.gz"
    true
}

meson-project "$submodules/fontconfig"

meson_args+=(
    -Dtests=disabled
)
