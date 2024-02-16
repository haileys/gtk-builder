recipe-init() {
    # some basic cross env checks
    [ -n "${MACOS_KITS:-}" ] || die "MACOS_KITS not set, cannot proceed with cross build"
    [ -n "${MACOS_SDK:-}" ] || die "MACOS_SDK not set, cannot proceed with cross build"
    [ -d "$MACOS_KITS/osxcross/bin" ] || die "$MACOS_KITS/osxcross/bin not a directory, cannot proceed with cross build"
    [ -e "$MACOS_SDK/usr/lib/libSystem.tbd" ] || die "MACOS_SDK does not appear to be a valid SDK sysroot"

    # activate the cross toolchain
    export PATH="$MACOS_KITS/osxcross/bin:$PATH"

    export CC=o64-clang
    export CXX=o64-clang++
    export LD=o64-clang

    declare -g -a autotools_args cmake_args meson_args

    # autotools config
    autotools_args+=(
        --enable-shared
        --disable-static
    )

    # meson config
    meson_args+=(
        -Ddefault_library=shared
        --libdir="$TARGET_DIR/lib"
    )

    # cmake config
    local cmake_toolchain_cfg="$BUILD_DIR/cmake-toolchain.txt"
    generate-cmake-cross-toolchain "$cmake_toolchain_cfg"

    cmake_args+=(
        "-DCMAKE_TOOLCHAIN_FILE=$cmake_toolchain_cfg"
        -DBUILD_SHARED_LIBS=ON

        "-DCMAKE_INSTALL_RPATH=@executable_path/../lib/"

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
    build-project pixman
    build-project cairo
    build-project fribidi
    build-project pango
    build-project graphene
    build-project libepoxy
    build-project gtk
    build-project librsvg
}

generate-cmake-cross-toolchain() {
    local file="$1"
    local sysroot="$MACOS_SDK"

    cat > "$file" <<END
set(CMAKE_SYSTEM_NAME Darwin)
set(CMAKE_SYSTEM_PROCESSOR x86_64)

set(CMAKE_SYSROOT "$sysroot")
set(CMAKE_C_COMPILER o64-clang)
set(CMAKE_CXX_COMPILER o64-clang++)
set(CMAKE_LINKER x86_64-apple-darwin23-ld)
set(CMAKE_AR x86_64-apple-darwin23-ar)
set(CMAKE_NM x86_64-apple-darwin23-nm)
set(CMAKE_RANLIB x86_64-apple-darwin23-ranlib)
set(CMAKE_STRIP x86_64-apple-darwin23-strip)

set(CMAKE_FIND_ROOT_PATH
    "$TARGET_DIR"
    "$sysroot")

set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
END
}
