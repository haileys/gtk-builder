error::trap() {
    die "command failed: $BASH_COMMAND"
}

error::init() {
    trap error::trap ERR
}
