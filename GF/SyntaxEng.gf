instance SyntaxEng of Syntax = 
    open LexemeEng, Prelude, TypesEng, Utils, UtilsEng in {
  oper
    {- Argument Structures -}
    _nonArgStructure : (sb : NP) -> ArgStructure = \sb -> 
      {preface = \\_, _, _ => nonword; postface = \\_, _, _ => nonword;
       subj = sb; wh = True};

    mkArgVoid : NP -> ArgStructure = \sb -> 
      {preface = \\_, _, _ => ""; postface = \\_, _, _ => ""; subj = sb;
       wh = sb.wh};

    mkArgNP : NP -> NP -> ArgStructure = \sb, obj -> 
      case and sb.wh obj.wh of {
        False => case obj.wh of {
          False => {preface = \\_, _, _ => ""; postface = obj.s ! Acc;
                    subj = sb; wh = sb.wh};
          True => {preface = obj.s ! Acc; postface = \\_, _, _ => "";
                   subj = sb; wh = True}};
        True => _nonArgStructure sb
      };

    mkArgAdj : NP -> Adj -> ArgStructure = \sb, ad -> 
      {preface = \\_, _, _ => ""; postface = \\_, _, _ => ad.s; subj = sb;
       wh = sb.wh};

    mkArgNPNP : NP -> NP -> NP -> ArgStructure = \sb, obj1, obj2 ->
      case two sb.wh obj1.wh obj2.wh of {
        False => case <obj1.wh, obj2.wh> of {
          <True, _> => {preface = obj1.s ! Acc; postface = obj2.s ! Acc;
                        subj = sb; wh = True};
          <_, True> => {preface = obj2.s ! Acc; postface = obj1.s ! Acc;
                        subj = sb; wh = True};
          _ => {preface = \\_, _, _ => ""; subj = sb; wh = sb.wh;
                postface = \\num, per, gnd => obj1.s ! Acc ! num ! per ! gnd
                                               ++ obj2.s ! Acc ! num ! per ! gnd}};
        True => _nonArgStructure sb
      };
      
    {- Feature Functions -}
    singular : N_ -> N = \dog -> 
      {abstractOrMass = dog.abstractOrMass; gend = dog.gend; num = Sg;
       person = Third; s = dog.s ! Sg};

    plural : N_ -> N =  \dog -> 
      {abstractOrMass = dog.abstractOrMass; gend = dog.gend; num = Pl;
       person = Third; s = dog.s ! Pl};

    present : VP__ -> VP_ = \vp -> 
      {head = vp.head; num = vp.num; person = vp.person; postface = vp.postface;
       preface = vp.preface; subj = vp.subj; tense = Pres; wh = vp.wh};
    
    past : VP__ -> VP_ = \vp ->
      {head = vp.head; num = vp.num; person = vp.person; postface = vp.postface;
       preface = vp.preface; subj = vp.subj; tense = Past; wh = vp.wh};

    future : VP__ -> VP_ = \vp -> 
      {head = _will; null = vp.null; num = vp.num; person = vp.person;
       postface = \\nm, pr, gn => vp.head.inf ++ vp.postface ! nm ! pr ! gn;
       preface = vp.preface; subj = vp.subj; tense = Pres; wh = vp.wh};

    cond : VP__ -> VP_ = \vp -> 
      {head = _would; null = vp.null; num = vp.num; person = vp.person; 
       postface = \\nm, pr, gn => vp.head.inf ++ vp.postface ! nm ! pr ! gn;
       preface = vp.preface; subj = vp.subj; tense = Pres; wh = vp.wh}; 

    positive : VP_ -> VP = \vp -> 
      {subj = vp.subj; wh = vp.wh;
       s = \\num, per, gnd => 
               vp.preface ! num ! per ! gnd ++ vp.head.conj ! vp.tense ! num ! per
               ++ vp.postface ! num ! per ! gnd};

    negative : VP_ -> VP = \vp ->
      {subj = vp.subj; wh = vp.wh;
       s = case vp.head.aux of {
             False => \\num, per, gnd => vp.preface ! num ! per ! gnd ++ _do.conj ! vp.tense ! num ! per
                           ++ "not" ++ vp.head.inf ++ vp.postface ! num ! per ! gnd;
             True => \\num, per, gnd => vp.preface ! num ! per ! gnd ++ vp.head.conj ! vp.tense ! num ! per
                          ++ "not" ++ vp.postface ! num ! per ! gnd
             }};  

    {- Grammatical Functions -}
    mkN' : N -> N' = \n -> n;

    adjoinN'Adj : N' -> Adj -> N' = \dog, fast ->
      {abstractOrMass = dog.abstractOrMass; gend = dog.gend; num = dog.num;
       person = dog.person; s = fast.s ++ dog.s};

    adjoinN'CP : N' -> CP -> N' = \n', cp ->
      {abstractOrMass = n'.abstractOrMass; gend = n'.gend; num = n'.num; 
       person = n'.person;
       s = n'.s ++ cp.s ! n'.num ! n'.person ! n'.gend};

    mkNP : D -> N' -> NP = \the, dog -> 
      {gend = dog.gend; null = False; num = dog.num; person = Third; 
       reflexive = False; wh = False;
       s = table {
             Pos => \\_, _, _ => the.s ! dog.abstractOrMass ! dog.num ++ dog.s ++ "'s";
             _ => \\_, _, _ => the.s ! dog.abstractOrMass ! dog.num ++ dog.s}};

    possessive : NP -> N' -> NP = \np, n' -> 
      {gend = n'.gend; null = False; num = n'.num; person = Third;
       reflexive = False; wh = np.wh;
       s = table {
             Pos => \\nm, pr, gn => np.s ! Pos ! nm ! pr ! gn ++ n'.s ++ "'s";
             _ => \\nm, pr, gn => np.s ! Pos ! nm ! pr ! gn ++ n'.s}};


    npOfProNP : ProNP -> NP = \pronp -> pronp; 
    npOfReflexive : Reflexive -> NP = \refl -> refl;
    npOfProperN : ProperN -> NP = \prop -> prop;
  
    mkV' : V -> ArgStructure -> V' = \v, as -> 
      {head = v; postface = as.postface;
       preface = \\nm, pr, gn => as.preface ! nm ! pr ! gn 
                                ++ as.subj.s ! Nom ! nm ! pr ! gn;
       subj = as.subj; wh = as.wh};

    auxBe : VP__ -> V' = \vp -> 
      {head = _be; num = vp.num; person = vp.person; preface = vp.preface;
       postface = \\nm, pr, gn => vp.head.presPart ++ vp.postface ! nm ! pr ! gn;
       subj = vp.subj; wh = vp.wh};

    auxHave : VP__ -> V' = \vp -> 
      {head = _have; num = vp.num; person = vp.person; preface = vp.preface;
       postface = \\nm, pr, gn => vp.head.pastPart ++ vp.postface ! nm ! pr ! gn;
       subj = vp.subj; wh = vp.wh};

    mkVP__ : V' -> VP__ = \v' -> v';

  
    mkS : VP -> S = \vp -> 
      let subj : NP = vp.subj in
      case vp.wh of {
        False => {s = vp.s ! subj.num ! subj.person ! subj.gend};
        True => {s = nonword}
      };

    mkCP : VP -> CP = \vp -> 
      case vp.wh of {
        False => {s = \\_, _, _ => nonword; subj = vp.subj; wh = False};         
        True => 
          let subj : NP = vp.subj in
          case subj.null of {
            False => {subj = subj; wh = True;
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
