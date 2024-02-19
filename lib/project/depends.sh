project::direct-depends() {
    project::with-env "$1" -- project::-write-depends
    cat "$BUILD_DIR/$1/.depends"
}

project::depends() {
    declare -A project_visited
    project::-depends-rec "$1"
}

project::-depends-rec() {
    local project="$1"

    [ -z "${project_visited["$project"]:-}" ] || return 0
    project_visited["$project"]=1

    local depend
    project::direct-depends "$project" | while read depend; do
        project::-depends-rec "$depend"
        echo "$depend"
    done
}

project::-write-depends() {
    truncate -s0 "$project_dir/.depends"

    local depend
    for depend in "${depends[@]}"; do
        echo "$depend" >> "$project_dir/.depends"
    done
}
