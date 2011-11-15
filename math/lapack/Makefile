# $OpenBSD: Makefile,v 1.19 2011/03/08 23:45:47 ajacoutot Exp $

COMMENT=	library of Fortran 77 linear algebra subroutines

DISTNAME=	lapack-3.1.1
REVISION=	4

SHARED_LIBS=	lapack 6.0

CATEGORIES=	math

HOMEPAGE=	http://www.netlib.org/lapack/

# BSD
PERMIT_PACKAGE_CDROM=	Yes
PERMIT_PACKAGE_FTP=	Yes
PERMIT_DISTFILES_CDROM=	Yes
PERMIT_DISTFILES_FTP=	Yes

MASTER_SITES=	ftp://ftp.netlib.org/lapack/ \
		ftp://netlib.bell-labs.com/netlib/lapack/ \
		http://www.netlib.no/netlib/lapack/
EXTRACT_SUFX=	.tgz

LIB_DEPENDS =	math/blas
WANTLIB =	blas>=1

MODULES=	fortran
MODFORTRAN_COMPILER = gfortran
BUILD_DEPENDS=	${MODFORTRAN_BUILD_DEPENDS}

# XXX FC=
MAKE_ENV=	SHLIB_MAJOR=${LIBlapack_VERSION:R} \
		SHLIB_MINOR=${LIBlapack_VERSION:E} \
		FC=gfortran \
		TIMER=INT_ETIME
#		TIMER=EXT_ETIME \	XXX f77 only????
FAKE_FLAGS=	LIBDIR=${LOCALBASE}/lib DEBUGLIBS=no
USE_GROFF =	Yes
REGRESS_FLAGS=	PLAT= OPTS= FORTRAN=${FC} LOADER=${FC} \
		LAPACKLIB=SRC/liblapack.a \
		BLASLIB=${LOCALBASE}/lib/libblas.a

MAKE_FILE=	${FILESDIR}/Makefile
WRKSRC=		${WRKDIST}/SRC

# See bsd.lib.mk:162
.if ${MACHINE_ARCH:Mmips64*}
PKG_ARGS+=	-Dno_mips64=0
.else
PKG_ARGS+=	-Dno_mips64=1
.endif

# avoid 'unknown manpage type' errors and move manpages to section 3
pre-configure:
	cd ${WRKDIST}/manpages/man/manl && \
		perl -pi -e 's/(\.TH\s+\w+)\s+1(.*)/\1 3f\2/' *.l && \
	        for m in *.l ; do if ! egrep '^\.TH' $$m >/dev/null ; then \
                perl -pi -e "s/(.SH NAME)/.TH \U$${m%\.l} 3f\n\1/" $$m ; fi ; \
		mv $$m $${m%\.l}.3f ; done
	cp ${WRKDIST}/make.inc.example ${WRKDIST}/make.inc

post-install:
	${INSTALL_MAN} ${WRKDIST}/manpages/man/manl/*.3f ${PREFIX}/man/man3f/

do-regress:
	cd ${WRKDIST}/TESTING/MATGEN && ${MAKE} ${ALL_REGRESS_FLAGS}
	cd ${WRKDIST}/TESTING && ${MAKE} ${ALL_REGRESS_FLAGS}

.include <bsd.port.mk>