# $OpenBSD: Makefile.template,v 1.60 2010/10/24 20:41:23 ajacoutot Exp $

COMMENT =		interface to various LCD displays
DISTNAME =		lcdproc-0.5.5
CATEGORIES =		comms devel
HOMEPAGE =		http://www.lcdproc.org
MAINTAINER =		Edd Barrett <edd@openbsd.org>

# GPLv2
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

LIB_DEPENDS =		devel/libftdi \
			devel/libusb1 \
			devel/libhid
BUILD_DEPENDS =		textproc/xmlto \
			devel/doxygen
WANTLIB +=		c ftdi hid kvm ncurses pthread usb

MASTER_SITES =		${MASTER_SITE_SOURCEFORGE:=lcdproc/}

CONFIGURE_STYLE =	gnu
CONFIGURE_ENV =		CPPFLAGS=-I${LOCALBASE}/include LDFLAGS=-L${LOCALBASE}/lib
# xosd driver is busted, working on it upstream
# http://lists.omnipotent.net/pipermail/lcdproc/2011-November/013871.html
CONFIGURE_ARGS =	--enable-drivers=all,!xosd \
			--enable-doxygen

EXAMPLE_DIR = ${PREFIX}/share/examples/lcdproc
post-install:
	${INSTALL_DATA_DIR} ${EXAMPLE_DIR}
	${SUBST_CMD} -c ${WRKBUILD}/LCDd.conf ${EXAMPLE_DIR}/LCDd.conf
	${SUBST_CMD} -c ${WRKBUILD}/clients/lcdexec/lcdexec.conf ${EXAMPLE_DIR}/lcdexec.conf
	${SUBST_CMD} -c ${WRKBUILD}/clients/lcdproc/lcdproc.conf ${EXAMPLE_DIR}/lcdproc.conf
	chown -R ${SHAREOWN}:${SHAREGRP} ${EXAMPLE_DIR}
# lcdvc is a linux specific thing - prevent it appearing in PLIST
	rm ${PREFIX}/bin/lcdvc
	rm ${PREFIX}/man/man1/lcdvc.1

.include <bsd.port.mk>
