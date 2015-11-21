instance SyntaxIta of Syntax = 
    open Maybe, MorphIta, Prelude, Utils, UtilsIta in {
  param
    Tense = Pres | Past | Fut | Cond;
    Case = Nom | Acc | Dat | Ref;
  oper
    {- TYPES -}
    Adj : Type = {s : Number => Gender => Str};

    D : Type = {s : Number => Gender => NounInitial => Str};

    N_ : Type = {gend : Gender; init : NounInitial ; s : Number => Str};
    N : Type = N';
    N' : Type = {gend : Gender; num : Number; init : NounInitial; s : Str};
    ProNP : Type = NP;
    NP : Type = {gend : Gender; num : Number; person : Person; 
                 s : Case => Str; possessive : Maybe (Number => Gender => Str)};

    V : Type = {aux : Aux; inf : Str; presPart : Str;
                pastPart : Number => Gender => Str;
                conj : Tense => Number => Person => Str};
    V' : Type = {head : V; prefix : Str; gend : Gender; num : Number; 
                 person : Person; suffix : Str};
    VP__ : Type = V';
    VP_ : Type = {tense : Tense; head : V; prefix : Str; gend : Gender;
                  num : Number; person : Person; suffix : Str};
    VP : Type = {s : Str}; 

    ArgStructure : Type = {subj : NP; np1 : Str; adj1 : Str};

    {- ARGUMENT FUNCTIONS -}
    mkArgVoid : NP -> ArgStructure = 
      \sb -> {subj = sb; np1 = ""; adj1 = ""};

    mkArgNP : NP -> NP -> ArgStructure =
      \sb, np -> {subj = sb; np1 = np.s ! Acc; adj1 = ""};

    mkArgAdj : NP -> Adj -> ArgStructure = 
      \sb, ad -> {subj = sb; np1 = ""; adj1 = ad.s ! sb.num ! sb.gend};
    
    {- LEXICAL FUNCTIONS -}
      {- NOUNS -}
    _constructN_ : (gnd : Gender) -> (uomo, uomini : Str) -> N_ =
      \gnd, uomo, uomini -> {gend = gnd; init = nounInitial uomo;
                             s = table {Sg => uomo; Pl => uomini}};

    mkN_ = overload {
      mkN_ : (gatto : Str) -> N_ =
        \gatto -> _constructN_ (inferGender gatto) gatto (pluralize gatto);

      mkN_ : (gnd : Gender) -> (gatto : Str) -> N_ =
        \gnd, gatto -> _constructN_ gnd gatto (pluralize gatto);

      mkN_ : (gnd : Gender) -> (uomo, uomini : Str) -> N_ = _constructN_;
    };

    _mkProNP : (gend : Gender) -> (num : Number) -> (person : Person)
               -> (lui, lo, gli, si, suo, sua, suoi, sue : Str) -> ProNP =
      \gend, num, person, lui, lo, gli, si, suo, sua, suoi, sue ->
        {gend = gend; num = num; person = person; isPronoun = True;
         s = table {Nom => lui; Acc => lo; Dat => gli; Ref => si};
         possessive = Just (Number => Gender => Str) 
                          (table {Sg => table {Masc => suo; Fem => sua};
                                 Pl => table {Masc => suoi; Fem => sue}})};
        

      {- VERBS -}
    _constructV : (aux : Aux) -> (avere, avendo, avuto : Str)
              -> (presConj : Number => Person => Str) -> (av : Str) -> V =
        \aux, avere, avendo, avuto, presConj, av ->
          let futConj : Number => Person => Str = futureConjugate av in
          let condConj : Number => Person => Str = condConjugate av in
          {aux = aux;
           inf = avere; presPart = avendo; pastPart = pastParticiples aux avuto;
           conj = table {Pres => presConj; Fut => futConj;
                         Cond => condConj; Past => \\_, _ => ""}};

    mkV = overload {
      mkV : (aux : Aux) -> (mangiare : Str) -> V =
        \aux, mangiare -> let pres : Str = presParticiple mangiare in
                        let past : Str = pastParticiple mangiare in
                        let presConj : Number => Person => Str = presConjugate mangiare in
                        let stm : Str = stem mangiare in
                        _constructV aux mangiare pres past presConj stm;

      mkV : (aux : Aux) -> (avere, avendo, avuto, ho, hai, 
                            ha, abbiamo, avete, hanno, av : Str) -> V =
        \aux, avere, avendo, avuto, ho, hai, ha, abbiamo, avete, hanno, av ->
          let presConj : Number => Person => Str =
            table {Sg => table {First => ho; Second => hai; Third => ha};
                   Pl => table {First => abbiamo; Second => avete; Third => hanno}} in
          _constructV aux avere avendo avuto presConj av;
    };


    mkAdj : (rapido : Str) -> Adj = 
      \rapido -> {s = adjectiveForms rapido};


    {- FEATURE FUNCTIONS -}


    {-
    nonreflexive : ProNP -> NP = \pr -> pr;

    reflexive : ProNP -> NP =
      \pr -> {gend = pr.gend; num = pr.num; person = pr.person; 
              s = table {Nom => nonword; Acc => pr.s ! Ref; c => pr.s ! c}};
    -}    

    singular : N_ -> N =
      \gatto -> {gend = gatto.gend; init = gatto.init; 
                 num = Sg; s = gatto.s ! Sg};

    plural : N_ -> N =
      \gatto -> {gend = gatto.gend; init = gatto.init;
                 num = Pl; s = gatto.s ! Pl};

    present : VP__ -> VP_ =
      \vp -> {tense = Pres; prefix = vp.prefix; gend = vp.gend; num = vp.num;
              person = vp.person; head = vp.head; suffix = vp.suffix};
    
    past : VP__ -> VP_ =
      \vp -> {tense = Pres; prefix = vp.prefix; gend = vp.gend; num = vp.num;
              person = vp.person;
              head = case vp.head.aux of {Avere => avere; Essere => essere}; 
              suffix = vp.head.pastPart ! vp.num ! vp.gend ++ vp.suffix};

    future : VP__ -> VP_ = 
      \vp -> {tense = Fut; prefix = vp.prefix; gend = vp.gend; num = vp.num; 
              person = vp.person; head = vp.head; suffix = vp.suffix};

    cond : VP__ -> VP_ =
      \vp -> {tense = Cond; prefix = vp.prefix; gend = vp.gend; num = vp.num;
              person = vp.person; head = vp.head; suffix = vp.suffix};

    positive : VP_ -> VP =
      \vp -> {s = vp.prefix ++ vp.head.conj ! vp.tense ! vp.num ! vp.person
                  ++ vp.suffix};

    negative : VP_ -> VP =
      \vp -> {s = vp.prefix ++ "non" ++ vp.head.conj ! vp.tense ! vp.num ! vp.person
                  ++ vp.suffix};

    {- GRAMMATICAL FUNCTIONS -}
    mkN' : N -> N' = \n -> n;

    -- TODO handle preceding adjectives
    adjN' : N' -> Adj -> N' =
      \n, a -> {gend = n.gend; init = n.init; num = n.num;
                s = n.s ++ a.s ! n.num ! n.gend};

    mkNP : D -> N' -> NP =
      \il, gatto -> {gend = gatto.gend; num = gatto.num; person = Third;
                     s = \\_ => (il.s ! gatto.num ! gatto.gend ! gatto.init) ++ gatto.s;
                     possessive = Nothing (Number => Gender => Str) (\\_, _ => "")};

    npOfProNP : ProNP -> NP = \pronp -> pronp;

    possessive : NP -> N' -> NP =
      \owner, ownee -> 
        {gend = ownee.gend; num = ownee.num; person = Third;
         s = case isJust (Number => Gender => Str) owner.possessive of {
               False => \\c => (definite.s ! ownee.num ! ownee.gend ! ownee.init)
                               ++ ownee.s ++ "di" ++ owner.s ! c;
               True => let poss : Number => Gender => Str =
                         fromJust (Number => Gender => Str) owner.possessive in
                       \\c => (definite.s ! ownee.num ! ownee.gend ! Con)
                              ++ (poss ! ownee.num ! ownee.gend) ++ ownee.s
             };
         possessive = Nothing (Number => Gender => Str) (\\_, _ => "")};

    mkV' : V -> ArgStructure -> V' =
      \v, args -> let subj : NP = args.subj in
                  {head = v; prefix = subj.s ! Nom; gend = subj.gend;
                   num = subj.num; person = subj.person;
                   suffix = args.np1 ++ args.adj1};

    auxBe : VP__ -> V' =
      \vp -> {head = stare; prefix = vp.prefix; gend = vp.gend; num = vp.num;
              person = vp.person; suffix = vp.head.presPart ++ vp.suffix}; 

    auxHave : VP__ -> V' =
      \vp -> {head = case vp.head.aux of {Avere => avere; Essere => essere};
              prefix = vp.prefix; gend = vp.gend; num = vp.num; person = vp.person;
              suffix = vp.head.pastPart ! vp.num ! vp.gend ++ vp.suffix};

    mkVP__ : V' -> VP__ = \v' -> v';

    {- FUNCTIONAL WORDS -}

    definite : D = {s = table {
                        Sg => table {
                                Masc => table {Con => "il"; Vow => "l'"; Complex => "lo"};
                                Fem => table {Con | Complex => "la"; Vow => "l'"}};
                        Pl => table {
                                Masc => table {Con => "i"; Vow | Complex => "gli"};
                                Fem => table {_ => "le"}}}};

    indefinite : D = {s = table {
                        Sg => table {
                                Masc => table {Con => "un"; Vow => "un'"; Complex => "uno"};
                                Fem => table {Con | Complex => "una"; Vow => "un'"}};
                        Pl => table { -- TODO plural indefinite case
                                Masc => table {Con => "dei"; Vow | Complex => "degli"};
                                Fem => table {_ => "delle"}}}};

    voidD : D = {s = \\_, _, _ => ""};

    i : ProNP = _mkProNP Masc Sg First "" "mi" "mi" "mi" "mio" "mia" "miei" "mie"; 
    you : ProNP = _mkProNP Masc Sg Second "" "ti" "ti" "ti" "tuo" "tua" "tuoi" "tue";
    he : ProNP = _mkProNP Masc Sg Third "" "lo" "gli" "si" "suo" "sua" "suoi" "sue";
    she : ProNP = _mkProNP Fem Sg Third "" "la" "le" "si" "suo" "sua" "suoi" "sue";
    we : ProNP = _mkProNP Masc Pl First "" "ci" "ci" "ci" "nostro" "nostra" "nostri" "nostre"; 
    yall : ProNP = _mkProNP Masc Pl Second "" "vi" "vi" "vi" "vostro" "vostra" "vostri" "vostre"; 
    they : ProNP = _mkProNP Masc Pl Third "" "li" "loro" "si" "loro" "loro" "loro" "loro";
  
    essere : V = mkV Essere "essere" "essendo" "stato" "sono" "sei" "e'" 
                              "siamo" "siete" "sono" "sa";

    avere : V = mkV Avere "avere" "avendo" "avuto" "ho" "hai" "ha" "abbiamo"
                            "avete" "hanno" "av";

    stare : V = mkV Essere "stare" "stando" "stato" "sto" "stai" "sta" "stiamo"
                           "state" "stanno" "sta";

}   
