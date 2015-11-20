instance SyntaxIta of Syntax = 
    open MorphIta, Utils, UtilsIta in {
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
    V' : Type = {head : V; prefix : Str; g : Gender; n : Number; 
                 p : Person; suffix : Str};
    VP__ : Type = V';
    VP_ : Type = {t : Tense; head : V; prefix : Str; g : Gender; n : Number; 
                  p : Person; suffix : Str};
    VP : Type = {s : Str}; 

    Adj : Type = {s : Number => Gender => Str};

    ArgStructure : Type = {subj : Str; g : Gender; n : Number; 
                           p : Person; np1 : Str; adj1 : Str};

    {- ARGUMENT FUNCTIONS -}
    mkArgVoid : NP -> ArgStructure = 
      \sb -> {subj = sb.s; g = sb.g; n = sb.n; p = sb.p; np1 = ""; adj1 = ""};

    mkArgNP : NP -> NP -> ArgStructure =
      \sb, np -> {subj = sb.s; g = sb.g; n = sb.n; p = sb.p; np1 = np.s; adj1 = ""};

    mkArgAdj : NP -> Adj -> ArgStructure = 
      \sb, ad -> {subj = sb.s; g = sb.g; n = sb.n;
                  p = sb.p; np1 = ""; adj1 = ad.s ! sb.n ! sb.g};
    
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


    mkAdj : (rapido : Str) -> Adj = 
      \rapido -> {s = adjectiveForms rapido};


    {- FEATURE FUNCTIONS -}

    singular : N_ -> N =
      \gatto -> {g = gatto.g; i = gatto.i; n = Sg; s = gatto.s ! Sg};

    plural : N_ -> N =
      \gatto -> {g = gatto.g; i = gatto.i; n = Pl; s = gatto.s ! Pl};

    present : VP__ -> VP_ =
      \vp -> {t = Pres; prefix = vp.prefix; g = vp.g; n = vp.n; p = vp.p;
              head = vp.head; suffix = vp.suffix};
    
    past : VP__ -> VP_ =
      \vp -> {t = Pres; prefix = vp.prefix; g = vp.g; n = vp.n; p = vp.p;
              head = case vp.head.aux of {Avere => avere; Essere => essere}; 
              suffix = vp.head.pastPart ! vp.n ! vp.g ++ vp.suffix};

    future : VP__ -> VP_ = 
      \vp -> {t = Fut; prefix = vp.prefix; g = vp.g; n = vp.n; p = vp.p;
              head = vp.head; suffix = vp.suffix};

    cond : VP__ -> VP_ =
      \vp -> {t = Cond; prefix = vp.prefix; g = vp.g; n = vp.n; p = vp.p; 
              head = vp.head; suffix = vp.suffix};

    positive : VP_ -> VP =
      \vp -> {s = vp.prefix ++ vp.head.conj ! vp.t ! vp.n ! vp.p ++ vp.suffix};

    negative : VP_ -> VP =
      \vp -> {s = vp.prefix ++ "non" ++ vp.head.conj ! vp.t ! vp.n ! vp.p ++ vp.suffix};

    {- GRAMMATICAL FUNCTIONS -}
    mkN' : N -> N' = \n -> n;

    -- TODO handle preceding adjectives
    adjN' : N' -> Adj -> N' =
      \n, a -> {g = n.g; i = n.i; n = n.n; s = n.s ++ a.s ! n.n ! n.g};

    mkNP : D -> N' -> NP =
      \il, gatto -> {g = gatto.g; n = gatto.n; p = Third;
                     s = (il.s ! gatto.n ! gatto.g ! gatto.i) ++ gatto.s};

    mkV' : V -> ArgStructure -> V' =
      \v, args -> {head = v; prefix = args.subj; g = args.g; n = args.n;
                   p = args.p; suffix = args.np1 ++ args.adj1};

    auxBe : VP__ -> V' =
      \vp -> {head = stare; prefix = vp.prefix; g = vp.g; n = vp.n; p = vp.p;
              suffix = vp.head.presPart ++ vp.suffix}; 

    auxHave : VP__ -> V' =
      \vp -> {head = case vp.head.aux of {Avere => avere; Essere => essere};
              prefix = vp.prefix; g = vp.g; n = vp.n; p = vp.p;
              suffix = vp.head.pastPart ! vp.n ! vp.g ++ vp.suffix};

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
                        Pl => table {
                                Masc => table {Con => "dei"; Vow | Complex => "degli"};
                                Fem => table {_ => "delle"}}}};

    voidD : D = {s = \\_, _, _ => ""};


    i : NP = {g = Masc; n = Sg; p = First; s = ""};
    you : NP = {g = Masc; n = Sg; p = Second; s = ""};
    he : NP = {g = Masc; n = Sg; p = Third; s = ""};
    she : NP = {g = Fem; n = Sg; p = Third; s = ""};
    we : NP = {g = Masc; n = Pl; p = First; s = ""};
    yall : NP = {g = Masc; n = Pl; p = Second; s = ""};
    they : NP = {g = Masc; n = Pl; p = Third; s = ""};

  
    essere : V = mkV Essere "essere" "essendo" "stato" "sono" "sei" "e'" 
                              "siamo" "siete" "sono" "sa";

    avere : V = mkV Avere "avere" "avendo" "avuto" "ho" "hai" "ha" "abbiamo"
                            "avete" "hanno" "av";

    stare : V = mkV Essere "stare" "stando" "stato" "sto" "stai" "sta" "stiamo"
                           "state" "stanno" "sta";

}   
