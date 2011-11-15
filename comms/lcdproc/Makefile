# $OpenBSD: Makefile.template,v 1.60 2010/10/24 20:41:23 ajacoutot Exp $

COMMENT =		interface to various LCD displays

DISTNAME =		lcdproc-0.5.5

#SHARED_LIBS =		???

CATEGORIES =		comms devel

HOMEPAGE =		http://www.lcdproc.org

#MAINTAINER =		???

# XXX
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

WANTLIB +=		c kvm ncurses

MASTER_SITES =		${MASTER_SITE_SOURCEFORGE:=lcdproc/}

CONFIGURE_STYLE =	gnu

EXAMPLE_DIR = ${PREFIX}/share/examples/lcdproc
post-install:
	${INSTALL_DATA_DIR} ${EXAMPLE_DIR}
	${SUBST_CMD} -c ${WRKBUILD}/LCDd.conf ${EXAMPLE_DIR}/
	${SUBST_CMD} -c ${WRKBUILD}/lcdexec/lcdexec.conf ${EXAMPLE_DIR}/
	${SUBST_CMD} -c ${WRKBUILD}/lcdproc/lcdproc.conf ${EXAMPLE_DIR}/
	${SUBST_CMD} -c ${WRKBUILD}/lcdvc/lcdvc.conf ${EXAMPLE_DIR}/

.include <bsd.port.mk>
