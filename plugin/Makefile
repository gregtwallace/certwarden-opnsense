PKG = os-cert-warden-client-${VERSION}.pkg
VERSION= 0.1.1
COMMITHASH= ${git rev-parse HEAD:0:9}

PREFIX= /usr/local

.PHONY: all clean clean-stage

all: ${PKG}
clean: clean-stage
	rm -f ${PKG} pkg-plist manifest
clean-stage:
	rm -rf stage

SRC_FILES = ${:! find src -type f !}

${PKG}: clean-stage ${SRC_FILES}
	mkdir -p stage${PREFIX}
	cp -Rp src/ stage${PREFIX}/

	cat manifest.in | sed -e 's|%%VERSION%%|${VERSION}|' | sed -e 's|%%PREFIX%%|${PREFIX}|' | sed -e 's|%%COMMITHASH%%|${COMMITHASH}|' > manifest

# anything not in /scripts/
	echo ${:! find stage -type f -not -ipath '*/scripts/*' !:C/^stage//} | tr ' ' '\n' > pkg-plist
# plist keyword to make executable
	echo '@mode 755' >> pkg-plist
# executable files (i.e., /scripts/)
	echo ${:! find stage -type f -ipath '*/scripts/*' !:C/^stage//} | tr ' ' '\n' >> pkg-plist

	pkg create -M manifest -r stage -p pkg-plist
