instance LexiconIta of Lexicon =
    open Concepts, Maybe, SyntaxIta, MorphIta {-- TODO don't want to open MorphIta here -} in {
  oper
    detLexicon = table {A => indDet; The => defDet};
    
    nounLexicon = table {
                    Boy => mkN_ Boy "ragazzo";
                    Hunger => mkN_ Hunger Fem "fame";
                    Name => mkN_ Name "name";
                    Student => mkN_ Student "studente"
                  };

    identity : ArgStructure => {v : Maybe V; args: ArgStructure} =
      \\a => {v = Nothing' V; args = a};

    verbLexicon = table {
                    Meet => mkV Meet Avere "incontrare" identity;
                    See => mkV See Avere "vedere" identity;
                    Sleep => mkV Sleep Avere "dormire" identity
                  };
}
