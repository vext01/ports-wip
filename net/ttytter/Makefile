# $OpenBSD: Makefile.template,v 1.60 2010/10/24 20:41:23 ajacoutot Exp $

COMMENT =		console Twitter client

V =			1.1.11
DISTNAME =		${V}.txt
EXTRACT_SUFX =
PKGNAME =		ttytter-${V}

CATEGORIES =		net
HOMEPAGE =		http://www.floodgap.com/software/ttytter/
MAINTAINER =		Edd Barrett <edd@openbsd.org>

# FFSL
# http://www.floodgap.com/software/ffsl/license.html
PERMIT_PACKAGE_CDROM =	May not charge for this code
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =May not charge for this code
PERMIT_DISTFILES_FTP =	Yes

MASTER_SITES =		${HOMEPAGE}/dist1/
EXTRACT_ONLY =		

RUN_DEPENDS =		net/curl

NO_BUILD =		Yes
NO_REGRESS =		Yes

do-install:
	${INSTALL_SCRIPT} ${DISTDIR}/${V}.txt ${PREFIX}/bin/ttytter.pl

.include <bsd.port.mk>
