# $OpenBSD: Makefile,v 1.27 2011/09/16 10:31:22 espie Exp $

COMMENT=	environment for rapid engineering and scientific processing

V=		4.1
DISTNAME=	FreeMat-${V}-Source
PKGNAME=	freemat-${V}

CATEGORIES=	graphics math

HOMEPAGE=	http://freemat.sourceforge.net/

# GPL
PERMIT_PACKAGE_CDROM=	Yes
PERMIT_PACKAGE_FTP=	Yes
PERMIT_DISTFILES_CDROM=	Yes
PERMIT_DISTFILES_FTP=	Yes

WANTLIB += GL GLU ICE SM X11 Xext c ffi m ncurses pcre pthread stdc++
WANTLIB += z amd fftw3 fftw3f portaudio umfpack
WANTLIB += QtGui QtNetwork QtOpenGL QtSvg QtXml

MASTER_SITES=	${MASTER_SITE_SOURCEFORGE:=freemat/}

MODULES=	x11/qt4 devel/cmake

LIB_DEPENDS=	audio/portaudio-svn \
		devel/libffi \
		devel/pcre \
		math/amd \
		math/fftw3,double \
		math/fftw3,float \
		math/umfpack \
		devel/boost \
		devel/llvm

NO_REGRESS=	Yes

SUBST_VARS=	V

# Cmake does not find our umfpack and amd includes, and thus tries to build an internal copy.
# We tell it where to look and external libs are used.
CONFIGURE_ARGS += -DUMFPACK_SYS_INCLUDE_DIR:PATH=${LOCALBASE}/include/umfpack
CONFIGURE_ARGS += -DAMD_SYS_INCLUDE_DIR:PATH=${LOCALBASE}/include/amd

post-extract:
	@cd ${WRKSRC} && find . -name \*.moc.cpp | xargs rm

pre-configure:
	@rm ${WRKSRC}/CMakeCache.txt

post-install:
	@mv ${PREFIX}/bin/FreeMat ${PREFIX}/bin/freemat

.include <bsd.port.mk>
