resource ResIta = open MorphIta in {
  param
    Polarity = Pos | Neg;
    Tense = Pres | Past;
    Aux = Be | Have | NonAux;
  oper
    {- TYPES -}
    N_ : Type = {g : Gender; i : NounInitial ; s : Number => Str};
    N : Type = {g : Gender; n : Number; i : NounInitial; s : Str};
    N' : Type = {g : Gender; n : Number; i : NounInitial; s : Str};
    NP : Type = {g : Gender; n : Number; p : Person; s : Str};

    D : Type = {s : Number => Gender => NounInitial => Str};

    V : Type = {auxtype : Aux; part : Participle;
                    inf : Str; pres : Str; past : Number => Gender => Str;
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

    _constructV : (at : Aux) -> (p : Participle) -> (avere, avendo, avuto : Str)
              -> (conj : Number => Person => Str) -> V =
        \at, p, avere, avendo, avuto, conj ->
        {auxtype = at; part = p;
         inf = avere; pres = avendo; past = pastParticiples p avuto;
         conj = table {Pres => conj;
                       _ => \\_, _ => ""}};

    _mkV = overload {
      _mkV : (a : Aux) -> (p : Participle) -> (mangiare : Str) -> V =
        \a, p, mangiare -> _constructV a p mangiare (presParticiple mangiare)
                                     (pastParticiple mangiare) (conjugate mangiare);

      _mkV : (a : Aux) -> (p : Participle) 
             -> (avere, avendo, avuto, ho, hai, ha, abbiamo, avete, hanno : Str) -> V =
        \a, p, avere, avendo, avuto, ho, hai, ha, abbiamo, avete, hanno ->
          let conj : Number => Person => Str =
            table {Sg => table {First => ho; Second => hai; Third => ha};
                   Pl => table {First => abbiamo; Second => avete; Third => hanno}} in
          _constructV a p avere avendo avuto conj;
    };

    mkV = overload {
      mkV : (p : Participle) -> (mangiare : Str) -> V = 
        \p, mangiare -> _mkV NonAux p mangiare;

      mkV : (p : Participle) 
            -> (avere, avendo, avuto, ho, hai, ha, abbiamo, avete, hanno : Str) -> V =
        \p, avere, avendo, avuto, ho, hai, ha, abbiamo, avete, hanno ->
          _mkV NonAux p avere avendo avuto ho hai ha abbiamo avete hanno;
    };


    {- FEATURE FUNCTIONS -}

    singular : N_ -> N =
      \gatto -> {g = gatto.g; i = gatto.i; n = Sg; s = gatto.s ! Sg};

    plural : N_ -> N =
      \gatto -> {g = gatto.g; i = gatto.i; n = Pl; s = gatto.s ! Pl};

    present : VP__ -> VP_ =
      \vp -> {t = Pres; head = vp.head; suffix = vp.suffix};
    
    past : VP__ -> VP_ =
      \vp -> {t = Pres; head = case vp.head.part of {Avere => avere; Essere => essere}; 
              suffix = \\n, g => vp.head.past ! n ! g ++ vp.suffix ! n ! g};

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

    {-
    addAux : Aux -> VP__ -> V' =
      \a, vp -> case a of {
                  Have => case vp.head.part of {
                            Avere => {head = avere; 
                                      suffix = \\n, g => vp.head.past ! n ! g 
                                                         ++ vp.suffix ! n ! g};
                            Essere => {head = essere;
                                       suffix = \\n, g => vp.head.past ! n ! g
                                                          ++ vp.suffix ! n ! g}
                          };
                  Be => {head = stare; suffix = \\n, g => vp.head.pres ++ vp.suffix ! n ! g};
                  _ => {head = vp.head; suffix = vp.suffix}
                };-}

    auxBe : VP__ -> V' =
      \vp -> {head = stare; suffix = \\n, g => vp.head.pres ++ vp.suffix ! n ! g}; 

    auxHave : VP__ -> V' =
      \vp -> {head = case vp.head.part of {Avere => avere; Essere => essere}; 
              suffix = \\n, g => vp.head.past ! n ! g ++ vp.suffix ! n ! g};

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

  
    essere : V = _mkV Have Essere "essere" "essendo" "stato" "sono" "sei" "e'" 
                              "siamo" "siete" "sono";

    avere : V = _mkV Have Avere "avere" "avendo" "avuto" "ho" "hai" "ha" "abbiamo"
                            "avete" "hanno";

    stare : V = _mkV Be Essere "stare" "stando" "stato" "sto" "stai" "sta" "stiamo"
                           "state" "stanno";

}   
