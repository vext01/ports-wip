# $OpenBSD$

COMMENT =	duke nukem 3d shareware
PKGNAME =	duke3ddata-1.0
CATEGORIES =	games
EXTRACT_SUFX =	.zip

HOMEPAGE =	http://www.idsoftware.com

MAINTAINER =	Ryan Freeman <ryan@slipgate.org>

# shareware
PERMIT_PACKAGE_CDROM =  "Data cannot be put on CDROM"
PERMIT_PACKAGE_FTP =    Yes
PERMIT_DISTFILES_CDROM ="Data cannot be put on CDROM"
PERMIT_DISTFILES_FTP =  Yes

MASTER_SITES =	ftp://ftp.3drealms.com/share/
DISTFILES =	3dduke13.zip

NO_REGRESS =	Yes
NO_BUILD =	Yes

# dumb zipfile doesn't make a dir
post-extract:
	echo "a" | ${LOCALBASE}/bin/unzip -d ${WRKDIR}/shareware ${WRKDIR}/DN3DSW13.SHR

do-install:
	${INSTALL_DATA_DIR} ${PREFIX}/share/duke3d/
	cd ${WRKDIR}/shareware && for i in *; \
		do ${INSTALL_DATA} $$i ${PREFIX}/share/duke3d/; done

.include <bsd.port.mk>

