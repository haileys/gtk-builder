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

    echo "$sha256 $filename" | sha256sum --check --quiet
}

export PKG_CONFIG_PATH="$TARGET_DIR/lib/pkgconfig"
export PREFIX="$TARGET_DIR"
