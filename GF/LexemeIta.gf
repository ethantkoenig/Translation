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
      {gend = gend; isPronoun = False; null = False; num = Sg; person = Third;
       possessive = \\_, _ => nonword; s = \\_, _, _ => name};

    _mkProNP : (gend : Gender) -> (num : Number) -> (person : Person)
               -> (lui, lo, gli, suo, sua, suoi, sue : Str) -> ProNP =
      \gend, num, person, lui, lo, gli, suo, sua, suoi, sue ->
        {gend = gend; isPronoun = True; null = False; num = num; person = person;
         possessive = table {Sg => table {Masc => suo; Fem => sua};
                             Pl => table {Masc => suoi; Fem => sue}};
         s = table {Nom => \\_, _ => lui; Acc => \\_, _ => lo; 
                    Dat => \\_, _ => gli}};

    {- Verbs -}
    _constructV : (aux : Aux) -> (avere, avendo, avuto : Str)
              -> (presConj : Number => Person => Str) -> (av : Str) -> V =
        \aux, avere, avendo, avuto, presConj, av ->
          let futConj : Number => Person => Str = futureConjugate av in
          let condConj : Number => Person => Str = condConjugate av in
          {aux = aux;
           inf = avere; presPart = avendo; pastPart = pastParticiples aux avuto;
           conj = table {Pres => presConj; Fut => futConj;
                         Cond => condConj; Past => \\_, _ => nonword}};

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
    i : ProNP = _mkProNP Masc Sg First "" "mi" "mi" "mio" "mia" "miei" "mie";
    you : ProNP = _mkProNP Masc Sg Second "" "ti" "ti" "tuo" "tua" "tuoi" "tue";
    he : ProNP = _mkProNP Masc Sg Third "" "lo" "gli" "suo" "sua" "suoi" "sue";
    she : ProNP = _mkProNP Fem Sg Third "" "la" "le" "suo" "sua" "suoi" "sue";
    we : ProNP = _mkProNP Masc Pl First "" "ci" "ci" "nostro" "nostra" "nostri" "nostre";
    yall : ProNP = _mkProNP Masc Pl Second "" "vi" "vi" "vostro" "vostra" "vostri" "vostre";
    they : ProNP = _mkProNP Masc Pl Third "" "li" "si" "loro" "loro" "loro" "loro";

    reflexive : Reflexive =
      {gend = Masc; null = False; num = Sg; person = Third; isPronoun = True;
       possessive = \\_, _ => nonword;
       s = table {
             Acc => table {
               Sg => table {First => "mi"; Second => "ti";
                            Third => "si"};
               Pl => table {First => "ci"; Second => "vi";
                            Third => "si"}};
             Nom | Dat => \\_, _ => nonword}};

    {- By setting isPronoun True, we avoid nullNP appearing in possessives -}
    nullNP : NP = {gend = defaultGender; isPronoun = True; null = True; 
                   num = defaultNumber; person = defaultPerson; 
                   possessive = \\_, _ => nonword; s = \\_, _, _ => ""}; -- TODO handle "di chi"


    {- Verbs -}
    essere : V = mkV Essere "essere" "essendo" "stato" "sono" "sei" "e'"
                              "siamo" "siete" "sono" "sa";

    avere : V = mkV Avere "avere" "avendo" "avuto" "ho" "hai" "ha" "abbiamo"
                            "avete" "hanno" "av";

    stare : V = mkV Essere "stare" "stando" "stato" "sto" "stai" "sta" "stiamo"
                           "state" "stanno" "sta";


}
