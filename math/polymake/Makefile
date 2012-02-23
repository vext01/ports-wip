# $OpenBSD: Makefile.template,v 1.60 2010/10/24 20:41:23 ajacoutot Exp $
COMMENT =		polytope analysis program

# 
DISTNAME =		polymake-2.10-2
EXTRACT_SUFX =		.tar.bz2
WRKDIST =		${WRKDIR}/polymake-2.10

#SHARED_LIBS =		???

CATEGORIES =		math

HOMEPAGE =		http://polymake.org

MAINTAINER =		Edd Barrett <edd@openbsd.org>

# XXX
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

#WANTLIB =		???

MASTER_SITES =		${HOMEPAGE}/lib/exe/fetch.php/download/

# Dependencies
#MODULES =		???
#BUILD_DEPENDS =	???
#RUN_DEPENDS =		???
LIB_DEPENDS =		textproc/libxml \
			devel/gmp \
			devel/readline
RUN_DEPENDS =		textproc/libxslt \
			textproc/p5-XML-LibXML \
			textproc/p5-XML-LibXSLT \
			devel/p5-Term-ReadLine-Gnu \
			textproc/p5-XML-Writer
BUILD_DEPENDS =		${RUN_DEPENDS}
#REGRESS_DEPENDS =	???

USE_GMAKE =		Yes
#USE_GROFF =		Yes
CONFIGURE_STYLE =	simple
CONFIGURE_ARGS =	--with-gmp=${LOCALBASE}

#NO_REGRESS =		Yes

.include <bsd.port.mk>
