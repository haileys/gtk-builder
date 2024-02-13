recipe-init() {
    declare -g -a cmake_args

    cmake_args+=(
        -DBUILD_STATIC_LIBS=ON
        -DBUILD_SHARED_LIBS=OFF
    )
}
