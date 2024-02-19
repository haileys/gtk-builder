declare -g -a meson_args
declare -g -a cmake_args
declare -g -a autotools_args

load-recipe() {
    if [ -n "${RECIPE:-}" ]; then
        mkdir -p "$BUILD_DIR"

        log "Loading recipe $RECIPE"
        source "recipes/$RECIPE.sh"
        recipe::init
    fi
}
