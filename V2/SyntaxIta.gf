instance SyntaxIta of Syntax = 
    open Concepts, Maybe, MorphIta, Prelude in {
  param
    Polarity = Pos | Neg;
    Tense = Pres | Past | Fut | Cond;
  oper
    {- TYPES -}
    N_ : Type = {c: NounConcept; g : Gender; i : NounInitial ; s : Number => Str};
    N : Type = {c : NounConcept; g : Gender; n : Number; i : NounInitial; s : Str};
    N' : Type = {c : NounConcept; g : Gender; n : Number; i : NounInitial; s : Str};
    NP : Type = {c : NounConcept; g : Gender; n : Number; p : Person; s : Str};

    D : Type = {s : Number => Gender => NounInitial => Str};

    {- all of the "acutal" content of a verb -}
    Vcore : Type = {c : VerbConcept; aux : Aux; inf : Str; presPart : Str;
                pastPart : Number => Gender => Str;
                conj : Tense => Number => Person => Str};

    V : Type = {self: Vcore; map : ArgStructure => {v : Vcore; args : ArgStructure}};

    V' : Type = {head : Vcore; prefix : Str; g : Gender; n : Number; 
                 p : Person; suffix : Str};
    VP__ : Type = V';
    VP_ : Type = {t : Tense; head : Vcore; prefix : Str; g : Gender; n : Number; 
                  p : Person; suffix : Str};
    VP : Type = {s : Str}; 

    ArgStructure : Type = {subj : Str; g : Gender; n : Number; 
                           p : Person; np1 : Str}; -- TODO incomplete

    {- ARGUMENT FUNCTIONS -}
    mkArg_ : NP -> ArgStructure = 
      \sb -> {subj = sb.s; g = sb.g; n = sb.n; p = sb.p; np1 = ""};
    mkArg_NP : NP -> NP -> ArgStructure =
      \sb, np -> {subj = sb.s; g = sb.g; n = sb.n; p = sb.p; np1 = np.s};

    
    {- LEXICAL FUNCTIONS -}
      {- NOUNS -}
    _constructN_ : (c : NounConcept) -> (gnd : Gender) -> (uomo, uomini : Str) -> N_ =
      \c, gnd, uomo, uomini -> {c = c; g = gnd; i = nounInitial uomo;
                             s = table {Sg => uomo; Pl => uomini}};

    mkN_ = overload {
      mkN_ : (c : NounConcept) -> (gatto : Str) -> N_ =
        \c, gatto -> _constructN_ c (inferGender gatto) gatto (pluralize gatto);

      mkN_ : (c : NounConcept) -> (gnd : Gender) -> (gatto : Str) -> N_ =
        \c, gnd, gatto -> _constructN_ c gnd gatto (pluralize gatto);

      mkN_ : (c : NounConcept) -> (gnd : Gender) -> (uomo, uomini : Str) -> N_ =
        _constructN_;
    };

      {- VERBS -}
    _constructVcore : (c : VerbConcept) -> (aux : Aux) 
                      -> (avere, avendo, avuto : Str)
                      -> (presConj : Number => Person => Str) 
                      -> (av : Str) -> Vcore =
        \c, aux, avere, avendo, avuto, presConj, av ->
          let futConj : Number => Person => Str = futureConjugate av in
          let condConj : Number => Person => Str = condConjugate av in
          {c = c; aux = aux; inf = avere;
           presPart = avendo; pastPart = pastParticiples aux avuto;
           conj = table {Pres => presConj; Fut => futConj;
                         Cond => condConj; Past => \\_, _ => ""}};

    _constructV : (c : VerbConcept) -> (aux : Aux) -> (avere, avendo, avuto : Str)
                  -> (presConj : Number => Person => Str) -> (av : Str) 
                  -> (map : ArgStructure => {v : Maybe V; args : ArgStructure}) -> V =
      \c, aux, avere, avendo, avuto, presConj, av, map ->
        let core : Vcore = _constructVcore c aux avere avendo avuto presConj av in
        let map' : ArgStructure => {v : Vcore; args : ArgStructure} =
          \\a => let r : {v : Maybe V; args : ArgStructure} = map ! a in
                 case exists V r.v of {
                   True => {v = (fromJust V r.v).self; args = a};
                   False => {v = core; args = a}
                 }
        in {self = core; map = map'};


    mkV = overload {
      mkV : (c : VerbConcept) -> (aux : Aux) -> (mangiare : Str) 
            -> (map : ArgStructure => {v : Maybe V; args : ArgStructure})-> V =
        \c, aux, mangiare, map -> 
          let pres : Str = presParticiple mangiare in
          let past : Str = pastParticiple mangiare in
          let presConj : Number => Person => Str = presConjugate mangiare in
          let stm : Str = stem mangiare in
          _constructV c aux mangiare pres past presConj stm map;

      mkV : (c : VerbConcept) -> (aux : Aux) 
            -> (avere, avendo, avuto, ho, hai,
                ha, abbiamo, avete, hanno, av : Str)
            -> (map : ArgStructure => {v : Maybe V; args : ArgStructure}) -> V =
        \c, aux, avere, avendo, avuto, ho, hai, ha, abbiamo, avete, hanno, av, map ->
          let presConj : Number => Person => Str =
            table {Sg => table {First => ho; Second => hai; Third => ha};
                   Pl => table {First => abbiamo; Second => avete; Third => hanno}} in
          _constructV c aux avere avendo avuto presConj av map;
    };


    {- FEATURE FUNCTIONS -}

    singular : N_ -> N =
      \gatto -> {c = gatto.c; g = gatto.g; i = gatto.i; n = Sg; s = gatto.s ! Sg};

    plural : N_ -> N =
      \gatto -> {c = gatto.c; g = gatto.g; i = gatto.i; n = Pl; s = gatto.s ! Pl};

    present : VP__ -> VP_ =
      \vp -> {t = Pres; prefix = vp.prefix; g = vp.g; n = vp.n; p = vp.p;
              head = vp.head; suffix = vp.suffix};
    
    past : VP__ -> VP_ =
      \vp -> {t = Pres; prefix = vp.prefix; g = vp.g; n = vp.n; p = vp.p;
              head = case vp.head.aux of {Avere => avere.self; Essere => essere.self}; 
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

    mkNP : D -> N' -> NP =
      \il, gatto -> {c = gatto.c; g = gatto.g; n = gatto.n; p = Third;
                     s = (il.s ! gatto.n ! gatto.g ! gatto.i) ++ gatto.s};

    -- TODO this is where we need to check for idiomatics
    mkV' : V -> ArgStructure -> V' =
      \v, args -> let new : {v : Vcore; args : ArgStructure} = v.map ! args in
                  let args : ArgStructure = new.args in
                  {head = new.v; prefix = args.subj; g = args.g; n = args.n;
                   p = args.p; suffix = args.np1};

    auxBe : VP__ -> V' =
      \vp -> {head = stare.self; prefix = vp.prefix; g = vp.g; n = vp.n; p = vp.p;
              suffix = vp.head.presPart ++ vp.suffix}; 

    auxHave : VP__ -> V' =
      \vp -> {head = case vp.head.aux of {Avere => avere.self; Essere => essere.self};
              prefix = vp.prefix; g = vp.g; n = vp.n; p = vp.p;
              suffix = vp.head.pastPart ! vp.n ! vp.g ++ vp.suffix};

    mkVP__ : V' -> VP__ = \v' -> v';

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


  
    identity : ArgStructure => {v : Maybe V; args : ArgStructure} =
      \\a => {v = Nothing' V; args = a};

    essere : V = mkV ArbitraryVerb Essere "essere" "essendo" "stato" "sono"
                     "sei" "e'" "siamo" "siete" "sono" "sa" identity;

    avere : V = mkV ArbitraryVerb Avere "avere" "avendo" "avuto" "ho" "hai"
                    "ha" "abbiamo" "avete" "hanno" "av" identity;

    stare : V = mkV ArbitraryVerb Essere "stare" "stando" "stato" "sto" "stai" "sta" "stiamo"
                    "state" "stanno" "sta" identity;

}   
