ARG NODE_VERSION 16

FROM  node:${NODE_VERSION} As base

RUN set -eux; \
  apt-get update && \
  apt-get install --no-install-recommends \
    wget \
    git \
    apt-utils \
    ca-certificates \
    apt-transport-https \
    curl \
    gnupg \
    bzip2
  ; \
  rm -rf /var/lib/apt/lists/*

ENV DIR /src

WORKDIR $DIR

#FROM --platform=arm64 stage
FROM base AS deps

RUN --mount=type=bind,target=.,rw \
  --mount=type=cache,target=/src/node_modules \
  npm install && mkdir /vendor && cp package.json && cp package-lock.json


FROM deps AS build
RUN --mount=type=bind,target=.,rw \
  --mount=type=cache,target=/src/node_modules \
  npm run build && mkdir /out && cp -Rf dist /out/
#

FROM deps AS vendor-validate
RUN --mount=type=bind,target=.,rw <<EO
set -e
git add -A
cp -rf /vendor/* .
if [ -n "$(git status --porcelain -- yarn.lock)" ]; then
echo >&2 'ERROR: Vendor result differs. Please vendor your package with "docker buildx bake vendor-update"'
git status --porcelain -- yarn.lock
exit 1
fi
EOT




