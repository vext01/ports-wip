# $OpenBSD: Makefile.template,v 1.60 2010/10/24 20:41:23 ajacoutot Exp $

COMMENT =		rpl/2 programming language

V =			4.1.4
DISTNAME =		rpl-${V}
PKGNAME =		rpl2-${V}

#SHARED_LIBS =		???

CATEGORIES =		math devel

HOMEPAGE =		http://www.rpl2.net

MAINTAINER =		Edd Barrett <edd@openbsd.org>

# XXX
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

#WANTLIB =		???

MASTER_SITES =		http://www.rpl2.net/download/
EXTRACT_SUFX =		.tar.bz2

# XXX gfortran
MODULES =		gcc4
#BUILD_DEPENDS =	???
#RUN_DEPENDS =		???
#LIB_DEPENDS =		???
#REGRESS_DEPENDS =	???

USE_GMAKE =		Yes
#USE_GROFF =		Yes
#USE_LIBTOOL =		Yes
CONFIGURE_ENV +=	CPPFLAGS="-I${LOCALBASE}/include -I${X11BASE}/include"
CONFIGURE_ENV +=	LDFLAGS="-L${LOCALBASE}/lib -L${X11BASE}/lib"
CONFIGURE_STYLE =	gnu
CONFIGURE_ARGS +=	--disable-recursive \
			--disable-ncurses
PATCHORIG ?=		.origy

# The build will try to build all sorts of stuff statically inside.
# We don't want this!
DONT_BUILD_DEPS = file-5.03.tar.gz \
		  gnuplot-4.4.3.tar.gz \
		  gsl-1.15.tar.gz \
		  libXpm-3.5.9.tar.gz \
		  libiconv-1.13.1.tar.gz \
		  libsigsegv-2.6.tar.gz \
		  ncurses-5.9.tar.gz \
		  openmotif-2.3.3.tar.gz \
		  openssl-1.0.0e.tar.gz \
		  readline-6.2.tar.gz \
		  sqlite-3.7.9.tar.gz \
		  units-1.88.tar.gz
#post-extract:
#.for i in ${DONT_BUILD_DEPS}
#	rm ${WRKDIST}/tools/$i
#.endfor
#	rm -Rf ${WRKDIST}/tools

#NO_REGRESS =		Yes

.include <bsd.port.mk>
