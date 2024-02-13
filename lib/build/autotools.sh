declare -g -a autotools_args

autotools-project() {
    declare -g autotools_source_dir
    autotools_source_dir="$1"

    configure() {
        # cd and pwd to get absolute path to source dir
        # the $(...) is a subshell so this will not have global effect
        local source_dir="$(cd "$project_dir" && cd "$autotools_source_dir" && pwd)"

        cd build

        "$source_dir/configure" \
            --prefix="$PREFIX" \
            "${autotools_args[@]}"
    }

    build() {
        make -C build -j "$(nproc)"
    }

    install() {
        make -C build install
    }
}
