version="0.2.5"

prepare() {
    fetch-archive \
        "https://github.com/yaml/libyaml/releases/download/${version}/yaml-${version}.tar.gz" \
        "c642ae9b75fee120b2d96c712538bd2cf283228d2337df2cf2988e3c02678ef4"
}

autotools-project "yaml-${version}"
