## Base image

Choosing the right base image is important for the following reasons:

- During development, you want to have easy access to common tools (e.g. `curl`, `git`, `apt-get`, `bash`).
- When running the container in production, you want the image to have as few unnecessary dependencies as possible because any unnecessary program is a potential security risk.
- When pulling the image from the docker registry (e.g. via kubernetes, or docker cli), you want the image to be as small as possible to reduce bandwidth usage and speed up the download process.
- When pushing the image to the docker registry, you want the image to be as small as possible to reduce bandwidth usage.
- When storing the image in the docker Registry, you want the image to be as small as possible to reduce the amount of disk space it takes up.

## Bookworm, bullseye, etc.

Names such as `bookworm`, `bullseye`, etc. refer to the version of `debian` operating system. The current LTS version is called `bookworm`, and that's the only version that should be used. These images also have their `*-slim` versions, which have fewer dependencies, and should be prefered for local and production setups.

## Alpine

The `alpine` images are designed to be even smaller than `*-slim` images. They contain less dependencies and have less security issues. They are not officially supported, so sometimes you may encounter [problems](https://snyk.io/blog/choosing-the-best-node-js-docker-image/). It is easier to use so-called `*-slim` versions of images instead of `alpine` images.

## Distroless

Google maintains so-called `distroless` images. These images are build to contain the bare minimum of dependencies required to run an application in a particular language. For example, they don't have shells (e.g. `zsh`, `bash`, `sh`). This approach reduces image size to the absolute minimum and reduces security risks even further than `alpine` images, but the lack of typical tools available in the Linux environment makes them difficult to work with.

## dumb-init

`dumb-init` is a program that was designed to be run as an `init process`. The `init process` is a process that is started with `PID=1` and is treated in a special way by the Linux kernel.

Node.js was not designed to be run with `PID=1`, so some system signals will not be correctly handled. [Here](https://github.com/nodejs/docker-node/blob/main/docs/BestPractices.md#handling-kernel-signals) is a detailed explanation of the problem. The solution to the problem is to implement the so-called `init system`, i.e. by running a program specifically designed to have `PID=1` first.

## Resources

- [10 best practices to containerize Node.js web applications with Docker.](https://snyk.io/blog/10-best-practices-to-containerize-nodejs-web-applications-with-docker/)
- [Alpine, Slim, Stretch, Buster, Jessie, Bullseye — What are the Differences in Docker Images?](https://medium.com/swlh/alpine-slim-stretch-buster-jessie-bullseye-bookworm-what-are-the-differences-in-docker-62171ed4531d)
- [Choosing the best Node.js Docker image.](https://snyk.io/blog/choosing-the-best-node-js-docker-image/)
- [Docker and Node.js Best Practices.](https://github.com/nodejs/docker-node/blob/main/docs/BestPractices.md)
- [Docker for Node.js developers: 5 things you need to know not to fail your security.](https://snyk.io/blog/docker-for-node-js-developers-5-things-you-need-to-know/)
