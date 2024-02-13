recipe-init() {
    declare -g -a autotools_args cmake_args

    autotools_args+=(
        --enable-static
        --disable-shared
    )

    cmake_args+=(
        -DBUILD_STATIC_LIBS=ON
        -DBUILD_SHARED_LIBS=OFF
    )
}
