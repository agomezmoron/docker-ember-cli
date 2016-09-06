# docker-ember-cli
Docker image to work with Emberjs.

<img src="img/docker_logo.png" height="125" />
<img src="img/ember_logo.png" height="125" />
<img src="img/npmbower_logo.png" height="125" />

## Table of Contents
  - [Requirements](#requirements)
  - [Docker build](#docker-build)
  - [Docker run](#docker-run)
  - [Docker stop](#docker-stop)
  - [Docker cheat sheet](https://github.com/wsargent/docker-cheat-sheet)
  - [Cleaning untagged images](#cleaning-untagged-images)

## Requirements

You have to install [Docker](https://www.docker.com/) following the [installation steps](https://docs.docker.com/engine/installation/) (choose your OS).

## Docker Build

There are two options to build the image:

### 1) Building the entire image

You can build the app from this directory running:

```
docker build -t agomezmoron/docker-ember-cli .
```

### 2) Pulling from Docker

You can pull the image from Docker:

```
docker pull agomezmoron/docker-ember-cli
```

## Docker Run

Run the image with the following command:

```
docker run --privileged -v /YOUR/SOURCES/FOLDER:/src -p 90:4200  -e EMBER_SERVER="ember" -e EMBER_PROFILE="development" -t -i agomezmoron/docker-ember-cli
```

or

```
docker run --privileged -v /YOUR/SOURCES/FOLDER:/src -p 90:80  -e EMBER_SERVER="apache2" -e EMBER_PROFILE="development" -t -i agomezmoron/docker-ember-cli
```

And you will have your docker running on the 90 port.

### Run variables

 * **EMBER_SERVER:** Two possible values: "ember" or "apache2". By default, "ember".
 * **EMBER_PROFILE:** By default, "development".

## Docker Stop

Once Docker is running our image, there is a way to stop it:

 * Execute **docker ps** and you will get the Container ID.
 * Then, execute **docker kill CONTAINER_ID** and the Docker image will be stoped.

## Cleaning untagged images

If you want to clean all the untagged images you have in your Docker you can perform:

```
docker rmi -f $(docker images -f "dangling=true" -q) &> /dev/null
```

and it will detelete all the past images of the builds, so the PC does not end up with several duplicated images. It can be removed without affecting the build.
