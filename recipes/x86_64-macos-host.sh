activate-brew-pkg() {
    local pkg="$1"
    local prefix
    prefix="$(brew --prefix "$pkg")"
    export PATH="$prefix/bin:$PATH"
}

recipe-init() {
    export CC=clang
    export CXX=clang
    export LD=clang

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

    cmake_args+=(
        -DBUILD_SHARED_LIBS=ON
        -DBUILD_STATIC_LIBS=OFF
    )
}

recipe-default-build() {
    build-project pcre2
    build-project libffi
    build-project glib
}
