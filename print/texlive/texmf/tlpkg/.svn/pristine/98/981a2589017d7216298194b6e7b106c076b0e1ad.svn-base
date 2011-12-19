
PNGS=gui-collections.png \
     gui-installer.png		\
     gui-lang.png		\
     gui-scheme.png		\
     gui-systems.png		\
     tlmgrgui-arch.png		\
     tlmgrgui-install.png	\
     tlmgrgui-options.png	\
     tlmgrgui-remove.png	\
     tlmgrgui-update.png	\
     psview.png

TEXSRC=tlmgr-article.tex	\
       install08text-crop.pdf	\
       $(PNGS)

TEXSRCDTK=tlmgr-dtk.tex		\
	tlmgr-dtk.ltx		\
	install08text-crop.pdf   \
	$(PNGS)

first: tlmgr-article.pdf

tlmgr-dtk.pdf: $(TEXSRCDTK) tlmgr-dtk.bbl
	pdflatex tlmgr-dtk.ltx
	pdflatex tlmgr-dtk.ltx
	pdflatex tlmgr-dtk.ltx
	
tlmgr-article.pdf: $(TEXSRC) tlmgr-article.bbl
	pdflatex tlmgr-article
	pdflatex tlmgr-article
	pdflatex tlmgr-article


tlmgr-article.bbl: tlmgr-article.aux tlmgr-article.bib
	bibtex tlmgr-article

tlmgr-dtk.bbl: tlmgr-dtk.aux tlmgr-article.bib
	bibtex tlmgr-dtk

tlmgr-article.aux: $(TEXSRC)
	pdflatex tlmgr-article

tlmgr-dtk.aux: $(TEXSRCDTK)
	pdflatex tlmgr-dtk.ltx

install08text-crop.pdf: install08text.pdf
	pdfcrop install08text.pdf

install08text.pdf: install08text.tex
	pdflatex install08text

clean:
	rm -f install08text-crop.pdf *~ *.{aux,log,bbl,blg,out}
	rm -f install08text.pdf

veryclean: clean
	rm -f *.pdf


