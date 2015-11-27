instance SyntaxEng of Syntax = 
    open LexemeEng, Prelude, TypesEng, Utils, UtilsEng in {
  oper
    {- ARGUMENT FUNCTIONS -}

    _nonArgStructure : (sb : NP) -> ArgStructure = \sb -> 
      {null = True; postface = \\_, _, _ => nonword; subj = sb};

    mkArgVoid : NP -> ArgStructure = \sb -> 
      {null = sb.null; postface = \\_, _, _ => ""; subj = sb};

    mkArgNP : NP -> NP -> ArgStructure = \sb, obj -> 
      case and sb.null obj.null of {
        False => {null = or sb.null obj.null; postface = obj.s ! Acc; subj = sb};
        True => _nonArgStructure sb
      };

    mkArgAdj : NP -> Adj -> ArgStructure = \sb, ad -> 
      {null = sb.null; postface = \\_, _, _ => ad.s; subj = sb};

    mkArgNPNP : NP -> NP -> NP -> ArgStructure = \sb, obj1, obj2 ->
      case two sb.null obj1.null obj2.null of {
        False => {null = or sb.null (or obj1.null obj2.null); subj = sb;
                  postface = \\num, per, gnd => obj1.s ! Acc ! num ! per ! gnd
                                                ++ obj2.s ! Acc ! num ! per ! gnd};
        True => _nonArgStructure sb
      };
      
    {- FEATURE FUNCTIONS -}

    singular : N_ -> N = \dog -> 
      {abstractOrMass = dog.abstractOrMass; gend = dog.gend; num = Sg;
       person = Third; s = dog.s ! Sg};

    plural : N_ -> N =  \dog -> 
      {abstractOrMass = dog.abstractOrMass; gend = dog.gend; num = Pl;
       person = Third; s = dog.s ! Pl};

    present : VP__ -> VP_ = \vp -> 
      {head = vp.head; null = vp.null; num = vp.num; person = vp.person;
       postface = vp.postface; preface = vp.preface; subj = vp.subj;
       tense = Pres};
    
    past : VP__ -> VP_ = \vp ->
      {head = vp.head; null = vp.null; num = vp.num; person = vp.person;
       postface = vp.postface; preface = vp.preface; subj = vp.subj;
       tense = Past};

    future : VP__ -> VP_ = \vp -> 
      {head = _will; null = vp.null; num = vp.num; person = vp.person;
       postface = \\nm, pr, gn => vp.head.inf ++ vp.postface ! nm ! pr ! gn;
       preface = vp.preface; subj = vp.subj; tense = Pres};

    cond : VP__ -> VP_ = \vp -> 
      {head = _would; null = vp.null; num = vp.num; person = vp.person; 
       postface = \\nm, pr, gn => vp.head.inf ++ vp.postface ! nm ! pr ! gn;
       preface = vp.preface; subj = vp.subj; tense = Pres}; 

    positive : VP_ -> VP = \vp -> 
      {null = vp.null; subj = vp.subj;
       s = \\num, per, gnd => 
               vp.preface ! num ! per ! gnd ++ vp.head.conj ! vp.tense ! num ! per
               ++ vp.postface ! num ! per ! gnd};

    negative : VP_ -> VP = \vp ->
      {null = vp.null; subj = vp.subj;
       s = case vp.head.aux of {
             False => \\num, per, gnd => vp.preface ! num ! per ! gnd ++ _do.conj ! vp.tense ! num ! per
                           ++ "not" ++ vp.head.inf ++ vp.postface ! num ! per ! gnd;
             True => \\num, per, gnd => vp.preface ! num ! per ! gnd ++ vp.head.conj ! vp.tense ! num ! per
                          ++ "not" ++ vp.postface ! num ! per ! gnd
             }};  

    {- GRAMMATICAL FUNCTIONS -}
    mkN' : N -> N' = \n -> n;

    adjoinN'Adj : N' -> Adj -> N' = \dog, fast ->
      {abstractOrMass = dog.abstractOrMass; gend = dog.gend; num = dog.num;
       person = dog.person; s = fast.s ++ dog.s};

    adjoinN'CP : N' -> CP -> N' = \n', cp ->
      {abstractOrMass = n'.abstractOrMass; gend = n'.gend; num = n'.num; 
       person = n'.person;
       s = n'.s ++ "that" ++ cp.s ! n'.num ! n'.person ! n'.gend};

    mkNP : D -> N' -> NP = \the, dog -> 
      {gend = dog.gend; null = False; num = dog.num; person = Third; 
       reflexive = False; 
       s = table {
             Pos => \\_, _, _ => the.s ! dog.abstractOrMass ! dog.num ++ dog.s ++ "'s";
             _ => \\_, _, _ => the.s ! dog.abstractOrMass ! dog.num ++ dog.s}};

-- TODO handle whose (or at least nonword)
    possessive : NP -> N' -> NP = \np, n' -> 
      {gend = n'.gend; null = False; num = n'.num; person = Third;
       reflexive = False; 
       s = table {
             Pos => \\nm, pr, gn => np.s ! Pos ! nm ! pr ! gn ++ n'.s ++ "'s";
             _ => \\nm, pr, gn => np.s ! Pos ! nm ! pr ! gn ++ n'.s}}; -- TODO need to think more about handling case here


    npOfProNP : ProNP -> NP = \pronp -> pronp; 
    npOfReflexive : Reflexive -> NP = \refl -> refl;
    npOfProperN : ProperN -> NP = \prop -> prop;
  
    mkV' : V -> ArgStructure -> V' = \v, as -> 
      {head = v; null = as.null;
       preface = as.subj.s ! Nom;
       subj = as.subj; postface = as.postface};

    auxBe : VP__ -> V' = \vp -> 
      {head = _be; null = vp.null; num = vp.num; person = vp.person; preface = vp.preface;
       postface = \\nm, pr, gn => vp.head.presPart ++ vp.postface ! nm ! pr ! gn;
       subj = vp.subj};

    auxHave : VP__ -> V' = \vp -> 
      {head = _have; null = vp.null; num = vp.num; person = vp.person; preface = vp.preface;
       postface = \\nm, pr, gn => vp.head.pastPart ++ vp.postface ! nm ! pr ! gn;
       subj = vp.subj};

    mkVP__ : V' -> VP__ = \v' -> v';

  
    mkS : VP -> S = \vp -> 
      let subj : NP = vp.subj in
      case subj.null of {
        False => {s = vp.s ! subj.num ! subj.person ! subj.gend};
        True => {s = nonword}
      };

    mkCP : VP -> CP = \vp -> 
      case vp.null of {
        False => {null = False; s = \\_, _, _ => nonword; subj = vp.subj};         
        True => 
          let subj : NP = vp.subj in
          case vp.subj.null of {
            False => {null = True; subj = subj;
                      s = \\_, _, _ => vp.s ! subj.num ! subj.person ! subj.gend};
            True => vp
          }};

    proNPofNP : NP -> ProNP = \np ->
      case np.num of {
        Sg => case np.person of {
                First => i; Second => you;
                Third => case np.gend of {
                           Masc => he; Fem => she; Neut => it}};
        Pl => case np.person of {
                First => we; Second => yall; Third => they}};


}
