# $OpenBSD: Makefile.template,v 1.60 2010/10/24 20:41:23 ajacoutot Exp $

COMMENT =		BSD licensed Gopher Server
DISTNAME =		gophernicus-1.1
CATEGORIES =		net
HOMEPAGE =		gopher://gophernicus.org
MAINTAINER =		Edd Barrett <edd@openbsd.org>

# BSD
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

WANTLIB =		c

MASTER_SITES =		http://gophernicus.org/software/gophernicus/server/
FAKE_FLAGS +=		DESTDIR=${DESTDIR} PREFIX=${PREFIX}

EXAMPLE_DIR =		${PREFIX}/share/examples/gophernicus
post-install:
			${INSTALL} -d ${EXAMPLE_DIR}
			${INSTALL} ${WRKINST}/var/gopher/gophermap \
				${EXAMPLE_DIR}

.include <bsd.port.mk>
