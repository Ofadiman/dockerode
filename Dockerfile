# Specify the exact version of the base image, including SHA256, to be sure that the image has not been silently modified.
FROM node:22.11.0-bookworm-slim@sha256:4b44c32c9f3118d60977d0dde5f758f63c4f9eac8ddee4275277239ec600950f AS development

# Install the system dependencies required for local development.
RUN apt-get update && \
    apt-get install -y curl dumb-init && \
    rm -rf /var/lib/apt/lists/*

# Install neovim.
RUN curl -Lo /tmp/nvim-linux64.tar.gz https://github.com/neovim/neovim/releases/download/v0.10.2/nvim-linux64.tar.gz && \
    tar -C /usr/local -xzf /tmp/nvim-linux64.tar.gz && \
    mv /usr/local/nvim-linux64 /usr/local/nvim && \
    ln -s /usr/local/nvim/bin/nvim /usr/local/bin/nvim && \
    rm /tmp/nvim-linux64.tar.gz

# Change the root user to an unprivileged user for security reasons.
USER node

# Configure the working directory. For node images, `/home/node` is created for the node user.
WORKDIR /home/node/dockerode

# Copy the files required to run the application from the host to the image and change their ownership to the current user. Files specified in `.dockerignore` will not be copied.
COPY --chown=node:node . .

# Install the project dependencies.
RUN npm install
