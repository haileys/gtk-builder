cmake_source_dir=""
declare -a cmake_args

cmake-project() {
    local source_dir="$1"

    # cd and pwd to get absolute path to cmake source dir
    # the $(...) is a subshell so this will not have global effect
    cmake_source_dir="$(cd "$project_dir" && cd "$source_dir" && pwd)"

    configure() {
        cd build

        cmake \
            -DCMAKE_INSTALL_PREFIX="$PREFIX" \
            "${cmake_args[@]}" \
            "$cmake_source_dir"
    }

    build() {
        make -C build -j "$(nproc)"
    }

    install() {
        make -C build install
    }
}
