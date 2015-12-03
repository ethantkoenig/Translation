instance SyntaxEng of Syntax = 
    open LexemeEng, Prelude, TypesEng, Utils, UtilsEng in {
  oper
    {- Argument Structures -}
    _nonArgStructure : (sb : NP) -> ArgStructure = \sb -> 
      {preSubj = \\_, _, _ => nonword; postVerb = \\_, _, _ => nonword;
       subj = sb; wh = True};

    mkArgVoid : NP -> ArgStructure = \sb -> 
      {preSubj = \\_, _, _ => ""; postVerb = \\_, _, _ => ""; subj = sb;
       wh = sb.wh};

    mkArgNP : NP -> NP -> ArgStructure = \sb, obj -> 
      case and sb.wh obj.wh of {
        False => case obj.wh of {
          False => {preSubj = \\_, _, _ => ""; postVerb = obj.s ! Acc;
                    subj = sb; wh = sb.wh};
          True => {preSubj = obj.s ! Acc; postVerb = \\_, _, _ => "";
                   subj = sb; wh = True}};
        True => _nonArgStructure sb
      };

    mkArgAdj : NP -> Adj -> ArgStructure = \sb, ad -> 
      {preSubj = \\_, _, _ => ""; postVerb = \\_, _, _ => ad.s; subj = sb;
       wh = sb.wh};

    mkArgNPNP : NP -> NP -> NP -> ArgStructure = \sb, obj1, obj2 ->
      case two sb.wh obj1.wh obj2.wh of {
        False => case <obj1.wh, obj2.wh> of {
          <True, _> => {preSubj = obj1.s ! Acc; postVerb = obj2.s ! Acc;
                        subj = sb; wh = True};
          <_, True> => {preSubj = obj2.s ! Acc; postVerb = obj1.s ! Acc;
                        subj = sb; wh = True};
          _ => {preSubj = \\_, _, _ => ""; subj = sb; wh = sb.wh;
                postVerb = \\num, per, gnd => obj1.s ! Acc ! num ! per ! gnd
                                               ++ obj2.s ! Acc ! num ! per ! gnd}};
        True => _nonArgStructure sb
      };
      
    {- Feature Functions -}
    singular : N_ -> N = \dog -> dog **
      {num = Sg; person = Third; s = dog.s ! Sg};

    plural : N_ -> N = \dog -> dog **
      {num = Pl; person = Third; s = dog.s ! Pl};

    declarative : S_ -> S = \s ->
      let subj : NP = s.subj in
      let s : Number => Person => Gender => Str = composeVP False s in
      {s = s ! subj.num ! subj.person ! subj.gend};

    interrogative : S_ -> S = \s ->
      let subj : NP = s.subj in
      let s : Number => Person => Gender => Str = composeVP True s in
      {s = s ! subj.num ! subj.person ! subj.gend};

    present : VP__ -> VP_ = \vp -> vp ** {tense = Pres}; 
    
    past : VP__ -> VP_ = \vp -> vp ** {tense = Past};

    future : VP__ -> VP_ = \vp -> vp **
      {head = _will;
       postVerb = \\nm, pr, gn => vp.head.inf ++ vp.postVerb ! nm ! pr ! gn;
       tense = Pres};

    cond : VP__ -> VP_ = \vp -> vp ** 
      {head = _would; 
       postVerb = \\nm, pr, gn => vp.head.inf ++ vp.postVerb ! nm ! pr ! gn;
       tense = Pres};

    positive : VP_ -> VP = \vp -> vp;

    negative : VP_ -> VP = \vp ->
      case vp.head.aux of {
        False => vp ** 
          {head = _do; postVerb = \\nm, pr, gn => "not" ++ vp.head.inf 
                                                  ++ vp.postVerb ! nm ! pr ! gn};
        True => vp ** 
          {postVerb = \\nm, pr, gn => "not" ++ vp.postVerb ! nm ! pr ! gn}   
      };

    {- Grammatical Functions -}
    mkN' : N -> N' = \n -> n;

    adjoinN'Adj : N' -> Adj -> N' = \dog, fast -> dog ** {s = fast.s ++ dog.s};

    adjoinN'CP : N' -> CP -> N' = \n', cp ->
      n' ** {s = n'.s ++ cp.s ! n'.num ! n'.person ! n'.gend};

    adjoinN'PP : N' -> PP -> N' = \n', pp -> n' **
      {s = n'.s ++ pp.s ! n'.num ! n'.person ! n'.gend};    

    mkNP : D -> N' -> NP = \the, dog -> 
      let theStr : Str = the.s ! dog.abstractOrMass ! dog.num ! dog.nounInitial
      in {gend = dog.gend; null = False; num = dog.num; person = Third; 
          reflexive = False; wh = False;
          s = table {Pos => \\_, _, _ => theStr ++ dog.s ++ "'s";
                     _ => \\_, _, _ => theStr ++ dog.s}};

    possessive : NP -> N' -> NP = \np, n' -> 
      {gend = n'.gend; null = False; num = n'.num; person = Third;
       reflexive = False; wh = np.wh;
       s = table {
             Pos => \\nm, pr, gn => np.s ! Pos ! nm ! pr ! gn ++ n'.s ++ "'s";
             _ => \\nm, pr, gn => np.s ! Pos ! nm ! pr ! gn ++ n'.s}};


    npOfProNP : ProNP -> NP = \pronp -> pronp; 
    npOfReflexive : Reflexive -> NP = \refl -> refl;
    npOfProperN : ProperN -> NP = \prop -> prop;

    mkPP : P -> NP -> PP = \p, np -> 
      {s = \\nm, pr, gn => p.s ++ np.s ! Acc ! nm ! pr ! gn};
  
    mkV' : V -> ArgStructure -> V' = \v, as -> as ** {head = v};

    adjoinV'PP : V' -> PP -> V' = \v', pp -> v' **
      {postVerb = \\nm, gn, pr => v'.postVerb ! nm ! gn ! pr
                                  ++ pp.s ! nm ! gn ! pr};
    

    auxBe : VP__ -> VP__ = \vp -> 
      vp ** {head = _be; 
             postVerb = \\nm, pr, gn => vp.head.presPart 
                                        ++ vp.postVerb ! nm ! pr ! gn};

    auxHave : VP__ -> VP__ = \vp -> 
      vp ** {head = _have; 
             postVerb = \\nm, pr, gn => vp.head.pastPart 
                                        ++ vp.postVerb ! nm ! pr ! gn};

    mkVP__ : V' -> VP__ = \v' -> v';

    mkS_ : VP -> S_ = \vp -> 
      case vp.wh of {
        False => vp;
        True => vp ** {postSubj = nonword}
      };

    mkCP : VP -> CP = \vp -> 
      case vp.wh of {
        False => {s = \\_, _, _ => nonword};         
        True =>
          let subj : NP = vp.subj in 
          let s : Number => Person => Gender => Str = composeVP False vp in          
          case subj.null of {
            False => {s = \\_, _, _ => s ! subj.num ! subj.person ! subj.gend};
            True => {s = s}
          }};

    proNPofNP : NP -> ProNP = \np ->
      case np.num of {
        Sg => case np.person of {
                First => i; Second => you;
                Third => case np.gend of {
                           Masc => he; Fem => she; Neut => it}};
        Pl => case np.person of {
                First => we; Second => yall; Third => they}};

    {- Utility Functions -}

    {- combines all of the fields in vp to a single Str.
     - invert : whether subject-aux inversion (T-to-C movement) should occur -}
    composeVP : (invert : Bool) -> VP -> Number => Person => Gender => Str =
        \invert, vp ->
      case invert of {
        False => \\nm, pr, gn => 
          vp.preSubj ! nm ! pr ! gn ++ vp.subj.s ! Nom ! nm ! pr ! gn
          ++ vp.head.conj ! vp.tense ! nm ! pr ++ vp.postVerb ! nm ! pr ! gn;
        True => case vp.head.aux of {
          False => \\nm, pr, gn => 
            _do.conj ! vp.tense ! nm ! pr ++ vp.preSubj ! nm ! pr ! gn
            ++ vp.subj.s ! Nom ! nm ! pr ! gn ++ vp.head.inf
            ++ vp.postVerb ! nm ! pr ! gn;
          True => \\nm, pr, gn => 
            vp.head.conj ! vp.tense ! nm ! pr ++ vp.preSubj ! nm ! pr ! gn 
            ++ vp.subj.s ! Nom ! nm ! pr ! gn
            ++ vp.postVerb ! nm ! pr ! gn
      }};

}
