# logging functions
USE_COLOR=
[ -t 1 ] && USE_COLOR=1
tput() {
    [ -n "$USE_COLOR" ] && command tput "$@"
}

# setup dirs
: "${CACHE_DIR="$(pwd)/.cache"}"
: "${BUILD_DIR:="$(pwd)/.build"}"
: "${TARGET_DIR:="$(pwd)/.target"}"

mkdir -p "$CACHE_DIR"

log() {
    local msg="$1"

    printf "%s+++ %s%s%s\n" \
        "$(tput setaf 4 bold)" \
        "$(tput sgr0)$(tput setaf 15)" \
        "$msg" \
        "$(tput sgr0)"
}

log-low() {
    local msg="$1"

    printf "%s+++ %s%s%s\n" \
        "$(tput setaf 4 bold)" \
        "$(tput sgr0)" \
        "$msg" \
        "$(tput sgr0)"
}

warn() {
    local msg="$1"

    printf "%s*** %s%s%s\n" \
        "$(tput setaf 3 bold)" \
        "$(tput sgr0)$(tput setaf 15)" \
        "$msg" \
        "$(tput sgr0)"
}

die() {
    local msg="$1"

    printf "%s!!! %s%s%s\n" \
        "$(tput setaf 1 bold)" \
        "$(tput sgr0)$(tput setaf 15)" \
        "$msg" \
        "$(tput sgr0)"

    exit 1
}
