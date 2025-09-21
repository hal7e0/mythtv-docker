FROM alpine:latest

RUN apk add --no-cache g++ git cmake qt5-qtbase-dev qt5-qtscript-dev samurai\
    patch make pkgconf taglib-dev libsamplerate-dev soundtouch-dev libxrandr-dev\
    py3-mysqlclient py3-lxml py3-requests py3-pip py3-wheel perl-dbi\
    perl-dbd-mysql perl-xml-simple perl-io-socket-inet6 perl-app-cpanminus\
    php84 libxml2-dev lame-dev libva-dev libva-glx-dev libvdpau-dev libass-dev\
    dav1d-dev aom-dev gnutls-dev sdl2-dev libdrm-dev libbluray-dev exiv2-dev\
    vulkan-headers yasm && cpanm Net::UPnP && ln -s /usr/bin/php84 /usr/bin/php

WORKDIR /work
