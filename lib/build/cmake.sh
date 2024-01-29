cmake_source_dir=""
declare -a cmake_args

cmake-project() {
    cmake_source_dir="$1"

    # are we cross-compiling? set appropriate cmake args
    if [ -n "${TARGET:-}" ]; then
        local cross_sysroot
        # ask gcc for sysroot
        cross_sysroot="$("$TARGET-gcc" -print-sysroot)"
        # normalise path
        cross_sysroot="$(cd "$cross_sysroot" && pwd)"

        cmake_args+=(
            "-DCMAKE_C_COMPILER=$TARGET-gcc"
            "-DCMAKE_CXX_COMPILER=$TARGET-g++"
            "-DCMAKE_FIND_ROOT_PATH=$PREFIX;$cross_sysroot"
            "-DCMAKE_FIND_ROOT_PATH_MODE_LIBRARY=ONLY"
            "-DCMAKE_FIND_ROOT_PATH_MODE_INCLUDE=ONLY"
        )
    fi

    configure() {
        # cd and pwd to get absolute path to cmake source dir
        # the $(...) is a subshell so this will not have global effect
        local source_dir="$(cd "$project_dir" && cd "$cmake_source_dir" && pwd)"

        cd build

        cmake \
            -DCMAKE_INSTALL_PREFIX="$PREFIX" \
            "${cmake_args[@]}" \
            "$source_dir"
    }

    build() {
        make -C build -j "$(nproc)"
    }

    install() {
        make -C build install
    }
}
