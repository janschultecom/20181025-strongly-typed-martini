PANDOC=stack exec -- pandoc

HASKELLSRC=src/haskell
PUBLIC=public
REVEALJSURL=$(PUBLIC)/reveal.js

REVEAL=$(PANDOC)																\
			 --to=revealjs                          	\
	   	 --standalone                         		\
	   	 --output=$(PUBLIC)/index.html  					\

lhsObjects := $(wildcard $(HASKELLSRC)/*.md.lhs)

slides:
	$(REVEAL) $(lhsObjects)
