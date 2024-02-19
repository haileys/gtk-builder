declare -gA project_visited

project::direct-depends() {
    project::with-env "$1" -- project::-write-depends
    cat "$BUILD_DIR/$1/.depends"
}

project::depends() {
    # reset project_visited
    project_visited=()

    local project
    for project in "$@"; do
        project::-depends-rec "$project"
    done
}

project::-depends-rec() {
    local project="$1"

    [ -z "${project_visited["$project"]:-}" ] || return 0
    project_visited["$project"]=1

    local depend
    for depend in $(project::direct-depends "$project"); do
        project::-depends-rec "$depend"
    done

    echo "$project"
}

project::-write-depends() {
    truncate -s0 "$project_dir/.depends"

    local depend
    for depend in "${depends[@]}"; do
        echo "$depend" >> "$project_dir/.depends"
    done
}
