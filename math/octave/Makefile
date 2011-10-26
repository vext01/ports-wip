# $OpenBSD: Makefile,v 1.56 2011/09/16 10:31:22 espie Exp $

# vax:   no IEEE arithmetic
# sparc: fPIC version of libgcc.a needed but not available
NOT_FOR_ARCHS=	vax sparc

COMMENT=	high-level language for numerical computations

VERSION=	3.4.3
DISTNAME=	octave-${VERSION}
CATEGORIES=	math

SHARED_LIBS=	cruft		6.0 \
		octave		6.0 \
		octinterp	5.0

HOMEPAGE=	http://www.gnu.org/software/octave/

MAINTAINER=	Steven Mestdagh <steven@openbsd.org>

# GPL v3
PERMIT_PACKAGE_CDROM=	Yes
PERMIT_PACKAGE_FTP=	Yes
PERMIT_DISTFILES_CDROM=	Yes
PERMIT_DISTFILES_FTP=	Yes

WANTLIB=	c m ncurses readline stdc++ z ${MODFORTRAN_WANTLIB} \
		fftw3>=3 lapack>=3 blas>=1 amd umfpack pcre>=1 curl>=6

MASTER_SITES=	ftp://ftp.gnu.org/gnu/octave/

MODULES=	fortran
MODFORTRAN_COMPILER = g77

BUILD_DEPENDS=	${MODFORTRAN_BUILD_DEPENDS} \
		devel/desktop-file-utils
RUN_DEPENDS=	devel/gmake \
		devel/desktop-file-utils
LIB_DEPENDS=	${MODFORTRAN_LIB_DEPENDS} \
		math/fftw3 \
		math/lapack \
		math/blas \
		math/amd \
		math/umfpack \
		devel/pcre \
		net/curl \
		devel/glpk

USE_GMAKE=	Yes
USE_GROFF =	Yes

CONFIGURE_STYLE=gnu
CONFIGURE_ARGS=	${CONFIGURE_SHARED} \
		--with-fftw \
		--without-mpi \
		--without-hdf5
CONFIGURE_ENV=	CPPFLAGS="-I${LOCALBASE}/include -I${X11BASE}/include" \
		LDFLAGS="-L${LOCALBASE}/lib -L${X11BASE}/lib" \
		F77=${FC} \
		SED=/usr/bin/sed
MAKE_ENV=	LIBcruft_VERSION=${LIBcruft_VERSION} \
		LIBoctave_VERSION=${LIBoctave_VERSION} \
		LIBoctinterp_VERSION=${LIBoctinterp_VERSION}

.if ${MACHINE_ARCH} == "alpha"
CONFIGURE_ENV+=	FFLAGS="${FFLAGS}"
.endif

# needed to build on amd64
# hopefully can go XXX
GCC_ARCH=	${MACHINE_ARCH}-unknown-openbsd${OSREV}
GNU_ARCH=	${GCC_ARCH:S/amd64/x86_64/}
SUBST_VARS=	GNU_ARCH VERSION

# need to use fpic version of libgcc.a
# XXX this file does not exist any more, investigate
#post-configure:
#	@perl -pi -e 's#(gcc-lib/${GCC_ARCH}/[\d.]+)\s#\1/fpic #' \
#		${WRKBUILD}/Makeconf

# XXX still need this crap?
.ifmake regress
# some tests need PORTHOME to be writable
PORTHOME=	/tmp
# define some user for tilde expansion test
MAKE_ENV+=	USER=nobody
.endif

post-regress:
	@rm -f /tmp/oct-*

# fix ls-R and install HTML documentation
HTMLDOCS=	interpreter liboctave
post-install:
	@cd ${PREFIX}/share/octave && \
		perl -pi -e "s,${PREFIX},${TRUEPREFIX}," ls-R
	@cd ${PREFIX}/libexec/octave && \
		perl -pi -e "s,${PREFIX},${TRUEPREFIX}," ls-R
.for d in ${HTMLDOCS}
	${INSTALL_DATA_DIR} ${PREFIX}/share/doc/octave/${d}
	${INSTALL_DATA} ${WRKBUILD}/doc/${d}/HTML/*.html \
		${PREFIX}/share/doc/octave/${d}
.endfor

.include <bsd.port.mk>
