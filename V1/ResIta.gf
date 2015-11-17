resource ResIta = open MorphIta in {
  param
    Polarity = Pos | Neg;
    Tense = Pres | Past | Fut | Cond;
  oper
    {- TYPES -}
    N_ : Type = {g : Gender; i : NounInitial ; s : Number => Str};
    N : Type = {g : Gender; n : Number; i : NounInitial; s : Str};
    N' : Type = {g : Gender; n : Number; i : NounInitial; s : Str};
    NP : Type = {g : Gender; n : Number; p : Person; s : Str};

    D : Type = {s : Number => Gender => NounInitial => Str};

    V : Type = {aux : Aux; inf : Str; presPart : Str;
                pastPart : Number => Gender => Str;
                conj : Tense => Number => Person => Str};
    V' : Type = {head : V; suffix : Number => Gender => Str};
    VP__ : Type = V';
    VP_ : Type = {t : Tense; head : V; suffix : Number => Gender => Str};
    VP : Type = {p : Polarity; t : Tense; prefix : Str;
                 s : Number => Person => Str; suffix : Number => Gender => Str}; 

    ArgStructure = {np1 : Str}; -- TODO incomplete

    S : Type = {s : Str};

    {- ARGUMENT FUNCTIONS -}
    mkArg_ : ArgStructure = {np1 = ""};
    mkArg_NP : NP -> ArgStructure =
      \np -> {np1 = np.s};

    
    {- LEXICAL FUNCTIONS -}
      {- NOUNS -}
    _constructN_ : (gnd : Gender) -> (uomo, uomini : Str) -> N_ =
      \gnd, uomo, uomini -> {g = gnd; i = nounInitial uomo;
                             s = table {Sg => uomo; Pl => uomini}};

    mkN_ = overload {
      mkN_ : (gatto : Str) -> N_ =
        \gatto -> _constructN_ (inferGender gatto) gatto (pluralize gatto);

      mkN_ : (gnd : Gender) -> (gatto : Str) -> N_ =
        \gnd, gatto -> _constructN_ gnd gatto (pluralize gatto);

      mkN_ : (gnd : Gender) -> (uomo, uomini : Str) -> N_ = _constructN_;
    };

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


    {- FEATURE FUNCTIONS -}

    singular : N_ -> N =
      \gatto -> {g = gatto.g; i = gatto.i; n = Sg; s = gatto.s ! Sg};

    plural : N_ -> N =
      \gatto -> {g = gatto.g; i = gatto.i; n = Pl; s = gatto.s ! Pl};

    present : VP__ -> VP_ =
      \vp -> {t = Pres; head = vp.head; suffix = vp.suffix};
    
    past : VP__ -> VP_ =
      \vp -> {t = Pres; head = case vp.head.aux of {Avere => avere;
                                                    Essere => essere}; 
              suffix = \\n, g => vp.head.pastPart ! n ! g ++ vp.suffix ! n ! g};

    future : VP__ -> VP_ = 
      \vp -> {t = Fut; head = vp.head; suffix = vp.suffix};

    cond : VP__ -> VP_ =
      \vp -> {t = Cond; head = vp.head; suffix = vp.suffix};

    positive : VP_ -> VP =
      \vp -> {p = Pos; t = vp.t; prefix = ""; s = vp.head.conj ! vp.t;
              suffix = vp.suffix};

    negative : VP_ -> VP =
      \vp -> {p = Neg; t = vp.t; prefix = "non"; s = vp.head.conj ! vp.t;
              suffix = vp.suffix};

    {- GRAMMATICAL FUNCTIONS -}
    mkN' : N -> N' = \n -> n;

    mkNP : D -> N' -> NP =
      \il, gatto -> {g = gatto.g; n = gatto.n; p = Third;
                     s = (il.s ! gatto.n ! gatto.g ! gatto.i) ++ gatto.s};

    mkV' : V -> ArgStructure -> V' =
      \v, args -> {head = v; suffix = \\_, _ => args.np1};

    auxBe : VP__ -> V' =
      \vp -> {head = stare; suffix = \\n, g => vp.head.presPart ++ vp.suffix ! n ! g}; 

    auxHave : VP__ -> V' =
      \vp -> {head = case vp.head.aux of {Avere => avere; Essere => essere};
              suffix = \\n, g => vp.head.pastPart ! n ! g ++ vp.suffix ! n ! g};

    mkVP__ : V' -> VP__ = \v' -> v';

    mkS : NP -> VP -> S = 
      \np, vp -> {s = np.s ++ vp.prefix ++ vp.s ! np.n ! np.p ++ vp.suffix ! np.n ! np.g};

    {- FUNCTIONAL WORDS -}

    defDet : D = {s = table {
                        Sg => table {
                                Masc => table {Con => "il"; Vow => "l'"; Complex => "lo"};
                                Fem => table {Con | Complex => "la"; Vow => "l'"}};
                        Pl => table {
                                Masc => table {Con => "i"; Vow | Complex => "gli"};
                                Fem => table {_ => "le"}}}};

    indDet : D = {s = table {
                        Sg => table {
                                Masc => table {Con => "un"; Vow => "un'"; Complex => "uno"};
                                Fem => table {Con | Complex => "una"; Vow => "un'"}};
                        Pl => table {
                                Masc => table {Con => "dei"; Vow | Complex => "degli"};
                                Fem => table {_ => "delle"}}}};

  
    essere : V = mkV Essere "essere" "essendo" "stato" "sono" "sei" "e'" 
                              "siamo" "siete" "sono" "sa";

    avere : V = mkV Avere "avere" "avendo" "avuto" "ho" "hai" "ha" "abbiamo"
                            "avete" "hanno" "av";

    stare : V = mkV Essere "stare" "stando" "stato" "sto" "stai" "sta" "stiamo"
                           "state" "stanno" "sta";

}   
