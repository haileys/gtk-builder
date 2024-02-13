fetch-http() {
    local url="$1"
    local sha256="$2"
    local filename="$3"
    local cache_path="$CACHE_DIR/$filename"

    if [ -e "$cache_path" ]; then
        if check-sha256 "$cache_path" "$sha256"; then
            log-low "$filename: already downloaded"
            cp "$cache_path" "$filename"
            return
        else
            warn "$filename: mismatched checksum, redownloading"
        fi
    else
        log "downloading $url"
    fi

    # ensure cache dir exists
    mkdir -p "$CACHE_DIR"

    curl -Lo "$cache_path+" "$url"
    mv "$cache_path+" "$cache_path"
    cp "$cache_path" "$filename"
}

fetch-archive() {
    local url="$1"
    local sha256="$2"
    local filename="${url##*/}"

    shift
    shift

    while [ "$#" -gt 0 ]; do
        case "$1" in
        --filename)
            filename="$2"
            shift
            shift
            ;;
        *)
            die "unknown flag to fetch-archive: $1"
            ;;
        esac
    done

    fetch-http "$url" "$sha256" "$filename"
    tar -xf "$filename"
}

extract-tar() {
    local dir="$1"
    local filename="$2"

    [ -d "$dir" ] && log-low "$filename: already extracted" && return

    log "extracting $filename"
    tar -xf "$filename"
}

check-sha256() {
    local filename="$1"
    local sha256="$2"

    echo "$sha256  $filename" | sha256sum -c
}

target-arch() {
    # we don't support cross compiling for the moment, so target arch is host arch
    uname -m
}

version-component() {
    local version="$1"
    local component="$2"
    echo "$version" | cut -d. -f"$component"
}

major() {
    version-component "$version" 1
}

minor() {
    version-component "$version" 2
}

major-minor() {
    version-component "$version" 1-2
}

fix-rpath() {
    local exe="$1"
    install_name_tool -add_rpath @executable_path/../lib "$TARGET_DIR/bin/$exe"
}
