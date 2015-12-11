# Overview

This is a machine translation system that translates between subsets of English
and Italian using an interlingua-based approach.

## Compilation

To compile the system, simply run

    $ make

from the base directory. Required dependencies: `gf`, `ghc`

To undo compilation, run

    $ make clean

from the base directory.

## Running

To run the system, first run

    $ source translateAliases.sh

from the base directory. Then to translate from English to Italian, run

    $ eng2ita "your sentence in quotes"

from any directory. Similarly, to translate from Italian to English, run

    $ ita2eng "la tua frase tra virgolette"

from any directory.

Note that `source translateAliases.sh` must be run before `eng2ita` or `ita2eng`
can be used for each new terminal session. This is in contrast with `make`,
which only needs to be run once.

## Documentation

Documentation of the system, including what linguistic constructions the system
does and does not support, can be found in the Documentation/ directory.
