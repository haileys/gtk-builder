export PATH="$TARGET_DIR/bin:$PATH"
export LIBRARY_PATH="$TARGET_DIR/lib"
export PKG_CONFIG_PATH="$TARGET_DIR/lib/pkgconfig:$TARGET_DIR/lib64/pkgconfig:$TARGET_DIR/share/pkgconfig"
export PREFIX="$TARGET_DIR"

export CFLAGS="-I$PREFIX/include ${CFLAGS:-}"
export CXXFLAGS="-I$PREFIX/include ${CXXFLAGS:-}"
