all: Trans. translate


Trans.: TransEng.gf TransIta.gf
	gf --make --output-format=haskell TransEng.gf TransIta.gf


translate: Translator.hs
	ghc --make -o translate Translator.hs

clean:
	rm *.gfo *.hi *.o Trans.pgf Trans.hs translate 2> /dev/null
