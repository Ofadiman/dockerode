# Specify the exact version of the base image, including SHA256, to be sure that the image has not been silently modified.
FROM node:22.11.0-bookworm-slim@sha256:4b44c32c9f3118d60977d0dde5f758f63c4f9eac8ddee4275277239ec600950f AS dev

# Install system dependencies required for local development.
RUN apt-get update && \
    apt-get install -y curl && \
    rm -rf /var/lib/apt/lists/*

# Install neovim.
RUN curl -Lo /tmp/nvim-linux64.tar.gz https://github.com/neovim/neovim/releases/download/v0.10.2/nvim-linux64.tar.gz && \
    tar -C /usr/local -xzf /tmp/nvim-linux64.tar.gz && \
    mv /usr/local/nvim-linux64 /usr/local/nvim && \
    ln -s /usr/local/nvim/bin/nvim /usr/local/bin/nvim && \
    rm /tmp/nvim-linux64.tar.gz

# Configure working directory. For node images, /home/node is created for the node user.
WORKDIR /home/node/dockerode

# Copy the files required to run the application from the host to the image. Files configured in .dockerignore will not be copied.
COPY . .

# Install project dependencies.
RUN npm install

CMD ["npm", "run", "dev"]

FROM dev AS builder

# Install system dependencies required for production environment.
RUN apt-get update && \
    apt-get install -y dumb-init && \
    rm -rf /var/lib/apt/lists/*

# Build the production version of the application.
RUN npm run build:prod

FROM node:22.11.0-bookworm-slim@sha256:4b44c32c9f3118d60977d0dde5f758f63c4f9eac8ddee4275277239ec600950f AS prod

# Change the root user to an unprivileged user for security reasons.
USER node

# Copy the necessary files and binaries to run the production version of the application. Copied files must be owned by the node user.
COPY --from=builder --chown=node:node /home/node/dockerode/dist/main.cjs /home/node/dockerode/main.cjs
COPY --from=builder --chown=node:node /usr/bin/dumb-init /usr/bin/dumb-init

# Start the production version of the application. The dumb-init binary runs as the init process. The node binary must be started with node, not npm, because npm does not correctly pass all system signals (e.g. SIGHUP).
CMD ["dumb-init", "node", "/home/node/dockerode/main.cjs"]
