# Use an official Node.js runtime as a parent image
FROM node:20 AS base


RUN mkdir /app \
    && chown node:node /app

WORKDIR /app


FROM base AS builder

WORKDIR /build
# Copy the package.json and yarn.lock n files
COPY package.json yarn.lock ./

# Install dependencies
RUN yarn install

COPY app/ ./app
COPY public/ ./public
COPY tsconfig.json ./
COPY tailwind.config.ts ./


# Build the Remix app
RUN yarn build && yarn install --production

FROM base AS packed

COPY --from=builder --chown=node:node /build/package.json ./
COPY --from=builder --chown=node:node /build/node_modules ./node_modules
COPY --from=builder --chown=node:node /build/build ./build
COPY --from=builder --chown=node:node /build/public ./public

USER node

ENV NODE_ENV production

# Define the command to run your app
CMD ["/app/node_modules/.bin/remix-serve", "/app/build/index.js"]
