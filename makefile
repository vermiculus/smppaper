TEX := xelatex
BIB := biber
GLS := makeglossaries

.PHONY : paper

paper:
	$(TEX) smp
	$(GLS) smp
	$(BIB) smp
	$(TEX) smp
	$(TEX) smp
	$(TEX) smp

clean:
	rm -f *.aux *.bbl *.bcf *.blg *.glg *.glo *.gls *.idx *.ilg *.ind *.log *.out *.run.xml *.toc *.xdv *.xdy *.lof *.lot *~
	cd sections && rm -f *.aux *~
