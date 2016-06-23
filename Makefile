INSTALL=install
INSTALL_DATA=${INSTALL} -m 644
MKDIR_P=mkdir -p
prefix=/usr
exec_prefix=${prefix}
libdir=${exec_prefix}/lib

ATHEXTDIR = ${libdir}/debathena-firefox-extension
CHROMEDIR = ${ATHEXTDIR}/chrome
COMPONENTS_DIR = ${ATHEXTDIR}/components
COMPONENTS_FILES = athenaService.js
DEFAULTS_DIR = ${ATHEXTDIR}/defaults
PREFS_DIR = ${DEFAULTS_DIR}/preferences
PREFS_FILES = athena.js
CHROME_FILES = \
  content/athena.dtd \
  content/athena.properties \
  content/athena.xul \
  content/csailca.pem \
  skin/icon.png

all: athena.jar chrome.manifest

athena.jar:
	cd chrome && rm -f athena.jar && zip -0 -r athena.jar ${CHROME_FILES}

chrome.manifest: chrome.manifest.in
	sed -e 's|chrome/\([^/]*\)/|jar:chrome/athena.jar!/\1/|' \
	  chrome.manifest.in > chrome.manifest

check:

install:
	${MKDIR_P} ${DESTDIR}${ATHEXTDIR}
	${MKDIR_P} ${DESTDIR}${CHROMEDIR}
	${MKDIR_P} ${DESTDIR}${COMPONENTS_DIR}
	${MKDIR_P} ${DESTDIR}${PREFS_DIR}
	${INSTALL_DATA} chrome/athena.jar ${DESTDIR}${CHROMEDIR}
	${INSTALL_DATA} chrome.manifest ${DESTDIR}${ATHEXTDIR}
	for i in ${COMPONENTS_FILES} ; do \
	  ${INSTALL_DATA} "components/$$i" ${DESTDIR}${COMPONENTS_DIR} ; \
	done
	for i in ${PREFS_FILES} ; do \
	  ${INSTALL_DATA} "defaults/preferences/$$i" ${DESTDIR}${PREFS_DIR} ; \
	done
	${INSTALL_DATA} install.rdf ${DESTDIR}${ATHEXTDIR}

clean:

distclean:
	rm -f config.cache config.log config.status Makefile
