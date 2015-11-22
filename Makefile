# Should only be run from its own directory

all: Trans. translate


Trans.: GF/TransEng.gf GF/TransIta.gf
	cd Haskell/ &&\
	gf --make --output-format=haskell ../GF/TransEng.gf ../GF/TransIta.gf > /dev/null &&\
	cd ..


translate: Haskell/Translator.hs
	cd Haskell/ &&\
	ghc --make -o translate Translator.hs &&\
	cd ..


clean:
	rm GF/*.gfo Haskell/*.hi Haskell/*.o Haskell/Trans.pgf Haskell/Trans.hs\
	   Haskell/translate 2> /dev/null
