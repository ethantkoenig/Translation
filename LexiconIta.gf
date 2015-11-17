instance LexiconIta of Lexicon =
    open Concepts, SyntaxIta, MorphIta {-- TODO don't want to open MorphIta here -} in {
  oper
    detLexicon = table {A => indDet; The => defDet};
    
    nounLexicon = table {
                    Boy => mkN_ "ragazzo";
                    Hunger => mkN_ Fem "fame";
                    Name => mkN_ "name";
                    Student => mkN_ "studente"
                  };

    verbLexicon = table {
                    Sleep => mkV Avere "dormire";
                    See => mkV Avere "vedere";
                    Meet => mkV Avere "incontrare"
                  };
}
