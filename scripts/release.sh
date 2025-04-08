#!/usr/bin/env bash

# Build and upload mayastor extensions docker images to dockerhub repository.
# Use --dry-run to just see what would happen.
# The script assumes that a user is logged on to dockerhub for public images,
# or has insecure registry access setup for CI.

SOURCE_REL=$(dirname "$0")/../mayastor/dependencies/control-plane/utils/dependencies/scripts/release.sh

if [ ! -f "$SOURCE_REL" ] && [ -z "$CI" ]; then
  git submodule update --init --recursive
fi

IMAGES=""
BUILD_BINARIES="kubectl-openebs"
PROJECT="openebs"
. "$SOURCE_REL"

# Sadly helm ignore does not work on symlinks: https://github.com/helm/helm/issues/13284
# So we must cleanup to ensure the upgrade image is built correctly
CHART_DIR="$(dirname "$0")/../charts"
if [ -L "$CHART_DIR"/kubectl-openebs ]; then
  rm "$CHART_DIR"/kubectl-openebs
fi

common_run $@
