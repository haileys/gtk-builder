recipe-init() {
    local target="x86_64-linux-musl"

    local sysroot
    # ask gcc for sysroot
    sysroot="$("${target}-gcc" -print-sysroot)"
    # normalise path
    sysroot="$(cd "$sysroot" && pwd)"

    local meson_cross_cfg="$BUILD_DIR/meson-cross-cfg.txt"
    meson_args+=(--cross-file "$meson_cross_cfg")

    local cmake_toolchain_cfg="$BUILD_DIR/cmake-toolchain.txt"
    cmake_args+=("-DCMAKE_TOOLCHAIN_FILE=$cmake_toolchain_cfg")

    cat > "$meson_cross_cfg" <<END
    [binaries]
    c = ['${target}-gcc', '-static']
    cpp = ['${target}-g++', '-static']
    ar = '${target}-ar'
    strip = '${target}-strip'
    pkg-config = 'pkg-config'

    [host_machine]
    system = 'linux'
    cpu_family = 'x86_64'
    cpu = 'x86_64'
    endian = 'little'
END

    cat > "$cmake_toolchain_cfg" <<END
set(CMAKE_SYSTEM_NAME Linux)
set(CMAKE_SYSTEM_PROCESSOR x86_64)

set(CMAKE_SYSROOT ${target})
set(CMAKE_C_COMPILER ${target}-gcc)
set(CMAKE_CXX_COMPILER ${target}-g++)

set(CMAKE_FIND_ROOT_PATH
    $TARGET_DIR
    $sysroot)

set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)
END
}
