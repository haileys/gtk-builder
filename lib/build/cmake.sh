cmake_source_dir=""
declare -g -a cmake_args

cmake-project() {
    cmake_source_dir="$1"

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
