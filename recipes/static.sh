recipe-init() {
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
