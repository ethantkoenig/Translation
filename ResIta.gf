resource ResIta = open MorphIta {
  param
    Polarity = Pos | Neg;
    Tense = Pres | Past;
    AuxType = Be | Have | NonAux;
    Participle = Avere | Essere;

  oper
    {- TYPES -}
    N_ : Type = {g : Gender; i : NounInitial ; s : Number => Str};
    N : Type = {g : Gender; n : Number; i : NounInitial; s : Str};
    N' : Type = {g : Gender; n : Number; i : NounInitial; s : Str};
    NP : Type = {g : Gender; n : Number; p : Person; s : Str};

    D : Type = {s : Number => Gender => NounInitial => Str};

    VType : Type = {auxtype : AuxType; part : Participle;
                    inf : Str; pres : Str; past : Str;
                    conj : Tense => Number => Person => Str};
    V : Type = VType;
    Aux : Type = VType;
    V' : Type = {head : V; suffix : Str};
    VP__ : Type = V';
    VP_ : Type = {t : Tense; head : V; suffix : Str};
    VP : Type = {p : Polarity; t : Tense; prefix : Str;
                 s : Number => Person => Str; suffix : Str}; 

    ArgStructure = {np1 : Str}; -- TODO incomplete

    S : Type = {s : Str};

    {- ARGUMENT FUNCTIONS -}
    mkArg_ : ArgStructure = {np1 = ""};
    mkArg_NP : NP -> ArgStructure =
      \np -> {np1 = np.s};

    
    {- LEXICAL FUNCTIONS -}

    _constructN_ : (gnd : Str) (uomo, uomini : Str) -> N_ =
      \gnd, uomo, uomini -> {g = gnd; i = nounInitial uomo;
                             s = table {Sg => uomo; Pl => uomini}};

    mkN_ = overload {
      mkN_ : (gatto : Str) -> N_ =
        \gatto -> _mkN_ (inferGender gatto) gatto (pluarize gatto);

      mkN_ : (gnd : Gender) -> (gatto : Str) -> N_ =
        \gnd, gatto -> _mkN_ gnd gatto (pluarize gatto);

      mkN_ : (gnd : Gender) -> (uomo, uomini : Str) -> N_ = _mkN_;
    };

    _constructV : (at : AuxType) (p : Participle) -> (avere, avendo, avuto : Str)
              -> (conj : Number => Person => Str) => V =
        \at, p, avere, avendo, avuto, conj ->
        {auxtype = at; part = p;
         inf = avere; pres = avendo; past = avuto;
         conj = table {Pres => conj;
                       _ => \\_, _ => ""};

    _mkV = overload {
      _mkV : (at : AuxType) -> (mangiare : Str) -> V =
        \at, mangiare -> _constructV at mangiare (presParticiple mangiare)
                                     (pastParticiple mangiare) (conjugate mangiare);

      _mkV : (at : AuxType) 
             -> (avere, avendo, avuto, ho, hai, ha, abbiamo, avete, hanno : Str) -> V =
        \at, avere, avendo, avuto, ho, hai, ha, abbiamo, avete, hanno ->
          let (conj : Number => Person => Str) =
            table {Sg => table {First => ho; Second => hai; Third => ha};
                   Pl => table {First => abbiamo; Second => avete; Third => hanno}} in
          _constructV at avere avendo avuto conj;
    };

    -- TODO
    mkV = overload {
      mkV : (mangiare : Str) -> V = \mangiare -> _mkV NonAux Avere mangiare;

      mkV : (avere, avendo, avuto, ho, hai, ha, abbiamo, avete, hanno : Str) -> V =
        \avere, avendo, avuto, ho, hai, ha, abbiamo, avete, hanno ->
          _mkV NonAux Avere avere avendo avuto hai ha abbiamo avete hanno;
    };


    {- FEATURE FUNCTIONS -}

    singular : N_ -> N =
      \gatto -> {g = gatto.g; n = Sg; s = gatto.s ! Sg};

    plural : N_ -> N =
      \gatto -> {g = gatto.g; n = Pl; s = gatto.s ! Pl};

    present : VP__ -> VP_ =
      \vp -> {t = Pres; head = vp.head; suffix = vp.suffix};
    
    -- TODO 
    past : VP__ -> VP_ =
      \vp -> {t = Past; head = vp.head; suffix = vp.suffix};

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
                     s = (il.s ! gatto.n ! gatto.g ! gatto.pr) ++ gatto.s};

    mkV' : V -> ArgStructure -> V' =
      \v, as -> {head = v; suffix = as.np1};


    addAux : Aux -> VP__ -> V' =
      \a, vp -> case a.auxtype of {
                  Have => case vp.head.p of {
                            Avere => {

    mkVP__ : V' => VP__ = \v' -> v';

    mkS : NP -> VP -> S = 
      \np, vp -> {s = np.s ++ vp.s ! np.n ! np.p ++ vp.suffix};

}
