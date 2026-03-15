container_runtime := env("CONTAINER_RUNTIME", `command -v docker >/dev/null 2>&1 && echo docker || echo podman`)
registry := "ghcr.io"
registry_path := "hal7e0"
myth_versions := "33 34 35"
images := "backend frontend"

[private]
default:
    @just --list

build-image $image $version $timestamp:
    #!/usr/bin/env bash
    set -euo pipefail

    TAG_FULL="$version-$timestamp"
    IMAGE_REF="{{ registry }}/{{ registry_path }}/myth$image:$TAG_FULL"

    BUILD_ARGS=(--build-arg "MYTHTV_VERSION=$version")

    if [[ "$version" == "33" ]]; then
        BUILD_ARGS+=(--build-arg "UBUNTU_VERSION=jammy")
    else
        BUILD_ARGS+=(--build-arg "UBUNTU_VERSION=noble")
    fi

    {{ container_runtime }} build "${BUILD_ARGS[@]}" -f "$image/Dockerfile" -t "$IMAGE_REF" "$image"
    {{ container_runtime }} tag "$IMAGE_REF" "{{ registry }}/myth$image:$version"

push-image $image $version $timestamp:
    #!/usr/bin/env bash
    set -euo pipefail

    if ! {{ container_runtime }} login --get-login "{{ registry }}"; then
        echo "$REGISTRY_PASSWORD" | {{ container_runtime }} login "{{ registry }}" -u "$REGISTRY_USERNAME" --password-stdin
    fi

    IMAGE_REPO="{{ registry }}/{{ registry_path }}/myth$image"
    {{ container_runtime }} push "${IMAGE_REPO}:${version}-${timestamp}"
    {{ container_runtime }} push "${IMAGE_REPO}:${version}"

rebuild-image $image $version $timestamp:
    #!/usr/bin/env bash

    image_needs_updates() {
        image="$1"
        version="$2"
        IMAGE_REF="{{ registry }}/{{ registry_path }}/myth$image:$version"

        echo "Pulling latest {{ image }} image for '$IMAGE_REF'..."
        {{ container_runtime }} pull "$IMAGE_REF"

        echo "Checking image for outdated packages..."
        APT_STATUS="$({{ container_runtime }} run -itu root --rm --entrypoint /usr/bin/apt "$IMAGE_REF" update | tail -n 1)"

        if [[ "$APT_STATUS" == All* ]]; then
            echo "Image '$IMAGE_REF' up to date."
            return 1
        else
            PKGS_NEEDING_UPDATE="$(printf '%s' "$APT_STATUS" | awk '{print $1}')"
            echo "Image '$IMAGE_REF' needs $PKGS_NEEDING_UPDATE updates."
            return 0
        fi
    }

    if image_needs_updates "$image" "$version"; then
        just build-image "$image" "$version" "$timestamp"
        just push-image "$image" "$version" "$timestamp"
    fi

rebuild-all:
    #!/usr/bin/env bash
    set -euo pipefail

    VERSIONS=({{ myth_versions }})
    TIMESTAMP="$(date +%Y%m%d)"

    for VERSION in "${VERSIONS[@]}"; do
        IMAGES=({{ images }})
        if [[ $VERSION -lt 35 ]]; then
            IMAGES+=(web)
        fi

        for IMAGE in "${IMAGES[@]}"; do
            just rebuild-image "$IMAGE" "$VERSION" "$TIMESTAMP"
        done
    done

    if {{ container_runtime }} login --get-login "{{ registry }}"; then
        {{ container_runtime }} logout "{{ registry }}"
    fi
