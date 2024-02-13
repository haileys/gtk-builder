version="3.4.4"

prepare() {
    fetch-archive \
        "https://github.com/libffi/libffi/releases/download/v${version}/libffi-${version}.tar.gz" \
        "d66c56ad259a82cf2a9dfc408b32bf5da52371500b84745f7fb8b645712df676"
}

autotools-project "libffi-${version}"
