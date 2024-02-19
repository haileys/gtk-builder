source lib/project/depends.sh

project::with-env() {
    local project="$1"
    [[ "${2:-}" == "--" ]] || die "internal usage error: project::with-env <project name> -- <command...>"
    shift 2

    # setup project env in subshell
    (
        cd "$REPO_ROOT"

        # set vars
        local project_dir="$BUILD_DIR/$project"
        local submodules="$REPO_ROOT/submodules"

        declare -a depends

        # ensure project dir exists
        mkdir -p "$project_dir"

        # source project env
        source lib/build/init.sh
        source "projects/${project}.sh"

        # cd into project dir
        cd "$project_dir"
        mkdir -p build

        # run command in project env
        "$@"
    )
}

project::lock-build() {
    local lockfile="$BUILD_DIR/$project/.lock"

    (
        flock -xn "$fd" || die "cannot lock $lockfile"
        "$@"
    ) {fd}<>"$lockfile"
}

project::wait-depends() {
    for depend in $(project::depends "$project"); do
        [[ "$depend" == "$project" ]] && continue
        project::wait-for "$depend"
    done
}

project::wait-for() {
    local depend="$1"
    local lockfile="$BUILD_DIR/$depend/.lock"

    ( flock -s "$fd" ) {fd}<>"$lockfile"
}
