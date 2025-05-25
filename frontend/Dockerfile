# vim: set ft=dockerfile :
FROM ubuntu:22.04
ARG MYTHTV_VERSION=34
RUN apt-get update && apt-get dist-upgrade -y && apt-get install -y ca-certificates &&\
	rm -rf /var/lib/apt/lists/*

ADD https://keyserver.ubuntu.com/pks/lookup?op=get&search=0x60af0ee633670609 /usr/share/keyrings/mythbuntu-ppa.asc
RUN cat > /etc/apt/sources.list.d/mythbuntu-${MYTHTV_VERSION}-ppa.sources <<EOF
Types: deb
URIs: https://ppa.launchpadcontent.net/mythbuntu/${MYTHTV_VERSION}/ubuntu/
Suites: jammy
Components: main
Signed-By:
$(sed 's/^/ /' /usr/share/keyrings/mythbuntu-ppa.asc)
EOF

COPY <<EOF /etc/apt/preferences.d/mythbuntu-pin-550
Package: *
Pin: release o=LP-PPA-mythbuntu-${MYTHTV_VERSION}
Pin-Priority: 550
EOF

RUN apt-get update &&\
	DEBIAN_FRONTEND=noninteractive apt-get install -y mythtv-frontend mythtv-theme-mythbuntu &&\
	 rm -rf /var/lib/apt/lists/*
