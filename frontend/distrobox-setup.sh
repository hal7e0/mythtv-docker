#!/bin/bash
set -e

# Recreate the distrobox for mythfrontend
DBX_CONTAINER_ALWAYS_PULL=0 distrobox assemble create -R --file "mythfrontend.ini"
