FROM node:23-alpine AS base

RUN apk update && apk add --no-cache jq curl yq unzip

# Install hyperlane-cli
RUN yarn global add @hyperlane-xyz/cli@7.0.0

WORKDIR /app

COPY ./script ./script
COPY ./example/src ./example/src
COPY ./example/warp ./example/warp
COPY ./example/index.ts ./example/index.ts
COPY ./package.json ./
RUN yarn install

# download and unzip artifacts
RUN curl -s -L -O https://github.com/many-things/cw-hyperlane/releases/download/v0.0.6/cw-hyperlane-v0.0.6.zip && unzip -q cw-hyperlane-v0.0.6.zip -d ./artifacts

COPY ./entry-point.sh ./
RUN chmod +x ./entry-point.sh

CMD ["sh", "entry-point.sh"]
