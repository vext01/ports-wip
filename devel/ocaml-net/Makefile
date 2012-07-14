# $OpenBSD$

COMMENT =	Ocamlnet: foundation library focused on internet protocols
CATEGORIES =	devel www mail

V =		3.5.1
DISTNAME =	ocamlnet-${V}
PKGNAME =	ocaml-net-${V}

MASTER_SITES =	http://download.camlcity.org/download/
HOMEPAGE =	http://projects.camlcity.org/projects/ocamlnet.html

MAINTAINER =	Christopher Zimmermann <madroach@zakweb.de>

# Mostly zlib/png, http server module is GPL
PERMIT_PACKAGE_FTP =		Yes
PERMIT_PACKAGE_CDROM =		Yes
PERMIT_DISTFILES_FTP =		Yes
PERMIT_DISTFILES_CDROM =	Yes

MODULES =	lang/ocaml

RUN_DEPENDS =	devel/ocaml-pcre
BUILD_DEPENDS =	${RUN_DEPENDS} sysutils/findlib
LIB_DEPENDS =	devel/pcre
WANTLIB =	c curses m pthread pcre

CONFIGURE_STYLE = simple
CONFIGURE_ARGS = -with-nethttpd

NO_REGRESS =	Yes
USE_GMAKE =	Yes

ALL_TARGET =	all ${MODOCAML_NATIVE:S/Yes/opt/:S/No//}

pre-fake:
	${INSTALL_DATA_DIR} ${PREFIX}/lib/ocaml/site-lib
	${INSTALL_DATA_DIR} ${PREFIX}/lib/ocaml/stublibs
	# trick ocamlfind into installing shared objects into
	# /usr/local/lib/ocaml/ld.conf registered directory
	ln -s ../stublibs ${PREFIX}/lib/ocaml/site-lib/

post-install:
	${INSTALL_DATA_DIR} ${PREFIX}/share/doc/ocamlnet/html
	${INSTALL_DATA} ${WRKSRC}/LICENSE ${PREFIX}/share/doc/ocamlnet/
	${INSTALL_DATA} ${WRKSRC}/ChangeLog ${PREFIX}/share/doc/ocamlnet/
	${INSTALL_DATA} \
	    ${WRKSRC}/doc/html-main/* \
	    ${PREFIX}/share/doc/ocamlnet/html/

.include <bsd.port.mk>
