resource ResEng = {
  param
    Number = Sg | Pl;
    Person = First | Second | Third;
    Polarity = Pos | Neg;
    Tense = Pres | Past;
    Aux = Be | Have | Do | NonAux;
  oper
    {- TYPES -}

    N_ : Type = {s : Number => Str};
    N : Type = {n : Number; s : Str};
    N' : Type = {n : Number; s : Str};
    NP : Type = {n : Number; p : Person; s : Str};

    D : Type = {s : Number => Str};

    V : Type = {auxtype : Aux; inf : Str; pres : Str; past : Str;
                    conj : Tense => Number => Person => Str};
    V' : Type = {head : V; suffix : Str};
    VP__ : Type = V';
    VP_ : Type = {t : Tense; head : V; suffix : Str};
    VP : Type = {p : Polarity; t : Tense; s : Number => Person => Str; suffix : Str};

    -- Adj : Type = {s : Str};
    -- AdjP : Type = {s : Str};

    ArgStructure = {np1 : Str}; -- TODO incomplete

    S : Type = {s : Str};

    {- ARGUMENT FUNCTIONS -}
    mkArg_ : ArgStructure = {np1 = ""};
    mkArg_NP : NP -> ArgStructure =
      \np -> {np1 = np.s};

    {- INFLECTIONAL FUNCTIONS -}
    append_s : Str -> Str =
      \dog -> case dog of {
                _ + ("a" | "e" | "i" | "o" | "u") + "o" => dog + "s";
                _ + ("s" | "x" | "sh" | "o") =>  dog + "es";
                _ + ("a" | "e" | "o" | "u" ) + "y" => dog + "s";
                x + "y" => x + "ies";
                _ => dog + "s"
              };

    -- TODO
    append_ed : Str -> Str =
      \walk -> case walk of {
               _ => walk + "ed"
               };

    -- TODO
    append_ing : Str -> Str =
      \walk -> case walk of {
               _ => walk + "ing"
               };

    {- LEXICAL FUNCTIONS -}

    mkN_ = overload {
      {- Nouns with regular plural forms -}
      mkN_ : Str -> N_ =
        \dog -> {s = table { Sg => dog; Pl => append_s dog}};

      {- Nouns with irregular plural forms -}
      mkN_ : Str -> Str -> N_ =
        \dog, dogs -> {s = table { Sg => dog; Pl => dogs}};
    };

    mkD : Str -> Str -> D =
      \this, those -> {s = table {Sg => this; Pl => those}};

     _mkV_helper : (a: Aux) -> (be, being, been, am, are, is, was, were : Str)
                            -> V =
      \a, be, being, been, am, are, is, was, were ->
          {auxtype = a; inf = be; pres = being; past = been;
           conj = table 
                  {Pres => table
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
                                  {First | Second | Third => were}}}};

    _mkV = overload {
      _mkV : (a : Aux) -> (walk : Str) -> V =
        \a, walk -> _mkV_helper a walk (append_ing walk) (append_ed walk)
                                  walk walk (append_s walk) (append_ed walk) 
                                  (append_ed walk); 
            
      _mkV : (a : Aux) -> (buy, bought : Str) -> V =
        \a, buy, bought -> _mkV_helper a buy (append_ing buy) bought buy buy 
                                         (append_s buy) bought bought;

      _mkV : (a : Aux) -> (be, being, been, am, are, is, was, were : Str)
                           -> V = _mkV_helper
      };

    mkV = overload {
      mkV : (walk : Str) -> V =
        \walk -> _mkV NonAux walk;
      mkV : (buy, bought : Str) -> V =
        \buy, bought -> _mkV NonAux buy bought;
      mkV : (be, being, been, am, are, is, was, were : Str) -> V = 
        \be, being ,been, am, are, is, was, were -> 
          _mkV NonAux be being been am are is was were;       
      };
      
    {- FEATURE FUNCTIONS -}
    singular : N_ -> N =
      \dog -> {n = Sg; s = dog.s ! Sg};

    plural : N_ -> N = 
      \dog -> {n = Pl; s = dog.s ! Pl};

    present : VP__ -> VP_ =
      \vp -> {t = Pres; head = vp.head; suffix = vp.suffix};
    
    past : VP__ -> VP_ =
      \vp -> {t = Past; head = vp.head; suffix = vp.suffix};

    positive : VP_ -> VP =
      \vp -> {p = Pos; t = vp.t; s = vp.head.conj ! vp.t; suffix = vp.suffix};

    negative : VP_ -> VP =
      \vp -> case vp.head.auxtype of
             {NonAux => {p = Neg; t = vp.t; s = do.conj ! vp.t;
                         suffix = "not" ++ (vp.head.inf) ++ vp.suffix};
              _ => {p = Neg; t = vp.t; s = vp.head.conj ! vp.t;
                    suffix = "not" ++ vp.suffix}
             };  

    {- GRAMMATICAL FUNCTIONS -}
    mkN' : N -> N' = \n -> n;

    --adjN' : N' -> Adj -> N' =
    --  \dog, fast -> {n = dog.n; s = fast.s ++ dog.s};

    mkNP : D -> N' -> NP =
      \the, dog -> {n = dog.n; p = Third; s = the.s ! (dog.n) ++ dog.s };

  
    mkV' : V -> ArgStructure -> V' =
      \v, as -> {head = v; suffix = as.np1};

    {-
    addAux : Aux -> VP__ -> V' =
      \a, vp -> case a of
                {Be => {head = be; suffix = vp.head.pres ++ vp.suffix};
                 Have => {head = have; suffix = vp.head.past ++ vp.suffix};
                 _ => {head = vp.head; suffix = ""}
                };-}

    auxBe : VP__ -> V' =
      \vp -> {head = be; suffix = vp.head.pres ++ vp.suffix};

    auxHave : VP__ -> V' =
      \vp -> {head = have; suffix = vp.head.past ++ vp.suffix};

    mkVP__ : V' -> VP__ = \v' -> v';

    mkS : NP -> VP -> S =
      \np, vp -> {s = np.s ++ vp.s ! np.n ! np.p ++ vp.suffix};

  
    {- FUNCTIONAL WORDS -}
    a : D = {s = table {_ => "a"}};
    the : D = {s = table {_ => "the"}};

    be : V = _mkV Be "be" "being" "been" "am" "are" "is" "was" "were";
    do : V = _mkV Do "do" "did";
    have : V = _mkV Have "have" "having" "had" "have" "have" "has" "had" "had";
}
