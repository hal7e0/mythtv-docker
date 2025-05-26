#!/bin/bash
set -e

# Recreate the distrobox for mythfrontend
distrobox assemble create -R --file "mythfrontend.ini"
