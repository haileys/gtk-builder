recipe::init() {
    declare -g -a autotools_args cmake_args

    autotools_args+=(
        --enable-static
        --disable-shared
    )

    meson_args+=(
        -Ddefault_library=static
    )

    cmake_args+=(
        -DBUILD_STATIC_LIBS=ON
        -DBUILD_SHARED_LIBS=OFF

        # wish we could set this on a project-specific basis
        -DPNG_STATIC=ON
        -DPNG_SHARED=OFF

        # for libjpeg-turbo
        -DENABLE_STATIC=TRUE
        -DENABLE_SHARED=FALSE
    )
}

recipe::build-default() {
    build-project zlib
    build-project pcre2
    build-project libffi
    build-project util-linux
    build-project glib
    build-project libpng
    build-project libjpeg-turbo
    build-project libtiff
    build-project libxml2
    build-project shared-mime-info
    build-project gdk-pixbuf
    build-project freetype
    build-project expat
    build-project harfbuzz
    build-project graphite2
    build-project fontconfig
    build-project pixman
    build-project cairo
    build-project fribidi
    build-project pango
    build-project graphene
    build-project libepoxy
    build-project wayland
    build-project wayland-protocols
    build-project xkbcommon
    build-project gtk
}
