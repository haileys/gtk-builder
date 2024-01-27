PROJECT_DIR="$(pwd)"

fetch-http() {
    local url="$1"
    local sha256="$2"
    local filename="${url##*/}"
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

    curl -Lo "$cache_path+" "$url"
    mv "$cache_path+" "$cache_path"
    cp "$cache_path" "$filename"
}

fetch-archive() {
    local url="$1"
    local sha256="$2"
    local filename="${url##*/}"

    fetch-http "$url" "$sha256"
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

export PATH="$TARGET_DIR/bin:$PATH"
export LIBRARY_PATH="$TARGET_DIR/lib"
export PKG_CONFIG_PATH="$TARGET_DIR/lib/pkgconfig:$TARGET_DIR/lib64/pkgconfig:$TARGET_DIR/share/pkgconfig"
export PREFIX="$TARGET_DIR"
