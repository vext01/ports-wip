# $OpenBSD: Makefile,v 1.21 2011/07/26 18:04:57 edd Exp $

COMMENT-main =		texlive texmf for laTeX/PdfTeX 
COMMENT-full =		texlive texmf for XeTeX/ConTeXt and extra macros
COMMENT-docs =		texlive documentation

DISTNAME =		texlive-${DIST_V}-texmf
MASTER_SITES0 =		http://spacehopper.org/mirrors/ \
			http://theunixzoo.co.uk/distfiles/
#DISTFILES =		${DISTNAME}${EXTRACT_SUFX} \
#			texmf-var-pregen-2010.1${EXTRACT_SUFX}:0

PKGNAME-main = 		texlive_texmf-minimal-${V}
PKGNAME-full = 		texlive_texmf-full-${V}
PKGNAME-docs =	 	texlive_texmf-docs-${V}

NO_BUILD =		Yes
NO_REGRESS =		Yes
PKG_ARCH =		*

BUILD_DEPENDS =		archivers/xz
RUN_DEPENDS-full =	texlive_texmf-minimal-${V}:print/texlive/texmf,-main \
			texlive_base-${V}:print/texlive/base
RUN_DEPENDS-docs = 	texlive_base-${V}:print/texlive/base \
			x11/p5-Tk

MULTI_PACKAGES = 	-main -full -docs

SUBST_VARS +=		LOCALBASE

do-install:
	chown -R ${SHAREOWN}:${SHAREGRP} ${WRKDIST}
	# manuals in the right place
	mv ${WRKDIST}/texmf/doc/man/man1/*.1 ${PREFIX}/man/man1/
	mv ${WRKDIST}/texmf/doc/man/man5/*.5 ${PREFIX}/man/man5/
	# XXX search for scattered manuals, there are some.
	# The rest go in share/texmf*
	mv ${WRKDIST}/texmf ${PREFIX}/share
	mv ${WRKDIST}/texmf-dist ${PREFIX}/share
# plug in my pregenerated map and formats
#	mv ${WRKDIR}/texmf-var ${PREFIX}/share

post-install:
	${SUBST_CMD} ${PREFIX}/share/texmf/web2c/texmf.cnf

.include <bsd.port.mk>
