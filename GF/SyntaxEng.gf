instance SyntaxEng of Syntax = open MorphEng, Prelude, Utils {-, UtilsEng  TODO-} in {
  param
    Case = Nom | Acc | Pos;
    Gender = Masc | Fem | Neut;
    Tense = Pres | Past;
  oper
    {- TYPES -}

    Adj : Type = {s : Str};

    N_ : Type = {abstractOrMass : Bool; gend : Gender; s : Number => Case => Str};
    N : Type = {abstractOrMass : Bool; gend : Gender; num : Number; s : Case => Str};
    N' : Type = N;
    ProNP : Type = NP;
    Reflexive : Type = NP;
    ProperN : Type = NP;
    {- the (Number => Person => Gender) in the type of s are to account for 
     - reflexive pronouns, where they should be the Number, Person, and Gender
     - of the subject NP. For all other NPs, any values can be given -}
    NP : Type = {gend : Gender; num : Number; person : Person;
                 s : Case => Number => Person => Gender => Str};

    {- Bool represents whether the N' is abstractOrMass -}
    D : Type = {s : Bool => Number => Str};

    V : Type = {aux : Bool; inf : Str; presPart : Str; pastPart : Str;
                conj : Tense => Number => Person => Str};
    V' : Type = {preface : Str; num : Number; person : Person;
                 head : V; postface : Str};
    VP__ : Type = V';
    VP_ : Type = {tense : Tense; preface : Str; num : Number; person : Person; 
                  head : V; postface : Str};
    VP : Type = {s : Str};

    ArgStructure : Type = {subj : NP; postface : Str}; 

    {- ARGUMENT FUNCTIONS -}
    mkArgVoid : NP -> ArgStructure = \sb -> {subj = sb; postface = ""};
    mkArgNP : NP -> NP -> ArgStructure = \sb, obj -> 
      {subj = sb; postface = obj.s ! Acc ! sb.num ! sb.person ! sb.gend};

    mkArgAdj : NP -> Adj -> ArgStructure = \sb, ad -> 
      {subj = sb; postface = ad.s};

    mkArgNPNP : NP -> NP -> NP -> ArgStructure = \sb, obj1, obj2 ->
      {subj = sb; postface = obj1.s ! Acc ! sb.num ! sb.person ! sb.gend
                             ++ obj2.s ! Acc ! sb.num ! sb.person ! sb.gend};

    {- LEXICAL FUNCTIONS -}

    mkAdj : (happy : Str) -> Adj =
      \happy -> {s = happy};

  {- TODO
    mkD : Str -> Str -> D =
      \this, those -> {s = table {Sg => this; Pl => those}};
    -}

    _constructN_ : (abstractOrMass : Bool) -> (gend : Gender) -> (dog, dogs : Str)
                   -> N_ = \abstractOrMass, gend, dog, dogs -> 
      {abstractOrMass = abstractOrMass; gend = gend;
       s = table {Sg => table {Pos => addPossessive dog; _ => dog};
                  Pl => table {Pos => addPossessive dogs; _ => dogs}}};

    mkN_ = overload {
      {- Nouns with regular plural forms, not abstract or mass, neuter -}
      mkN_ : (dog : Str) -> N_ = \dog ->
        _constructN_ False Neut dog (append_s dog);

      {- Nouns with regular plural forms, neuter -}
      mkN_ : (abstractOrMass : Bool) -> (dog : Str) -> N_ = 
             \abstractOrMass, dog ->
        _constructN_ abstractOrMass Neut dog (append_s dog);

      {- Nouns with regular plural forms -}
      mkN_ : (gend : Gender) -> (dog : Str) -> N_ = \gend, dog ->
        _constructN_ False gend dog (append_s dog);

      {- Nouns with regular plural forms -}
      mkN_ : (abstractOrMass : Bool) -> (gend : Gender) -> (dog : Str) -> N_ =
        \abstractOrMass, gend, dog -> 
          _constructN_ abstractOrMass gend dog (append_s dog);

      {- Nouns with irregular plural forms -}
      mkN_ : (abstractOrMass : Bool) -> (gend : Gender) 
             -> (man, men : Str) -> N_ = _constructN_;
    };

    mkProperN : (gend : Gender) -> (name : Str) -> ProperN = \gend, name -> 
      {gend = gend; num = Sg; person = Third; s = \\_, _, _, _ => name}; 

    _constructV : (aux : Bool ) -> (be, being, been, am,
                                    are, is, was, were : Str) -> V =
                \aux, be, being, been, am, are, is, was, were ->
      {aux = aux; inf = be; presPart = being; pastPart = been;
       conj = table {Pres => table
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

    {- fields other than reflexive do not matter -}

{- TODO clean up
    reflexive : ProNP -> ProNP = \pro -> 
      {reflexive = True; gend = pro.gend; num = pro.num; person = pro.person;
       s = table {Acc => pro.s ! Ref; 
                  _ => nonword}};
-}

    singular : N_ -> N = \dog -> {abstractOrMass = dog.abstractOrMass;
                                  gend = dog.gend; num = Sg; s = dog.s ! Sg};

    plural : N_ -> N =  \dog -> {abstractOrMass = dog.abstractOrMass;
                                 gend = dog.gend; num = Pl; s = dog.s ! Pl};

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
      \dog, fast -> {abstractOrMass = dog.abstractOrMass; gend = dog.gend;
                     num = dog.num; s = \\c => fast.s ++ dog.s ! c};

    mkNP : D -> N' -> NP = \the, dog -> 
      {gend = dog.gend; num = dog.num; person = Third; reflexive = False; 
       s = \\c, _, _, _ => the.s ! dog.abstractOrMass ! dog.num ++ dog.s ! c};

    possessive : NP -> N' -> NP = \np, n' -> 
      {gend = n'.gend; num = n'.num; person = Third; reflexive = False; 
       s = \\cs, nm, pr, gn => np.s ! Pos ! nm ! pr ! gn ++ n'.s ! cs}; -- TODO need to think more about handling case here

    npOfProNP : ProNP -> NP = \pronp -> pronp; 
    npOfReflexive : Reflexive -> NP = \refl -> refl;
    npOfProperN : ProperN -> NP = \prop -> prop;
  
    mkV' : V -> ArgStructure -> V' =
      \v, as -> let subj : NP = as.subj in
                {head = v; num = subj.num; person = subj.person; 
                 preface = subj.s ! Nom ! subj.num ! subj.person ! subj.gend;
                 postface = as.postface};

    auxBe : VP__ -> V' = \vp -> 
      {head = _be; num = vp.num; person = vp.person;
       preface = vp.preface; postface = vp.head.presPart ++ vp.postface};

    auxHave : VP__ -> V' = \vp -> 
      {head = _have; num = vp.num; person = vp.person; preface = vp.preface;
       postface = vp.head.pastPart ++ vp.postface};

    mkVP__ : V' -> VP__ = \v' -> v';

  
    {- FUNCTIONAL WORDS -}
    indefinite : D = {s = \\_ => table {Sg => "a"; Pl => nonword}}; -- TODO a vs. an
    definite : D = {s = \\_, _ => "the"};
    voidD : D = {s = table {False => table {Sg => nonword; Pl => ""};
                            True => \\_ => ""}};


    _mkProNP : (num : Number) -> (person : Person) -> (gend : Gender)
               -> (he, him, his, himself : Str) -> ProNP = -- TODO useless himself argument
               \num, person, gend, he, him, his, himself -> 
      {gend = gend; num = num; person = person; reflexive = False;
       s = table {Nom => \\_, _, _ => he;
                  Acc => \\_, _, _ => him;
                  Pos => \\_, _, _ => his}};

     {- fields other than s do not matter -}
    reflexive : Reflexive = 
      {gend = Masc; num = Sg; person = Third; 
       s = table {
             Acc => table {
               Sg => table {
                 First => \\_ => "myself";
                 Second => \\_ => "yourself";
                 Third => table {Masc => "himself"; Fem => "herself"; 
                                 Neut => "itself"}};
               Pl => table {
                 First => \\_ => "ourselves";
                 Second => \\_ => "yourselves";
                 Third => \\_ => "themselves"}};
            Nom | Pos => \\_, _, _ => nonword}};    

    i : ProNP = _mkProNP Sg First Masc "I" "me" "my" "myself";
    you : ProNP = _mkProNP Sg Second Masc "you" "you" "your" "yourself";
    he : ProNP = _mkProNP Sg Third Masc "he" "him" "his" "himself";
    she : ProNP = _mkProNP Sg Third Fem "she" "her" "her" "herself";
    it : ProNP = _mkProNP Sg Third Neut "it" "it" "its" "itself";
    we : ProNP = _mkProNP Pl First Masc "we" "us" "our" "ourselves";
    yall : ProNP = _mkProNP Pl Second Masc "you" "you" "your" "yourselves";
    they : ProNP = _mkProNP Pl Third Masc "they" "them" "their" "themselves";

    proNPofNP : NP -> ProNP = \np ->
      case np.num of {
        Sg => case np.person of {
                First => i; Second => you;
                Third => case np.gend of {
                           Masc => he; Fem => she; Neut => it}};
        Pl => case np.person of {
                First => we; Second => yall; Third => they}};

    {- named verbBe to avoid naming conflicts with Lexicon -}
    beVerb = _be;
    _be : V = _constructV True "be" "being" "been" "am" "are" "is" "was" "were";
    _do : V = _constructV True "do" "doing" "done" "do" "do" "does" "did" "did";
    _have : V = _constructV True "have" "having" "had" "have" "have" "has" "had" "had";
    _will : V = _modal "will";
    _would : V = _modal "would";
}
