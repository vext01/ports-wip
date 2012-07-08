# $OpenBSD$

COMMENT =		ELF and DWARF parser library for Python

MODPY_EGG_VERSION =	0.20
DISTNAME =		pyelftools-${MODPY_EGG_VERSION}
PKGNAME =		py-elftools-${MODPY_EGG_VERSION}
CATEGORIES =		devel

HOMEPAGE =		http://ragestorm.net/distorm/
MAINTAINER =		Edd Barrett <edd@openbsd.org>

# GPLv2 - or commercial license if consumer is not GPLv2 XXX
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

MASTER_SITES =		${MASTER_SITE_PYPI:=p/pyelftools/}
MODULES =		lang/python
#NO_REGRESS =		Yes

EXAMPLEDIR =	${PREFIX}/share/examples/distorm
post-install:
	${INSTALL_DATA_DIR} ${EXAMPLEDIR}
	cd ${WRKSRC}/examples &&  \
	for i in *.py; do \
		echo ${EXAMPLEDIR}; \
		echo ${WRKSRC}/examples/$$i; \
		${INSTALL_SCRIPT} $$i ${EXAMPLEDIR}; \
	done

.include <bsd.port.mk>
