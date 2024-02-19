declare -g tool_prefix
declare -g -a autotools_args cmake_args meson_args

recipe::init() {
    # some basic cross env checks
    [ -n "${MACOS_KITS:-}" ] || die "MACOS_KITS not set, cannot proceed with cross build"
    [ -n "${MACOS_SDK:-}" ] || die "MACOS_SDK not set, cannot proceed with cross build"
    [ -d "$MACOS_KITS/osxcross/bin" ] || die "$MACOS_KITS/osxcross/bin not a directory, cannot proceed with cross build"
    [ -e "$MACOS_SDK/usr/lib/libSystem.tbd" ] || die "MACOS_SDK does not appear to be a valid SDK sysroot"

    # check param vars
    [ -n "${RECIPE_ARCH:-}" ] || die "RECIPE_ARCH not set, cannot proceed with cross build"

    tool_prefix="${RECIPE_ARCH}-apple-darwin23-"

    # activate the cross toolchain
    export PATH="$MACOS_KITS/osxcross/bin:$PATH"
    export OSXCROSS_PKG_CONFIG_USE_NATIVE_VARIABLES=1

    # autotools config
    autotools_args+=(
        --enable-shared
        --disable-static
        "--host=${RECIPE_ARCH}-apple-darwin23"
        "--target=${RECIPE_ARCH}-apple-darwin23"
        CC="${tool_prefix}clang"
        CXX="${tool_prefix}clang++"
        LD="${tool_prefix}ld"
    )

    # meson config
    local meson_cross_file="$BUILD_DIR/meson-cross.txt"
    macos-cross::generate-meson-cross-file "$meson_cross_file"
    meson_args+=(
        --cross-file "$meson_cross_file"
        -Ddefault_library=shared
    )

    # cmake config
    local cmake_toolchain_cfg="$BUILD_DIR/cmake-toolchain.txt"
    macos-cross::generate-cmake-cross-toolchain "$cmake_toolchain_cfg"
    cmake_args+=(
        "-DCMAKE_TOOLCHAIN_FILE=$cmake_toolchain_cfg"
        -DBUILD_SHARED_LIBS=ON
    )

    # generate pc files for libraries that ship with macos so that downstream
    # packages can find them
    macos-cross::generate-zlib-pkgconfig
    macos-cross::generate-curl-pkgconfig
}

target-arch() {
    echo "$RECIPE_ARCH"
}

recipe::pre-configure#libpng() {
    cmake_args+=(
        -DPNG_SHARED=ON
        -DPNG_STATIC=OFF
    )
}

recipe::pre-configure#libjpeg-turbo() {
    cmake_args+=(
        -DENABLE_SHARED=TRUE
        -DENABLE_STATIC=FALSE
    )
}

recipe::post-install#glib() {
    # fix absolute import path
    "${tool_prefix}install_name_tool" -change \
        "$PREFIX/lib/libffi.8.dylib" \
        "@rpath/libffi.8.dylib" \
        "$PREFIX/lib/libgobject-2.0.0.dylib"
}

recipe::pre-configure#pixman() {
    # compiling with instrinsics spits out redonkulous errors for some reason
    meson_args+=(-Da64-neon=disabled)
}

recipe::pre-configure#librsvg() {
    export RUST_TARGET="${RECIPE_ARCH}-apple-darwin"

    case "$RECIPE_ARCH" in
    x86_64)
        export CARGO_TARGET_X86_64_APPLE_DARWIN_LINKER="${tool_prefix}clang"
        ;;
    aarch64)
        export CARGO_TARGET_AARCH64_APPLE_DARWIN_LINKER="${tool_prefix}clang"
        ;;
    esac
}

recipe::post-install#librsvg() {
    local gdk_pixbuf_lib="lib/gdk-pixbuf-2.0/2.10.0"
    local pixbufloader_svg="$gdk_pixbuf_lib/loaders/libpixbufloader-svg.so"

    # fix import path for librsvg's pixbuf loader
    "${tool_prefix}install_name_tool" -change \
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

# nerf zlib entirely, we use the system one
recipe::configure#zlib() { true; }
recipe::build#zlib() { true; }
recipe::install#zlib() { true; }

recipe::build-default() {
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

macos-cross::generate-cmake-cross-toolchain() {
    local file="$1"
    local sysroot="$MACOS_SDK"

    cat > "$file" <<END
set(CMAKE_SYSTEM_NAME Darwin)
set(CMAKE_SYSTEM_PROCESSOR ${RECIPE_ARCH})

set(CMAKE_SYSROOT "$sysroot")
set(CMAKE_C_COMPILER "${tool_prefix}clang")
set(CMAKE_CXX_COMPILER "${tool_prefix}clang++")
set(CMAKE_LINKER "${tool_prefix}ld")
set(CMAKE_AR "${tool_prefix}ar")
set(CMAKE_NM "${tool_prefix}nm")
set(CMAKE_RANLIB "${tool_prefix}ranlib")
set(CMAKE_STRIP "${tool_prefix}strip")

set(CMAKE_FIND_ROOT_PATH
    "$TARGET_DIR"
    "$sysroot")

set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
END
}

macos-cross::generate-meson-cross-file() {
    local file="$1"
    local sysroot="$MACOS_SDK"

    cat > "$file" <<END
[binaries]
c = '${tool_prefix}clang'
objc = '${tool_prefix}clang'
cpp = '${tool_prefix}clang++'
ar = '${tool_prefix}ar'
strip = '${tool_prefix}strip'
ranlib = '${tool_prefix}ranlib'
pkg-config = 'pkg-config'

gdbus-codegen = '$(find-host-program gdbus-codegen)'
glib-compile-resources = '$(find-host-program glib-compile-resources)'
glib-compile-schemas = '$(find-host-program glib-compile-schemas)'
glib-genmarshal = '$(find-host-program glib-genmarshal)'
glib-mkenums = '$(find-host-program glib-mkenums)'

[host_machine]
system = 'darwin'
cpu_family = '${RECIPE_ARCH}'
cpu = '${RECIPE_ARCH}'
endian = 'little'
END
}

macos-cross::generate-system-pkgconfig() {
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

macos-cross::generate-zlib-pkgconfig() {
    macos-cross::generate-system-pkgconfig zlib "1.2.12" "-lz"
}

macos-cross::generate-curl-pkgconfig() {
    macos-cross::generate-system-pkgconfig libcurl "8.4.0" "-lcurl"
}
