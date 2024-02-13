recipe-init() {
    export CC=clang
    export CXX=clang
    export LD=clang

    declare -g -a cmake_args

    cmake_args+=(
        -DBUILD_STATIC_LIBS=OFF
        -DBUILD_SHARED_LIBS=ON
    )
}
