#!/usr/bin/env bash
# Invoke cargo through Incredibuild's ib_console when available so
# heavy compile commands (build, test, clippy, check, nextest run,
# publish dry-run) get distributed across the IB acceleration network.
#
# On runners that don't have ib_console (e.g. ubuntu-latest carve-outs
# for cross-compile / Docker-dependent jobs), this falls through to
# plain `cargo` so the same workflow step works on both runner types.
#
# Flags chosen per Incredibuild's recommended template for CI builds:
#   --standalone               run without joining a coordinator
#   --build-cache-local-shared use the runner-local shared cache
#   --debug=build_cache        emit cache hit/miss diagnostics into the log
#   --build-cache-force        force-fill the cache even on the first run
#   --build-cache-basedir=PWD  scope the cache key to the workspace root

set -euo pipefail

# Pin cargo's output directory to the workspace `./target/`. Without
# this, ib_console (or surrounding IB env) redirects cargo output to
# /ib-workspace/cache/cargo-target/ and then `actions/upload-artifact`
# steps that expect `./target/no-debug/uv` find nothing, breaking
# every downstream test-ecosystem / test-system / test-smoke job that
# downloads the linux-libc binary.
export CARGO_TARGET_DIR="${CARGO_TARGET_DIR:-$PWD/target}"

if [ -x /usr/bin/ib_console ]; then
    exec /usr/bin/ib_console \
        --standalone \
        --build-cache-local-shared \
        --debug=build_cache \
        --build-cache-force \
        --build-cache-basedir="$PWD" \
        cargo "$@"
else
    exec cargo "$@"
fi
