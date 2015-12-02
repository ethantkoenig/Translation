instance LexemeIta of Lexeme = 
    open MorphIta, Prelude, TypesIta, Utils, UtilsIta in {
  oper
    {- LEXICAL FUNCTIONS -}
    {- Adjectives -}
    mkAdj : (rapido : Str) -> Adj =
      \rapido -> {s = adjectiveForms rapido};

    {- Nouns -}
    _constructN_ : (abstractOrMass : Bool) -> (gnd : Gender)
                   -> (uomo, uomini : Str) -> N_ =
      \abstractOrMass, gnd, uomo, uomini -> 
        {abstractOrMass = abstractOrMass; gend = gnd; init = nounInitial uomo;
         s = table {Sg => uomo; Pl => uomini}};

    mkN_ = overload {
      mkN_ : (gatto : Str) -> N_ =
        \gatto -> _constructN_ False (inferGender gatto) gatto (pluralize gatto);

      mkN_ : (abstractOrMass : Bool) -> (gatto : Str) -> N_ =
        \abstractOrMass, gatto -> _constructN_ abstractOrMass (inferGender gatto)
                                               gatto (pluralize gatto);

      mkN_ : (abstractOrMass : Bool) -> (gnd : Gender) -> (gatto : Str) -> N_ =
        \abstractOrMass, gnd, gatto -> _constructN_ abstractOrMass gnd gatto
                                                    (pluralize gatto);

      mkN_ : (abstractOrMass : Bool) -> (gnd : Gender) 
             -> (uomo, uomini : Str) -> N_ = _constructN_;
    };

    mkProperN : (gend : Gender) -> (name : Str) -> ProperN = \gend, name ->
      {gend = gend; null = False; num = Sg; person = Third;
       possessive = \\_, _ => nonword; pronoun = False; 
       s = \\_, _, _ => name; wh = False};

    _mkProNP : (gend : Gender) -> (num : Number) -> (person : Person)
               -> (lui, lo, egli, suo, sua, suoi, sue : Str) -> ProNP =
      \gend, num, person, lui, lo, egli, suo, sua, suoi, sue ->
        {gend = gend; null = False; num = num; person = person;
         possessive = table {Sg => table {Masc => suo; Fem => sua};
                             Pl => table {Masc => suoi; Fem => sue}};
         pronoun = True;
         s = table {Nom => \\_, _ => lui; Acc => \\_, _ => lo; 
                    Dis => \\_, _ => egli};
         wh = False};

    mkP : Str -> P = \s -> {s = s};


    {- Verbs -}
    _constructV : (aux : Aux) -> (avere, avendo, avuto : Str)
              -> (presConj : Number => Person => Str) -> (av : Str) -> V =
        \aux, avere, avendo, avuto, presConj, av ->
          let futConj : Number => Person => Str = futureConjugate av in
          let condConj : Number => Person => Str = condConjugate av in
          {aux = aux; 
           conj = table {Pres => presConj; Fut => futConj;
                         Cond => condConj; Past => \\_, _ => nonword};
           inf = avere; presPart = avendo; pastPart = pastParticiples avuto};

    mkV = overload {
      mkV : (aux : Aux) -> (mangiare : Str) -> V =
        \aux, mangiare -> let pres : Str = presParticiple mangiare in
                          let past : Str = pastParticiple mangiare in
                          let presConj : Number => Person => Str = presConjugate mangiare in
                          let stm : Str = stem mangiare in
                          _constructV aux mangiare pres past presConj stm;

      mkV : (aux : Aux) -> (prendere, preso : Str) -> V =
        \aux, prendere, preso ->
          let presPart : Str = presParticiple prendere in
          let presConj : Number => Person => Str = presConjugate prendere in
          let stm : Str = stem prendere in
          _constructV aux prendere presPart preso presConj stm;

      mkV : (aux : Aux) -> (avere, avendo, avuto, ho, hai,
                            ha, abbiamo, avete, hanno, av : Str) -> V =
        \aux, avere, avendo, avuto, ho, hai, ha, abbiamo, avete, hanno, av ->
          let presConj : Number => Person => Str =
            table {Sg => table {First => ho; Second => hai; Third => ha};
                   Pl => table {First => abbiamo; Second => avete; Third => hanno}} in
          _constructV aux avere avendo avuto presConj av;
    };

    {- LEXEMES -}

    {- Determiners -}
    definite : D = 
      {s = \\_ => table {
            Sg => table {
                    Masc => table {Con => "il"; Vow => "l'"; Complex => "lo"};
                    Fem => table {Con | Complex => "la"; Vow => "l'"}};
            Pl => table {
                    Masc => table {Con => "i"; Vow | Complex => "gli"};
                    Fem => table {_ => "le"}}}};

    indefinite : D = 
      {s = \\_ => table {
            Sg => table {
                    Masc => table {Con => "un"; Vow => "un'"; Complex => "uno"};
                    Fem => table {Con | Complex => "una"; Vow => "un'"}};
            Pl => \\_, _ => nonword}};

    voidD : D = 
      {s = table {
             False => table {Sg => \\_, _ => nonword; Pl => \\_, _ => ""};
             True => \\_, _, _ => ""}};

    {- Pronouns -}
    i : ProNP = _mkProNP Masc Sg First "" "mi" "me" "mio" "mia" "miei" "mie";
    you : ProNP = _mkProNP Masc Sg Second "" "ti" "te" "tuo" "tua" "tuoi" "tue";
    he : ProNP = _mkProNP Masc Sg Third "" "lo" "lui" "suo" "sua" "suoi" "sue";
    she : ProNP = _mkProNP Fem Sg Third "" "la" "lei" "suo" "sua" "suoi" "sue";
    we : ProNP = _mkProNP Masc Pl First "" "ci" "noi" "nostro" "nostra" "nostri" "nostre";
    yall : ProNP = _mkProNP Masc Pl Second "" "vi" "voi" "vostro" "vostra" "vostri" "vostre";
    they : ProNP = _mkProNP Masc Pl Third "" "li" "loro" "loro" "loro" "loro" "loro";

    reflexive : Reflexive =
      {gend = Masc; null = False; num = Sg; person = Third; 
       possessive = \\_, _ => nonword; pronoun = True; wh = False;
       s = table {
             Acc => table {
               Sg => table {First => "mi"; Second => "ti";
                            Third => "si"};
               Pl => table {First => "ci"; Second => "vi";
                            Third => "si"}};
             Dis => table {
               Sg => table {First => "me"; Second => "te";
                            Third => "se"};
               Pl => table {First => "noi"; Second => "voi";
                            Third => "se"}};
             Nom => \\_, _ => nonword}};

    {- setting pronoun = True makes nullNP act correctly in possessives -}
    nullNP : NP = {gend = defaultGender; null = True; num = defaultNumber; 
                   person = defaultPerson; possessive = \\_, _ => "cui";
                   pronoun = True; s = \\_, _, _ => "che"; wh = True};

    {- Verbs -}
    essere : V = mkV Essere "essere" "essendo" "stato" "sono" "sei" "e'"
                              "siamo" "siete" "sono" "sa";

    avere : V = mkV Avere "avere" "avendo" "avuto" "ho" "hai" "ha" "abbiamo"
                            "avete" "hanno" "av";

    stare : V = mkV Essere "stare" "stando" "stato" "sto" "stai" "sta" "stiamo"
                           "state" "stanno" "sta";
}
