# $OpenBSD: Makefile,v 1.57 2012/01/13 00:55:14 naddy Exp $

# vax:   no IEEE arithmetic
# sparc: fPIC version of libgcc.a needed but not available
NOT_FOR_ARCHS=	vax sparc

COMMENT=	high-level language for numerical computations

VERSION=	3.6.1-rc0
DISTNAME=	octave-${VERSION}
CATEGORIES=	math

SHARED_LIBS=	cruft		5.0 \
		octave		5.0 \
		octinterp	4.0

HOMEPAGE=	http://www.gnu.org/software/octave/

MAINTAINER=	Steven Mestdagh <steven@openbsd.org>

# GPL v3
PERMIT_PACKAGE_CDROM=	Yes
PERMIT_PACKAGE_FTP=	Yes
PERMIT_DISTFILES_CDROM=	Yes
PERMIT_DISTFILES_FTP=	Yes

WANTLIB=	c m ncurses readline stdc++ z ${MODFORTRAN_WANTLIB} \
		fftw3>=3 lapack>=3 blas>=1 amd umfpack pcre>=1 curl>=6

#MASTER_SITES=	ftp://ftp.octave.org/pub/octave/ \
#		ftp://ftp.u-aizu.ac.jp/pub/SciEng/numanal/Octave/ \
#		ftp://neacm.fe.up.pt/pub/octave/
MASTER_SITES =	ftp://alpha.gnu.org/gnu/octave/

MODULES=	fortran
MODFORTRAN_COMPILER = gfortran

BUILD_DEPENDS=	${MODFORTRAN_BUILD_DEPENDS} \
		devel/desktop-file-utils
RUN_DEPENDS=	devel/gmake \
		devel/desktop-file-utils
LIB_DEPENDS=	${MODFORTRAN_LIB_DEPENDS} \
		math/fftw3 \
		devel/glpk \
		blas-*-gfortran:math/blas,gfortran \
		lapack-*-gfortran:math/lapack,gfortran \
		math/amd \
		math/umfpack \
		devel/pcre \
		net/curl

USE_GMAKE=	Yes
USE_GROFF =	Yes

SEPARATE_BUILD=	simple
CONFIGURE_STYLE=gnu
#AUTOCONF_VERSION=2.61
MODFORTRAN_COMPILER =   gfortran
FC =			gfortran
CONFIGURE_ARGS=	${CONFIGURE_SHARED} \
		--with-fftw \
		--without-mpi \
		--without-hdf5
#		--disable-docs	# texi errors XXX
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
#GCC_ARCH=	${MACHINE_ARCH}-unknown-openbsd${OSREV}
#GNU_ARCH=	${GCC_ARCH:S/amd64/x86_64/}
#SUBST_VARS=	GNU_ARCH VERSION

# need to use fpic version of libgcc.a
#post-configure:
#	@perl -pi -e 's#(gcc-lib/${GCC_ARCH}/[\d.]+)\s#\1/fpic #' \
#		${WRKBUILD}/Makeconf

#.ifmake regress
# some tests need HOME to be writable
#PORTHOME=	/tmp
# define some user for tilde expansion test
#MAKE_ENV+=	USER=nobody
#.endif

#post-regress:
#	@rm -f /tmp/oct-*

# fix ls-R and install HTML documentation
#HTMLDOCS=	interpreter liboctave
#post-install:
#	@cd ${PREFIX}/share/octave && \
#		perl -pi -e "s,${PREFIX},${TRUEPREFIX}," ls-R
#	@cd ${PREFIX}/libexec/octave && \
#		perl -pi -e "s,${PREFIX},${TRUEPREFIX}," ls-R
#.for d in ${HTMLDOCS}
#	${INSTALL_DATA_DIR} ${PREFIX}/share/doc/octave/${d}
#	${INSTALL_DATA} ${WRKBUILD}/doc/${d}/HTML/*.html \
#		${PREFIX}/share/doc/octave/${d}
#.endfor

.include <bsd.port.mk>
