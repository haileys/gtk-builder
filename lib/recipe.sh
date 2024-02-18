declare -g -a meson_args
declare -g -a cmake_args
declare -g -a autotools_args

load-recipe() {
    if [ -n "${RECIPE:-}" ]; then
        log "Loading recipe $RECIPE"
        source "recipes/$RECIPE.sh"
        recipe::init
    fi
}
