# Documentation For Developers

For a broad, high-level overview of the system, refer to the **Approach** and
**Progression** section of **report.pdf** in the base directory.

The source code is divided into three, largely independent directories:

+ **GF/**
+ **Haskell/**
+ **Test/**

## **GF/**

The **GF/** directory contains the functionality for the "text-and-tree"
components of the system. All of the code in contains is in Grammatical
Framework. All file paths in this section are relative to the **GF/** directory.

### Layout

Below are the key files in the **GF/** directory

+ **Grammar.gf**: interface that contains the types and grammatical rules for a language
+ **Lexicon.gf**: interface that defines the lexemes/words for a language
+ **Syntax.gf**: interface that defines the grammatical rules for a language
+ **Trans.gf**: defines the abstract syntax
+ **TransI.gf**: functor that defines a concrete syntax for a provided **Grammar** and **Lexicon**
+ **Types.gf**: interface that defines the constituent types for a language
+ **Utils.gf**: contains general-purpose types and functions

### Conventions

#### Auxiliary modules

In order to preserve as much homogeneity between language modules as possible,
all language modules should broken into the following components

+ **Grammar***Lang***.gf**: an instance of **Grammar.gf**
+ **Lexeme***Lang***.gf**: contains functions for constructing individual lexemes
+ **Lexicon***Lang***.gf**: an instance of **Lexicon.gf**
+ **Morph***Lang***.gf**: contains various morphological functions
+ **Syntax***Lang***.gf**: an instance of **Syntax.gf**
+ **Types***Lang***.gf**: an instance of **Types.gf**
+ **Utils***Lang***.gf**: contains any language-specific utilities (e.g. algebraic data type for case)

#### Types beginning with *Abs*

*Abs* at the beginning of a type denotes that the type is "abstract". These 
types only appear in **Trans.gf**, **Grammar.gf**, and **Lexicon.gf**, none of
which would normally need to be modified.

Abstract types are prepended with *Abs* to differentiate them from concrete
types, which are defined in **Types***Lang***.gf** files.

#### Types ending in "\_"

An underscore at the end of a type denotes that the type is "unsaturated".
For example, the type *AbsN_* is an unsaturated *AbsN*, since it has not been
assigned number.

#### Values beginning with "\_"

Values are prepended with an underscore if they should not be used outside of
the file in which they are defined.


## **Haskell/**

The **Haskell/** directory contains functionality for the "text-and-text" and 
"tree-and-tree" components of the system, as well as the command-line utility.

### Layout

The key files of the **Haskell/** directory are

+ **Translator.hs**: the entry point of the program, contains the *main* function
+ **Trans.hs**: a module generated by GF containing algebraic data types 
                corresponding to the abstract syntax defined in the **GF/**
                directory
+ **TransUtils.hs**: contains convenience functions for traversing abstract
                     syntax trees

### Conventions

Each language should have two corresponding Haskell files

#### **Text***Lang***.hs**

**Text***Lang***.hs** acts as the "text-and-text" component of a language 
module. It should contain the following functions

+ *tokenize :: String -> String*, which maps a raw string to its tokenized version
+ *untokenize :: String -> String*, which maps a tokenized string to its raw version

#### **Tree***Lang***.hs**

**Tree***Lang***.hs** acts as the "tree-and-tree" component of a language 
module. It should contain the following functions

+ *normalizeS :: GAbsS -> GAbsS*, which maps a language-specific abstract syntax tree to its corresponding interlingua-compliant form
+ *unnormalizeS :: GAbsS -> GAbsS*, which maps an interlingua-compliant abstract syntax tree to its corresponding language-specific form


## **Test/**

The **Test/** directory contains functionality for verification and evaluation
of the system. This boilerplate functionality is written in Python.

To see the results of the system on the evaluation test cases, look in the 
**Results/System** directory. Each file in that directory contains lines of the
form

    source | correct translations | system translation

