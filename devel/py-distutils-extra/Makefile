# $OpenBSD: Makefile,v 1.6 2011/09/16 09:24:55 espie Exp $

COMMENT=		add support for i18n, documentation and icons to distutils

VERSION=		2.33
DISTNAME=		python-distutils-extra-${VERSION}
PKGNAME=		py-distutils-extra-${VERSION}

CATEGORIES=		devel

HOMEPAGE =		https://launchpad.net/python-distutils-extra

# GPLv2
PERMIT_PACKAGE_CDROM=	Yes
PERMIT_PACKAGE_FTP=	Yes
PERMIT_DISTFILES_CDROM= Yes
PERMIT_DISTFILES_FTP=	Yes

MASTER_SITES=		${HOMEPAGE}/trunk/2.33/+download/

MODULES=		lang/python
MODPY_EGG_VERSION=	2.33
MODPY_SETUPTOOLS=	Yes
#MODPY_BADEGGS= 		python_distutils_extra

# Pointless test that checks if the bzr checkout builds.
NO_REGRESS=		Yes

.include <bsd.port.mk>
