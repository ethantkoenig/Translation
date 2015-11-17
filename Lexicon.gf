interface Lexicon = open Concepts, Syntax in {
  oper
    detLexicon : DetConcept => D;
    nounLexicon : NounConcept => N_;
    -- adjLexicon : AdjConcept => Adj;
    verbLexicon : VerbConcept => V;
}
