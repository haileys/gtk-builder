meson_source_dir=""
declare -a meson_args

meson-project() {
    local source_dir="$1"

    meson_source_dir="$source_dir"

    configure() {
        cd "$meson_source_dir"

        meson-cross-definition-setup

        meson setup \
            --reconfigure \
            --prefix="$PREFIX" \
            -Ddefault_library=static \
            "${meson_args[@]}" \
            "$project_dir/build"
    }

    build() {
        meson compile -C build
    }

    install() {
        meson install -C build
    }
}

meson-cross-definition-setup() {
    case "${TARGET:-}" in
    "")
        ;;
    x86_64-linux-musl)
        cat > x86_64-linux-musl.txt <<END
[binaries]
c = '${TARGET}-gcc'
cpp = '${TARGET}-g++'
ar = '${TARGET}-ar'
strip = '${TARGET}-strip'

[host_machine]
system = 'linux'
cpu_family = 'x86_64'
cpu = 'x86_64'
endian = 'little'
END

        meson_args+=(--cross-file x86_64-linux-musl.txt)
        ;;
    *)
        die "unknown target in meson-cross-definition: $TARGET"
        ;;
    esac
}
