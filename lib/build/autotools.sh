declare -g autotools_source_dir
declare -g -a autotools_args

autotools-project() {
    autotools_source_dir="$1"

    configure() { autotools::configure; }
    build() { autotools::build; }
    install() { autotools::install; }
}

autotools::configure() {
    # cd and pwd to get absolute path to source dir
    # the $(...) is a subshell so this will not have global effect
    local source_dir="$(cd "$project_dir" && cd "$autotools_source_dir" && pwd)"

    cd build

    "$source_dir/configure" \
        --prefix="$PREFIX" \
        "${autotools_args[@]}"
}

autotools::build() {
    make -C build -j "$(nproc)"
}

autotools::install() {
    make -C build install
}
