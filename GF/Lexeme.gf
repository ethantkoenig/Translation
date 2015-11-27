{- In addition to definitions for the below function word, a Lexeme instance
 - will also provide functions for constructing open terminal-level types, such
 - as Adj, N_ and V. However, since the types of these constructors will vary
 - from langauge to language, they are omitted from the interface -}
interface Lexeme = open Types in {
  oper
    definite, indefinite, voidD : D;

    nullNP : NP;

    i, you, he, she, we, yall, they : ProNP;

    reflexive : Reflexive;
}
