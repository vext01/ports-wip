# $OpenBSD: Makefile,v 1.11 2012/03/29 13:38:30 sthen Exp $

BROKEN-powerpc =	qdoc3 goes into an infinite loop

COMMENT =		cross-platform IDE for use with Qt

V = 			2.5.0
DISTNAME =		qt-creator-${V}-src
PKGNAME =		qt-creator-${V}
EXTRACT_SUFX = 		.zip
ONLY_FOR_ARCHS =	${GCC4_ARCHS}

SHARED_LIBS =		Aggregation 1.0 \
			Botan 0.0 \
			CPlusPlus 1.0 \
			DebuggingHelper 1.0 \
			ExtensionSystem 1.0 \
			GLSL 0.0 \
			LanguageUtils 0.0 \
			QmlEditorWidgets 0.0 \
			QmlJS 0.0 \
			QmlJSDebugClient 0.0 \
			symbianutils 0.0 \
			Utils 1.0 \
			zeroconf 0.0

MAKE_FLAGS += 	LIBAggregation_VERSION=${LIBAggregation_VERSION} \
		LIBCPlusPlus_VERSION=${LIBCPlusPlus_VERSION} \
		LIBDebuggingHelper_VERSION=${LIBDebuggingHelper_VERSION} \
		LIBExtensionSystem_VERSION=${LIBExtensionSystem_VERSION} \
		LIBQtConcurrent_VERSION=${LIBQtConcurrent_VERSION} \
		LIBUtils_VERSION=${LIBUtils_VERSION} \
		LIBBotan_VERSION=${LIBBotan_VERSION} \
		LIBGLSL_VERSION=${LIBGLSL_VERSION} \
		LIBLanguageUtils_VERSION=${LIBLanguageUtils_VERSION} \
		LIBQmlEditorWidgets_VERSION=${LIBQmlEditorWidgets_VERSION} \
		LIBQmlJS_VERSION=${LIBQmlJS_VERSION} \
		LIBQmlJSDebugClient_VERSION=${LIBQmlJSDebugClient_VERSION} \
		LIBsymbianutils_VERSION=${LIBsymbianutils_VERSION} \
		LIBzeroconf_VERSION=${LIBzeroconf_VERSION}

CATEGORIES =		devel editors

HOMEPAGE =		http://qt.nokia.com/products/appdev/developer-tools/developer-tools

# LGPL 2.1 with C++ headers exception (more permissive than LGPL)
PERMIT_PACKAGE_CDROM =	Yes
PERMIT_PACKAGE_FTP =	Yes
PERMIT_DISTFILES_CDROM =Yes
PERMIT_DISTFILES_FTP =	Yes

WANTLIB += ICE QtDeclarative QtDesigner QtDesignerComponents QtGui
WANTLIB += QtHelp QtNetwork QtScript QtSql QtSvg QtWebKit QtXml
WANTLIB += QtXmlPatterns SM X11 Xext Xi Xinerama Xrender c fontconfig
WANTLIB += freetype m pthread stdc++

MASTER_SITES =	http://get.qt.nokia.com/qtcreator/

MODULES =	x11/qt4

BUILD_DEPENDS = x11/qt4,-sqlite
RUN_DEPENDS = 	x11/qt4,-sqlite devel/gmake

PORTHOME =		${WRKDIR}

SEPARATE_BUILD =	Yes

ALL_TARGET = 		all qch_docs

#NO_REGRESS =		Yes

FAKE_FLAGS =		INSTALL_ROOT=${WRKINST}${TRUEPREFIX}

pre-configure:
	mkdir -p ${WRKDIR}/bin/tools/qdoc3
	mkdir -p ${WRKDIR}/bin/bin
	ln -sf ${PREFIX}/lib/qt4/bin/qdoc3 ${WRKDIR}/bin/tools/qdoc3
	ln -sf ${PREFIX}/lib/qt4/bin/qhelpgenerator ${WRKDIR}/bin/bin

do-configure:
	cd ${WRKBUILD} && QTDIR=${WRKDIR}/bin qmake4 ${WRKSRC}/qtcreator.pro #CONFIG+=debug

.include <bsd.port.mk>
