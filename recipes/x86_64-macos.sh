recipe-init() {
    export CC=clang
    export CXX=clang
    export LD=clang

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
    build-project gettext-tiny
    build-project pcre2
    build-project libffi
    build-project glib
}
