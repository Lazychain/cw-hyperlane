FROM node:23-alpine AS base

ENV YARN_VERSION=4.2.2

RUN apk update && apk add --no-cache jq curl yq unzip
# install and use yarn 4.x
RUN corepack enable && corepack prepare yarn@${YARN_VERSION}

# Install hyperlane-cli
RUN yarn global add @hyperlane-xyz/cli@7.0.0

WORKDIR /app

COPY ./script ./script
COPY ./package.json ./yarn.lock ./
COPY ./entry-point.sh ./
RUN yarn install --immutable

# download and unzip artifacts
RUN curl -s -L -O https://github.com/many-things/cw-hyperlane/releases/download/v0.0.6/cw-hyperlane-v0.0.6.zip && unzip -q cw-hyperlane-v0.0.6.zip -d ./artifacts

RUN chmod +x ./entry-point.sh

CMD ["sh", "entry-point.sh"]
