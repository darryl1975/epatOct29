#!/usr/bin/env bash
# Build the d13revision Docker image and run it as a container in Docker Desktop.
#
# Usage: ./build.sh [tag]
#   Env overrides: IMAGE_NAME, CONTAINER_NAME, HOST_PORT, CONTAINER_PORT

set -euo pipefail

IMAGE_NAME="${IMAGE_NAME:-d13revision}"
IMAGE_TAG="${1:-latest}"
CONTAINER_NAME="${CONTAINER_NAME:-d13revision-app}"
HOST_PORT="${HOST_PORT:-8080}"
CONTAINER_PORT="${CONTAINER_PORT:-8080}"

cd "$(dirname "$0")"

# Make sure Docker Desktop is running (start it on macOS if not)
if ! docker info >/dev/null 2>&1; then
  if [[ "$(uname)" == "Darwin" ]]; then
    echo "Docker is not running. Starting Docker Desktop..."
    open -a Docker
    for _ in {1..60}; do
      docker info >/dev/null 2>&1 && break
      sleep 2
    done
  fi
  if ! docker info >/dev/null 2>&1; then
    echo "Error: Docker daemon is not available. Start Docker Desktop and retry." >&2
    exit 1
  fi
fi

echo "==> Building image ${IMAGE_NAME}:${IMAGE_TAG}"
docker build --tag "${IMAGE_NAME}:${IMAGE_TAG}" .

# Remove any existing container with the same name
if docker ps -a --format '{{.Names}}' | grep -qx "${CONTAINER_NAME}"; then
  echo "==> Removing existing container ${CONTAINER_NAME}"
  docker rm -f "${CONTAINER_NAME}" >/dev/null
fi

echo "==> Starting container ${CONTAINER_NAME} on port ${HOST_PORT}"
docker run -d \
  --name "${CONTAINER_NAME}" \
  -p "${HOST_PORT}:${CONTAINER_PORT}" \
  -e SERVER_PORT="${CONTAINER_PORT}" \
  "${IMAGE_NAME}:${IMAGE_TAG}"

echo "==> Waiting for app to start..."
for _ in {1..30}; do
  if curl -fs "http://localhost:${HOST_PORT}/actuator/health" >/dev/null 2>&1; then
    echo "App is up: http://localhost:${HOST_PORT}"
    exit 0
  fi
  sleep 2
done

echo "App did not report healthy yet. Recent logs:"
docker logs --tail 50 "${CONTAINER_NAME}"
echo "Follow logs with: docker logs -f ${CONTAINER_NAME}"
