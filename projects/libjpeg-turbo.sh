version="3.0.1"

prepare() {
    fetch-archive \
        "https://sourceforge.net/projects/libjpeg-turbo/files/${version}/libjpeg-turbo-${version}.tar.gz" \
        "22429507714ae147b3acacd299e82099fce5d9f456882fc28e252e4579ba2a75"
}

cmake-project "libjpeg-turbo-${version}"

