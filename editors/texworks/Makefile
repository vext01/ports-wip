# $OpenBSD: Makefile,v 1.9 2010/11/15 23:22:07 espie Exp $

COMMENT-main =		easy to use LaTeX and ConTeXt editor
COMMENT-python =	Python scripting for TeXworks
COMMENT-lua =		Lua scripting for TeXworks

V =			0.4.0
DISTNAME =		texworks-${V}-r759
PKGNAME =		texworks-${V}
WRKDIST =		${WRKDIR}/texworks-${V}
PKGNAME-main =		texworks-${V}

CATEGORIES =		editors print
HOMEPAGE =		http://www.tug.org/texworks/
MAINTAINER =		Edd Barrett <edd@openbsd.org>

# GPLv2
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

SHARED_ONLY =		Yes
WANTLIB +=		QtDBus QtGui QtScript QtScriptTools QtXml c \
			hunspell-1.2 m poppler poppler-qt4 pthread stdc++ z
WANTLIB-lua =
WANTLIB-python =

MULTI_PACKAGES =	-main -lua -python

# XXX multi package this
#WANTLIB-python =	python2.6
#WANTLIB-lua =		lua

MASTER_SITES =		http://texworks.googlecode.com/files/

MODULES =		x11/qt4
LIB_DEPENDS =		textproc/hunspell \
			x11/dbus \
			print/poppler,-qt4
RUN_DEPENDS = 		print/texlive/base

USE_GMAKE =		Yes
NO_REGRESS =		Yes

SUBST_VARS +=		WRKINST

pre-configure:
	${SUBST_CMD} ${WRKSRC}/TeXworks.pro
	#${SUBST_CMD} ${WRKSRC}/plugins-src/TWPythonPlugin/TWPythonPlugin.pro

PLUGIN_SRC =		${WRKSRC}/plugins-src
do-configure:
	cd ${PLUGIN_SRC}/TWPythonPlugin && qmake4	
	cd ${PLUGIN_SRC}/TWLuaPlugin && qmake4	
	cd ${WRKSRC} && qmake4

# build plugins first
pre-build:
	cd ${PLUGIN_SRC}/TWPythonPlugin && gmake
	cd ${PLUGIN_SRC}/TWLuaPlugin && gmake
	
# install extra bits
# XXX scripts?
post-install:
	${INSTALL_DATA_DIR} ${PREFIX}/lib/texworks
	${INSTALL_DATA} ${PLUGIN_SRC}/TWPythonPlugin/libTWPythonPlugin.so \
		${PREFIX}/lib/texworks/
	${INSTALL_DATA} ${PLUGIN_SRC}/TWLuaPlugin/libTWLuaPlugin.so \
		${PREFIX}/lib/texworks/

.include <bsd.port.mk>
