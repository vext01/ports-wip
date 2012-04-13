# $OpenBSD: Makefile.template,v 1.61 2012/03/29 13:41:58 sthen Exp $

COMMENT =		integrated learning environment for Java

V =			307
DISTNAME =		BlueJ-source-307
EXTRACT_SUFX =		.zip
PKGNAME =		bluej-${V}

#SHARED_LIBS =		???

CATEGORIES =		education devel java

HOMEPAGE =		http://www.bluej.org

MAINTAINER =		Edd Barrett <edd@openbsd.org>

# XXX
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

MASTER_SITES =		${HOMEPAGE}/download/files/source/

MODULES =		java
MODJAVA_VER =		1.7
MODJAVA_BUILD =		ant
PORTHOME =		${WRKDIR} # build wants to write to /home/davmac/workspace

# javac is a whiner when it comes to unicode chars in comments
MAKE_ENV +=		LC_ALL=en_US.UTF-8 CLASSPATH=${WRKSRC}/lib

# zip file with no top level directory
do-extract:
	mkdir ${WRKDIR}/${DISTNAME} &&cd ${WRKDIR}/${DISTNAME} && ${UNZIP} -qq ${FULLDISTDIR}/${DISTNAME}${EXTRACT_SUFX}

SUBST_VARS +=		JAVA_HOME WRKDIR
pre-configure:
	${SUBST_CMD} ${WRKSRC}/build.properties

#USE_GMAKE =		Yes
#USE_GROFF =		Yes
#CONFIGURE_STYLE =	
#CONFIGURE_SCRIPT =	??? (if other than configure)
#CONFIGURE_ARGS +=	${CONFIGURE_SHARED}
#CONFIGURE_ENV =	???

#NO_REGRESS =		Yes

.include <bsd.port.mk>
