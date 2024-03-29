version="git submodule"

prepare() {
    # fetch-archive \
    #     "https://github.com/util-linux/util-linux/archive/refs/tags/v${version}.tar.gz" \
    #     "2434edd1cf2aaca2a2b76b5de5ce7c98b12f75af9f600800c0655af20be85956" \
    #     --filename "util-linux-${version}.tar.gz"

    true
}

meson-project "$submodules/util-linux"

meson_args+=(
    -Dbuild-chfn-chsh=disabled
    -Dbuild-cramfs=disabled
    -Dbuild-fsck=disabled
    -Dbuild-libblkid=enabled
    -Dbuild-libfdisk=disabled
    -Dbuild-libmount=enabled
    -Dbuild-libsmartcols=disabled
    -Dbuild-libuuid=disabled
    -Dbuild-login=disabled
    -Dbuild-more=disabled
    -Dbuild-pg=disabled
    -Dbuild-python=disabled
    -Dbuild-runuser=disabled
    -Dbuild-setterm=disabled
    -Dbuild-su=disabled
    -Dbuild-sulogin=disabled
    -Dbuild-ul=disabled
    -Dbuild-uuidd=disabled
    -Dncurses=disabled
    -Dncursesw=disabled
    -Dreadline=disabled
    -Dsystemd=disabled
    -Dtinfo=disabled
)
