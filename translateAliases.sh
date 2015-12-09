#! /bin/bash

# Creates aliases for running the system

alias eng2ita='_eng2ita(){ echo $1 | '`pwd`'/Haskell/translate '`pwd`'/Haskell/Trans.pgf Eng Ita; }; _eng2ita'
alias ita2eng='_ita2eng(){ echo $1 | '`pwd`'/Haskell/translate '`pwd`'/Haskell/Trans.pgf Ita Eng; }; _ita2eng'

