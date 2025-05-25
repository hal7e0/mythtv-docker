# vim: set ft=dockerfile :
ARG UBUNTU_VERSION=noble
FROM ubuntu:${UBUNTU_VERSION}

RUN groupadd -rg 128 mythtv && useradd -ru 120 -md /home/mythtv -g mythtv mythtv && usermod -aG 39 mythtv
ARG MYTHTV_VERSION=34
ARG UBUNTU_VERSION=noble

RUN apt-get update && apt-get dist-upgrade -y && apt-get install -y ca-certificates &&\
	rm -rf /var/lib/apt/lists/*

ADD https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x60af0ee633670609 /usr/share/keyrings/mythbuntu-ppa.asc
RUN cat > /etc/apt/sources.list.d/mythbuntu-${MYTHTV_VERSION}-ppa.sources <<EOF
Types: deb
URIs: https://ppa.launchpadcontent.net/mythbuntu/${MYTHTV_VERSION}/ubuntu/
Suites: ${UBUNTU_VERSION}
Components: main
Signed-By:
$(sed 's/^/ /' /usr/share/keyrings/mythbuntu-ppa.asc)
EOF

COPY <<EOF /etc/apt/preferences.d/mythbuntu-pin-550
Package: *
Pin: release o=LP-PPA-mythbuntu-${MYTHTV_VERSION}
Pin-Priority: 550
EOF

RUN apt-get update && apt-get install -y mythtv-backend mythtv-database &&\
	rm -rf /var/lib/apt/lists/*

EXPOSE 6544/tcp
EXPOSE 6543/tcp
EXPOSE 6549/tcp
EXPOSE 6554/tcp
EXPOSE 6744/tcp
EXPOSE 1900/udp

USER mythtv:39
CMD mythbackend
