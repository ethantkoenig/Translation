instance SyntaxEng of Syntax = open MorphEng, Prelude, Utils in {
  param
    Tense = Pres | Past;
    Case = Nom | Acc | Pos | Ref; -- TODO Ref currently not handled
  oper
    {- TYPES -}

    Adj : Type = {s : Str};

    N_ : Type = {s : Number => Case => Str};
    N : Type = {num : Number; s : Case => Str};
    N' : Type = N;
    ProNP : Type = NP;
    NP : Type = {num : Number; person : Person; s : Case => Str};


    D : Type = {s : Number => Str};

    V : Type = {aux : Bool; inf : Str; presPart : Str; pastPart : Str;
                conj : Tense => Number => Person => Str};
    V' : Type = {preface : Str; num : Number; person : Person;
                 head : V; postface : Str};
    VP__ : Type = V';
    VP_ : Type = {tense : Tense; preface : Str; num : Number; person : Person; 
                  head : V; postface : Str};
    VP : Type = {s : Str};

    ArgStructure : Type = {subj : NP; np1 : Str; adj1 : Str}; 

    {- ARGUMENT FUNCTIONS -}
    mkArgVoid : NP -> ArgStructure = 
      \sb -> {subj = sb; np1 = ""; adj1 = ""};
    mkArgNP : NP -> NP -> ArgStructure =
      \sb, np -> {subj = sb; np1 = np.s ! Acc; adj1 = ""};
    mkArgAdj : NP -> Adj -> ArgStructure =
      \sb, ad -> {subj = sb; np1 = ""; adj1 = ad.s};



    {- LEXICAL FUNCTIONS -}

    mkAdj : (happy : Str) -> Adj =
      \happy -> {s = happy};


    mkD : Str -> Str -> D =
      \this, those -> {s = table {Sg => this; Pl => those}};


    _constructN_ : (dog, dogs : Str) -> N_ =
      \dog, dogs -> {s = table { 
                           Sg => table {Pos => addPossessive dog; _ => dog};
                           Pl => table {Pos => addPossessive dogs; _ => dogs}}};

    mkN_ = overload {
      {- Nouns with regular plural forms -}
      mkN_ : Str -> N_ =
        \dog -> _constructN_ dog (append_s dog);

      {- Nouns with irregular plural forms -}
      mkN_ : Str -> Str -> N_ = _constructN_;
    };


    _constructV : (aux : Bool ) -> (be, being, been, am,
                                     are, is, was, were : Str) -> V =
      \aux, be, being, been, am, are, is, was, were ->
          {aux = aux; inf = be; presPart = being; pastPart = been;
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

    mkV = overload {
      mkV : (walk : Str) -> V =
        \walk -> _constructV False walk (append_ing walk) (append_ed walk)
                                  walk walk (append_s walk) (append_ed walk) 
                                  (append_ed walk); 
            
      mkV : (buy, bought : Str) -> V =
        \buy, bought -> _constructV False buy (append_ing buy) bought 
                                         buy buy (append_s buy) bought bought;

      mkV : (take, taken, took : Str) -> V =
        \take, taken, took -> 
          _constructV False take (append_ing take) taken take take 
                      (append_s take) took took;

      mkV : (be, being, been, am, are, is, was, were : Str) -> V = _constructV False;
      };

    {- Creates a modal, such as "will" or "would" -}
    _modal : Str -> V =
      \v -> _constructV True v v v v v v v v;

      
    {- FEATURE FUNCTIONS -}
    {-
    nonreflexive : ProNP -> Nperson = \pronp -> pronp;

    reflexive : ProNP -> NP =
      \pr -> {num = pr.num; person = pr.p; s = table {Nom | Ref => nonword; Acc => pr.s ! Ref;
                                             c => pr.s ! c}}; -}

    singular : N_ -> N =
      \dog -> {num = Sg; s = dog.s ! Sg};

    plural : N_ -> N = 
      \dog -> {num = Pl; s = dog.s ! Pl};

    present : VP__ -> VP_ =
      \vp -> {tense = Pres; preface = vp.preface; num = vp.num; person = vp.person; 
              head = vp.head; postface = vp.postface};
    
    past : VP__ -> VP_ =
      \vp -> {tense = Past; preface = vp.preface; num = vp.num;
              person = vp.person; head = vp.head; postface = vp.postface};

    future : VP__ -> VP_ =
      \vp -> {tense = Pres; preface = vp.preface; num = vp.num; person = vp.person;
              head = _will; postface = vp.head.inf ++ vp.postface};

    cond : VP__ -> VP_ =
      \vp -> {tense = Pres; preface = vp.preface; num = vp.num; person = vp.person;
              head = _would; postface =vp.head.inf ++ vp.postface}; 

    positive : VP_ -> VP =
      \vp -> {s = vp.preface ++ vp.head.conj ! vp.tense ! vp.num ! vp.person 
                            ++ vp.postface};

    negative : VP_ -> VP =
      \vp -> case vp.head.aux of
             {False => {s = vp.preface ++ _do.conj ! vp.tense ! vp.num ! vp.person
                            ++ "not" ++ (vp.head.inf) ++ vp.postface};
              True => {s = vp.preface ++ vp.head.conj ! vp.tense ! vp.num ! vp.person
                           ++ "not" ++ vp.postface}
             };  

    {- GRAMMATICAL FUNCTIONS -}
    mkN' : N -> N' = \n -> n;

    adjN' : N' -> Adj -> N' =
      \dog, fast -> {num = dog.num; s = \\c => fast.s ++ dog.s ! c};

    mkNP : D -> N' -> NP =
      \the, dog -> {num = dog.num; person = Third; 
                    s = \\c => the.s ! dog.num ++ dog.s ! c};

    possessive : NP -> N' -> NP =
      \np, n' -> {num = n'.num; person = Third;
                  s = \\c => np.s ! Pos ++ n'.s ! c}; -- TODO need to think more about handling case here

    npOfProNP : ProNP -> NP = \pronp -> pronp; 
  
    mkV' : V -> ArgStructure -> V' =
      \v, as -> let subj : NP = as.subj in
                {preface = subj.s ! Nom; num = subj.num; person = subj.person;
                 head = v; postface = as.np1 ++ as.adj1};

    auxBe : VP__ -> V' =
      \vp -> {head = _be; preface = vp.preface; num = vp.num; person = vp.person;
              postface = vp.head.presPart ++ vp.postface}; -- TODO change pres to presPart

    auxHave : VP__ -> V' =
      \vp -> {head = _have; preface = vp.preface; num = vp.num; person = vp.person;
              postface = vp.head.pastPart ++ vp.postface};

    mkVP__ : V' -> VP__ = \v' -> v';

  
    {- FUNCTIONAL WORDS -}
    indefinite : D = {s = table {_ => "a"}}; -- TODO
    definite : D = {s = \\_ => "the"};
    voidD : D = {s = \\_ => ""};

    i : ProNP = {num = Sg; person = First; 
                      s = table {Nom => "I"; Acc => "me";
                                 Pos => "my"; Ref => "myself"}};
    you : ProNP = {num = Sg; person = Second;
                        s = table {Nom | Acc => "you"; Pos => "your";
                                   Ref => "yourself"}};
    he : ProNP = {num = Sg; person = Third; 
                       s = table {Nom => "he"; Acc => "him";
                                  Pos => "his"; Ref => "himself"}};
    she : ProNP = {num = Sg; person = Third;
                        s = table {Nom => "she"; Acc | Pos => "her";
                                   Ref => "herself"}};
    we : ProNP = {num = Pl; person = First; 
                       s = table {Nom => "we"; Acc => "us";
                                  Pos => "our"; Ref => "ourselves"}};
    yall : ProNP = {num = Pl; person = Second;
                         s = table {Nom | Acc => "you"; Pos => "your";
                                    Ref => "yourselves"}};
    they : ProNP = {num = Pl; person = Third;
                         s = table {Nom => "they"; Acc => "them";
                                    Pos => "their"; Ref => "themselves"}};

    {- named verbBe to avoid naming conflicts with Lexicon -}
    beVerb = _be;
    _be : V = _constructV True "be" "being" "been" "am" "are" "is" "was" "were";
    _do : V = _constructV True "do" "doing" "done" "do" "do" "do" "did" "did";
    _have : V = _constructV True "have" "having" "had" "have" "have" "has" "had" "had";
    _will : V = _modal "will";
    _would : V = _modal "would";
}
