# $OpenBSD$
# $FreeBSD: ports/devel/libdwarf/Makefile,v 1.8 2011/06/18 13:49:07 dhn Exp $

V =		20100204
DISTNAME=	libdwarf-${V}
CATEGORIES=	devel
MASTER_SITES=	ftp://ftp.fr.freebsd.org/pub/FreeBSD/ports/distfiles/

MAINTAINER=	Edd Barrett <edd@openbsd.org>
COMMENT=	library to analyze DWARF debugging information in ELF files

SHARED_LIBS =			dwarf		0.0

# XXX
PERMIT_PACKAGE_CDROM =		Yes
PERMIT_PACKAGE_FTP =		Yes
PERMIT_DISTFILES_CDROM =	Yes
PERMIT_DISTFILES_FTP =		Yes

CONFIGURE_STYLE =	gnu
WRKDIST =		${WRKDIR}/dwarf-${V}/libdwarf

BUILD_DEPENDS =		devel/libelf

CONFIGURE_ENV+= CFLAGS="-fPIC" \
		CPPFLAGS="-I${LOCALBASE}/include -I${LOCALBASE}/include/libelf" \
		LDFLAGS="-L${LOCALBASE}/lib"

# sub in correct libdwarf .so version
post-configure:
	${SUBST_CMD} ${WRKSRC}/Makefile

# build shared lib (default make target makes only static archive)
post-build:
	cd ${WRKBUILD} && ${MAKE} ${MAKE_FLAGS} libdwarf.so


DOC_FILES =	dwarf.v2.pdf index.v2.pdf libdwarf2.1.pdf \
		libdwarf2p.1.pdf mips_extensions.pdf
DOC_INST =	${PREFIX}/share/doc/libdwarf

do-install:
		${INSTALL_DATA} ${WRKBUILD}/libdwarf.a ${PREFIX}/lib
		${INSTALL_DATA} ${WRKBUILD}/libdwarf.so.${LIBdwarf_VERSION} \
			${PREFIX}/lib
		${INSTALL_DATA} ${WRKBUILD}/dwarf.h ${PREFIX}/include
		${INSTALL_DATA} ${WRKBUILD}/libdwarf.h ${PREFIX}/include
		${INSTALL_DATA_DIR} ${PREFIX}/share/doc/libdwarf
		for f in ${DOC_FILES}; do \
			${INSTALL_DATA} ${WRKBUILD}/$$f ${DOC_INST}/$$f ; \
		done

.include <bsd.port.mk>
