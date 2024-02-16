export LIBRARY_PATH="$TARGET_DIR/lib"
export PKG_CONFIG_LIBDIR="$TARGET_DIR/lib/pkgconfig"
export PREFIX="$TARGET_DIR"

export CFLAGS="-I$PREFIX/include ${CFLAGS:-}"
export CXXFLAGS="-I$PREFIX/include ${CXXFLAGS:-}"
