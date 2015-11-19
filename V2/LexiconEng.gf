instance LexiconEng of Lexicon = 
    open Concepts, SyntaxEng in {
  oper
    detLexicon = table {A => a; The => the};

    nounLexicon = table {
                    Boy => mkN_ "boy";
                    Hunger => mkN_ "hunger";
                    Name => mkN_ "name";
                    Student => mkN_ "student"
                  };

    verbLexicon = table {
                    Sleep => mkV "sleep" "slept";
                    See => mkV "see" "seeing" "seen" "see" "see" "sees" "saw" "saw";
                    Meet => mkV "meet" "met"
                  };
}
