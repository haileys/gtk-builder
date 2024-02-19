# define appropriate tput wrapper for colours or not
if [ -t 1 ] && [ -z "${NO_COLOR:-}" ]; then
    tput() {
        command tput "$@"
    }
else
    tput() {
        true
    }
fi

# logging functions
log() {
    local msg="$1"

    task::status "$msg"

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

    task::error "$msg"

    printf "%s!!! %s%s%s\n" \
        "$(tput setaf 1 bold)" \
        "$(tput sgr0)$(tput setaf 15)" \
        "$msg" \
        "$(tput sgr0)"

    exit 1
}

find-host-program() {
    local cmd="$1"
    local path
    command -v "$cmd" || die "command $cmd not found on host"
}
