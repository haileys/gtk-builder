activate-brew-pkg() {
    local pkg="$1"
    local prefix
    prefix="$(brew --prefix "$pkg")"
    export PATH="$prefix/bin:$PATH"
}

recipe-init() {
    export CC=clang
    export CXX=clang++
    export LD=clang

    export DYLD_LIBRARY_PATH="$TARGET_DIR/lib"
    export CFLAGS="-Wl,rpath,$TARGET_DIR/lib/ ${CFLAGS:-}"

    # we might be running without much linked by homebrew into /usr/local,
    # so put things we need in the path directly
    activate-brew-pkg coreutils
    activate-brew-pkg cmake
    activate-brew-pkg ninja
    # we don't activate meson this way bc it doesn't seem to work.
    # brew link it

    declare -g -a autotools_args cmake_args

    autotools_args+=(
        --enable-shared
        --disable-static
    )

    meson_args+=(
        -Ddefault_library=shared
    )

    cmake_args+=(
        -DBUILD_SHARED_LIBS=ON
        -DBUILD_STATIC_LIBS=OFF

        # wish we could set this on a project-specific basis
        -DPNG_SHARED=ON
        -DPNG_STATIC=OFF

        # for libjpeg-turbo
        -DENABLE_SHARED=TRUE
        -DENABLE_STATIC=FALSE
    )
}

recipe-default-build() {
    build-project pcre2
    build-project libffi
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
    # build-project fontconfig
    build-project pixman
    build-project cairo
    build-project fribidi
    build-project pango
    build-project graphene
    build-project libepoxy
}
