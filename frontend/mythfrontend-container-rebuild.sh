#!/bin/bash
set -e

CONTEXT_DIR=/var/home/bonnen/Src/mythtv-container/frontend
IMAGES_TO_KEEP=3
MYTHTV_VERSION=34
MYTHFRONTEND_TAG="mythfrontend:$MYTHTV_VERSION"
MYTHFRONTEND_FULL_VERSION="$MYTHFRONTEND_TAG-$(date +'%Y%m%d')"

# Rebuild the backend image
podman build --pull=newer --no-cache -f "$CONTEXT_DIR/mythfrontend.Containerfile" -t "$MYTHFRONTEND_FULL_VERSION" "$CONTEXT_DIR"
podman tag "$MYTHFRONTEND_FULL_VERSION" "$MYTHFRONTEND_TAG"

# Clean out old images
IMAGES_TO_REMOVE=($(podman image ls --sort created -f 'reference=mythfrontend' --format '{{.Repository}}:{{.Tag}}' |\
	| grep "mythfrontend:$MYTHTV_VERSION" | grep -Ev "^localhost/$MYTHFRONTEND_TAG\$" | grep -v 'keep' | tail -n +$IMAGES_TO_KEEP))

echo "${IMAGES_TO_REMOVE[@]}"

if [[ ${#IMAGES_TO_REMOVE[@]} -gt 0 ]]; then
	podman image rm "${IMAGES_TO_REMOVE[@]}"
fi

# Recreate the distrobox for mythfrontend
DBX_CONTAINER_ALWAYS_PULL=0 distrobox assemble create -R --file "$CONTEXT_DIR/mythfrontend.ini"
