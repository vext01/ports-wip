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

MODULES =		x11/qt4

SHARED_ONLY =		Yes
WANTLIB +=		QtDBus QtGui QtScript QtScriptTools QtXml c \
			hunspell-1.2 m poppler poppler-qt4 pthread stdc++ z
WANTLIB-lua =		QtCore QtGui QtXml lua m stdc++
WANTLIB-python =	QtCore QtGui QtXml python2.6 stdc++ m

MULTI_PACKAGES =	-main -lua -python

MASTER_SITES =		http://texworks.googlecode.com/files/

BUILD_DEPENDS +=	lang/lua \
			lang/python/2.6
LIB_DEPENDS-main +=	${LIB_DEPENDS} \
			textproc/hunspell \
			x11/dbus \
			print/poppler,-qt4
LIB_DEPENDS-lua +=	lang/lua
LIB_DEPENDS-python +=	lang/python/2.6
RUN_DEPENDS-main = 	print/texlive/base
RUN_DEPENDS-lua =	editors/texworks,-main
RUN_DEPENDS-python =	editors/texworks,-main

USE_GMAKE =		Yes
NO_REGRESS =		Yes

SUBST_VARS +=		WRKINST

pre-configure:
	${SUBST_CMD} ${WRKSRC}/TeXworks.pro

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
post-install:
	${INSTALL_DATA_DIR} ${PREFIX}/lib/texworks
	${INSTALL_DATA} ${PLUGIN_SRC}/TWPythonPlugin/libTWPythonPlugin.so \
		${PREFIX}/lib/texworks/
	${INSTALL_DATA} ${PLUGIN_SRC}/TWLuaPlugin/libTWLuaPlugin.so \
		${PREFIX}/lib/texworks/

.include <bsd.port.mk>
