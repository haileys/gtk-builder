source lib/project/depends.sh

project::with-env() {
    local project="$1"
    [[ "${2:-}" == "--" ]] || die "internal usage error: project::with-env <project name> -- <command...>"
    shift 2

    # setup project env in subshell
    (
        # set vars
        local project_dir="$BUILD_DIR/$project"
        local submodules="$(pwd)/submodules"

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
