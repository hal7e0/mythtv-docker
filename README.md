# mythtv-docker
Container builds for MythTV.

## Prerequisites
These images do not provide a database for mythbackend. It is recommended to
use the official [MariaDB](https://hub.docker.com/_/mariadb) image in combination
with these images.

## Provided images
This repository currently provides image builds for MythTV 33, 34, and 35.
Images for MythTV 34 and 35 are based on Ubuntu 24.04; images for MythTV 33
are based on Ubuntu 22.04. All mythfrontend images are based on Ubuntu 22.04
due to graphical issues with 24.04.

  - `mythbackend`: MythTV Backend Server.
  - `mythfrontend`: MythTV Frontend application running in Docker.
  - `mythweb`: MythWeb PHP component.
    - This component has been removed in MythTV 35 in favor of the built-in
      web server in `mythbackend`.
