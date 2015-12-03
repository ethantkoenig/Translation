instance LexemeEng of Lexeme = open MorphEng, Prelude, TypesEng, Utils, UtilsEng in {
  oper
    {- LEXICAL FUNCTIONS -}
    {- Adjectives -}
    mkAdj : (happy : Str) -> Adj =
      \happy -> {s = happy};

    {- Nouns -}
    _constructN_ : (abstractOrMass : Bool) -> (gend : Gender) -> (dog, dogs : Str)
                   -> N_ = \abstractOrMass, gend, dog, dogs -> 
      {abstractOrMass = abstractOrMass; gend = gend;
       s = table {Sg => dog; Pl => dogs}};

    mkN_ = overload {
      {- nouns with regular plural forms, not abstract or mass, neuter -}
      mkN_ : (dog : Str) -> N_ = \dog ->
        _constructN_ False Neut dog (append_s dog);

      {- nouns with regular plural forms, neuter -}
      mkN_ : (abstractOrMass : Bool) -> (dog : Str) -> N_ = 
             \abstractOrMass, dog ->
        _constructN_ abstractOrMass Neut dog (append_s dog);

      {- nouns with regular plural forms -}
      mkN_ : (gend : Gender) -> (dog : Str) -> N_ = \gend, dog ->
        _constructN_ False gend dog (append_s dog);

      {- nouns with regular plural forms -}
      mkN_ : (abstractOrMass : Bool) -> (gend : Gender) -> (dog : Str) -> N_ =
             \abstractOrMass, gend, dog -> 
        _constructN_ abstractOrMass gend dog (append_s dog);

      {- nouns with irregular plural forms -}
      mkN_ : (abstractOrMass : Bool) -> (gend : Gender) 
             -> (man, men : Str) -> N_ = _constructN_;
    };

    mkProperN : (gend : Gender) -> (name : Str) -> ProperN = \gend, name -> 
      {gend = gend; null = False; num = Sg; person = Third; wh = False; 
       s = \\_, _, _, _ => name};

    _mkProNP : (num : Number) -> (person : Person) -> (gend : Gender)
               -> (he, him, his : Str) -> ProNP =
               \num, person, gend, he, him, his -> 
      {null = False; gend = gend; num = num; person = person; reflexive = False;
       s = table {Nom => \\_, _, _ => he;
                  Acc => \\_, _, _ => him;
                  Pos => \\_, _, _ => his}; wh = False};

    {- Prepositions -}
    mkP : Str -> P = \s -> {s = s};


    {- Verbs -}
    _constructV : (aux : Bool ) -> (be, being, been, am,
                                    are, is, was, were : Str) -> V =
                \aux, be, being, been, am, are, is, was, were ->
      {aux = aux;
       conj = table {Pres => table
                             {Sg => table
                                    {First => am;
                                     Second => are;
                                     Third => is};
                              Pl => table
                                    {First | Second | Third => are}};
                     Past => table
                             {Sg => table
                                    {First | Third => was;
                                     Second => were};
                              Pl => table
                                    {First | Second | Third => were}}};
       inf = be; presPart = being; pastPart = been};

    mkV = overload {
      mkV : (walk : Str) -> V = \walk -> 
        _constructV False walk (append_ing walk) (append_ed walk) walk walk 
                          (append_s walk) (append_ed walk) (append_ed walk); 
            
      mkV : (buy, bought : Str) -> V = \buy, bought -> 
        _constructV False buy (append_ing buy) bought buy buy (append_s buy)
                          bought bought;

      mkV : (take, taken, took : Str) -> V = \take, taken, took -> 
        _constructV False take (append_ing take) taken take take (append_s take)
                          took took;

      mkV : (be, being, been, am, are, is, was, were : Str) -> V = 
        _constructV False;
    };

    {- creates a modal, such as "will" or "would" -}
    _modal : Str -> V = \v -> _constructV True v v v v v v v v;


    {- LEXEMES -}
    {- Determiners -}
    indefinite : D = {s = \\_ => table {Sg => "a"; Pl => nonword}}; -- TODO a vs. an
    definite : D = {s = \\_, _ => "the"};
    voidD : D = {s = table {False => table {Sg => nonword; Pl => ""};
                            True => \\_ => ""}};


     {- fields other than s do not matter -}
    reflexive : Reflexive = 
      {null = False; gend = Masc; num = Sg; person = Third; wh = False;
       s = table {
             Acc => table {
               Sg => table {
                 First => \\_ => "myself";
                 Second => \\_ => "yourself";
                 Third => table {Masc => "himself"; Fem => "herself"; 
                                 Neut => "itself"}};
               Pl => table {
                 First => \\_ => "ourselves";
                 Second => \\_ => "yourselves";
                 Third => \\_ => "themselves"}};
            Nom | Pos => \\_, _, _ => nonword}};

    nullNP : NP = {gend = defaultGender; null = True; num = defaultNumber;
                   person = defaultPerson; wh = True;
                   s = table {
                         Pos => \\_, _, _ => "whose";
                         Nom | Acc => \\_, _, _ => "that"}};


    {- Pronouns -}
    i : ProNP = _mkProNP Sg First Masc "I" "me" "my";
    you : ProNP = _mkProNP Sg Second Masc "you" "you" "your";
    he : ProNP = _mkProNP Sg Third Masc "he" "him" "his";
    she : ProNP = _mkProNP Sg Third Fem "she" "her" "her";
    it : ProNP = _mkProNP Sg Third Neut "it" "it" "its";
    we : ProNP = _mkProNP Pl First Masc "we" "us" "our";
    yall : ProNP = _mkProNP Pl Second Masc "you" "you" "your";
    they : ProNP = _mkProNP Pl Third Masc "they" "them" "their";

    {- Verbs -}
    beVerb = _be;
    _be : V = _constructV True "be" "being" "been" "am" "are" "is" "was" "were";
    _do : V = _constructV True "do" "doing" "done" "do" "do" "does" "did" "did";
    _have : V = _constructV True "have" "having" "had" "have" "have" "has" "had" "had";
    _will : V = _modal "will";
    _would : V = _modal "would";

}
