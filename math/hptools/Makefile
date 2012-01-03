# $OpenBSD: Makefile.template,v 1.60 2010/10/24 20:41:23 ajacoutot Exp $

COMMENT =		compilers and tools for HP RPL calculators

DISTNAME =		hptools-src-3.0.8
PKGNAME =		hptools-3.0.8

CATEGORIES =		math lang

# a bit stagnent to be honest
HOMEPAGE =		http://www.hpcalc.org/details.php?id=4263

MAINTAINER =		Edd Barrett <edd@openbsd.org>

# XXX
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Not for commercial use
PERMIT_DISTFILES_FTP =	Yes

WANTLIB =		c

MASTER_SITES =		http://www.hpcalc.org/hp48/pc/programming/
WRKDIST =		${WRKDIR}/Hptools

CONFIGURE_STYLE =	gnu dest

NO_REGRESS =		Yes

post-extract:
	mkdir ${WRKDIST}/build

WRKSRC =	${WRKDIST}/build

CONFIGURE_SCRIPT =	../support/configure

.include <bsd.port.mk>
