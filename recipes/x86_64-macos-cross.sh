recipe-init() {
    # some basic cross env checks
    [ -n "${MACOS_KITS:-}" ] || die "MACOS_KITS not set, cannot proceed with cross build"
    [ -n "${MACOS_SDK:-}" ] || die "MACOS_SDK not set, cannot proceed with cross build"
    [ -d "$MACOS_KITS/osxcross/bin" ] || die "$MACOS_KITS/osxcross/bin not a directory, cannot proceed with cross build"
    [ -e "$MACOS_SDK/usr/lib/libSystem.tbd" ] || die "MACOS_SDK does not appear to be a valid SDK sysroot"

    # activate the cross toolchain
    export PATH="$MACOS_KITS/osxcross/bin:$PATH"
    export OSXCROSS_PKG_CONFIG_USE_NATIVE_VARIABLES=1
    local target=x86_64-apple-darwin23
    export RUST_TARGET=x86_64-apple-darwin
    export CARGO_TARGET_X86_64_APPLE_DARWIN_LINKER="$target-clang"

    declare -g -a autotools_args cmake_args meson_args

    # autotools config
    autotools_args+=(
        --enable-shared
        --disable-static
        "--host=$target"
        "--target=$target"
        CC="$target-clang"
        CXX="$target-clang++"
        LD="$target-ld"
    )

    # meson config
    local meson_cross_file="$BUILD_DIR/meson-cross.txt"
    generate-meson-cross-file "$target" "$meson_cross_file"
    meson_args+=(
        --cross-file "$meson_cross_file"
        -Ddefault_library=shared
    )

    # cmake config
    local cmake_toolchain_cfg="$BUILD_DIR/cmake-toolchain.txt"
    generate-cmake-cross-toolchain "$target" "$cmake_toolchain_cfg"
    cmake_args+=(
        "-DCMAKE_TOOLCHAIN_FILE=$cmake_toolchain_cfg"
        -DBUILD_SHARED_LIBS=ON
    )

    # generate pc files for libraries that ship with macos so that downstream
    # packages can find them
    generate-zlib-pkgconfig
    generate-curl-pkgconfig
}

recipe-configure#libpng() {
    cmake_args+=(
        -DPNG_SHARED=ON
        -DPNG_STATIC=OFF
    )
}

recipe-configure#libjpeg-turbo() {
    cmake_args+=(
        -DENABLE_SHARED=TRUE
        -DENABLE_STATIC=FALSE
    )
}

recipe-post-install#glib() {
    # fix absolute import path
    x86_64-apple-darwin23-install_name_tool -change \
        "$PREFIX/lib/libffi.8.dylib" \
        "@rpath/libffi.8.dylib" \
        "$PREFIX/lib/libgobject-2.0.0.dylib"
}

recipe-post-install#librsvg() {
    local gdk_pixbuf_lib="lib/gdk-pixbuf-2.0/2.10.0"
    local pixbufloader_svg="$gdk_pixbuf_lib/loaders/libpixbufloader-svg.so"

    # fix import path for librsvg's pixbuf loader
    x86_64-apple-darwin23-install_name_tool -change \
        "$PREFIX/lib/librsvg-2.2.dylib" \
        "@rpath/librsvg-2.2.dylib" \
        "$PREFIX/$pixbufloader_svg"

    # generate loaders.cache entry for rsvg loader
    cat >> "$PREFIX/$gdk_pixbuf_lib/loaders.cache" <<END
"$pixbufloader_svg"
"svg" 6 "gdk-pixbuf" "Scalable Vector Graphics" "LGPL"
"image/svg+xml" "image/svg" "image/svg-xml" "image/vnd.adobe.svg+xml" "text/xml-svg" "image/svg+xml-compressed" ""
"svg" "svgz" "svg.gz" ""
" <svg" "*    " 100
" <!DOCTYPE svg" "*             " 100
END
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
    build-project libadwaita
}

generate-cmake-cross-toolchain() {
    local target="$1"
    local file="$2"
    local sysroot="$MACOS_SDK"

    cat > "$file" <<END
set(CMAKE_SYSTEM_NAME Darwin)
set(CMAKE_SYSTEM_PROCESSOR x86_64)

set(CMAKE_SYSROOT "$sysroot")
set(CMAKE_C_COMPILER "$target-clang")
set(CMAKE_CXX_COMPILER "$target-clang++")
set(CMAKE_LINKER "$target-ld")
set(CMAKE_AR "$target-ar")
set(CMAKE_NM "$target-nm")
set(CMAKE_RANLIB "$target-ranlib")
set(CMAKE_STRIP "$target-strip")

set(CMAKE_FIND_ROOT_PATH
    "$TARGET_DIR"
    "$sysroot")

set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
END
}

generate-meson-cross-file() {
    local target="$1"
    local file="$2"
    local sysroot="$MACOS_SDK"

    cat > "$file" <<END
[binaries]
c = '$target-clang'
objc = '$target-clang'
cpp = '$target-clang++'
ar = '$target-ar'
strip = '$target-strip'
ranlib = '$target-ranlib'
pkg-config = 'pkg-config'

gdbus-codegen = '$(find-host-program gdbus-codegen)'
glib-compile-resources = '$(find-host-program glib-compile-resources)'
glib-compile-schemas = '$(find-host-program glib-compile-schemas)'
glib-genmarshal = '$(find-host-program glib-genmarshal)'
glib-mkenums = '$(find-host-program glib-mkenums)'

[host_machine]
system = 'darwin'
cpu_family = 'x86_64'
cpu = 'x86_64'
endian = 'little'
END
}

# we need certain programs from the host OS when cross compiling
find-host-program() {
    local cmd="$1"
    local path
    command -v "$cmd" || die "command $cmd not found on host"
}

generate-system-pkgconfig() {
    local name="$1"
    local version="$2"
    local libs="$3"

    local pkgconfig_dir="$TARGET_DIR/lib/pkgconfig"
    mkdir -p "$pkgconfig_dir"

    cat > "$pkgconfig_dir/$name.pc" <<END
prefix=$MACOS_SDK
exec_prefix=\${prefix}
libdir=\${exec_prefix}/lib
sharedlibdir=\${libdir}
includedir=\${prefix}/include

Name: $name
Description: system $name
Version: $version

Requires:
Libs: $libs
END
}

generate-zlib-pkgconfig() {
    generate-system-pkgconfig zlib "1.2.12" "-lz"
}

generate-curl-pkgconfig() {
    generate-system-pkgconfig libcurl "8.4.0" "-lcurl"
}
