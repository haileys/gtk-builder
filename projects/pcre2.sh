version="10.42"

prepare() {
    fetch-archive \
        "https://github.com/PCRE2Project/pcre2/releases/download/pcre2-${version}/pcre2-${version}.tar.gz" \
        "c33b418e3b936ee3153de2c61cc638e7e4fe3156022a5c77d0711bcbb9d64f1f"
}

cmake-project "pcre2-${version}"

