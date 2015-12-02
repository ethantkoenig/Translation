instance SyntaxIta of Syntax =
    open LexemeIta, {- MorphIta, -} Prelude, TypesIta, Utils, UtilsIta in {
  oper
   
    {- Argument Structures -}
    _nonArgStructure : (sb : NP) -> ArgStructure = \sb ->
      {obj = defaultObj; preSubj = \\_, _ => nonword; postSubj = \\_, _ => nonword;
       postVerb = \\_, _, _ => nonword; subj = sb; wh = True};

    mkArgVoid : NP -> ArgStructure = \sb -> 
     {obj = defaultObj; preSubj = \\_, _ => ""; postSubj = \\_, _ => "";
      postVerb = \\_, _, _ => ""; subj = sb; wh = sb.wh};

    mkArgNP : NP -> NP -> ArgStructure = \sb, obj -> 
      case <sb.wh, obj.wh, obj.pronoun> of {
        <_, False, False> => 
          {obj = objOfNP obj; preSubj = \\_, _ => ""; postSubj = \\_, _ => "";
           postVerb = \\nm, pr, gn => obj.s ! Acc ! nm ! pr;
           subj = sb; wh = sb.wh};
        <_, False, True>  =>
          {obj = objOfNP obj; preSubj = \\_, _ => ""; postSubj = obj.s ! Acc;
           postVerb = \\_, _, _ => ""; subj = sb; wh = sb.wh};
        <False, True, _> =>
          {obj = objOfNP obj; preSubj = obj.s ! Acc; postSubj = \\_, _ => "";
           postVerb = \\_, _, _ => ""; subj = sb; wh = True};
        _ => _nonArgStructure sb
    };

    mkArgAdj : NP -> Adj -> ArgStructure = \sb, ad -> 
      {obj = defaultObj; preSubj = \\_, _ => ""; postSubj = \\_, _ => ""; 
       postVerb = \\nm, pr, gn => ad.s ! nm ! gn; 
       subj = sb; wh = sb.wh};

    mkArgNPNP : NP -> NP -> NP -> ArgStructure = \sb, obj1, obj2 -> 
      case <sb.wh, obj1.wh, obj1.pronoun, obj2.wh> of { -- does not handle obj2 pronouns (yet)
        <_, False, False, False> =>
          {obj = objOfNP obj1; preSubj = \\_, _ => ""; postSubj = \\_, _ => "";
           postVerb = \\nm, pr, gn => obj1.s ! Acc ! nm ! pr
                                      ++ obj2.s ! Acc ! nm ! pr;
           subj = sb; wh = sb.wh};
        <False, False, False, True> =>
          {obj = objOfNP obj1; preSubj = obj2.s ! Acc; postSubj = \\_, _ => "";
           postVerb = \\nm, pr, gn => obj1.s ! Acc ! nm ! pr;
           subj = sb; wh = True};
        <_, False, True, False> => 
          {obj = objOfNP obj1; preSubj = \\_, _ => ""; postSubj = obj1.s ! Acc;
           postVerb = \\nm, pr, gn => obj2.s ! Acc ! nm ! pr;
           subj = sb; wh = sb.wh};
        <False, False, True, True> => 
          {obj = objOfNP obj1; preSubj = obj2.s ! Acc; postSubj = obj1.s ! Acc;
           postVerb = \\_, _, _ => ""; subj = sb; wh = True};
        <False, True, _, False> =>
          {obj = objOfNP obj1; preSubj = obj1.s ! Acc; postSubj = \\_, _ => "";
           postVerb = \\nm, pr, gn => obj2.s ! Acc ! nm ! pr;
           subj = sb; wh = True};
        _ => _nonArgStructure sb
      };


    {- Feature Functions -}
    singular : N_ -> N = \gatto -> gatto ** 
      {num = Sg; person = Third; s = gatto.s ! Sg};

    plural : N_ -> N = \gatto -> gatto ** 
      {num = Pl; person = Third; s = gatto.s ! Pl};

    declarative : S_ -> S = \s -> 
      let subj : NP = s.subj in
      let s : Number => Person => Gender => Str = composeVP False s in
      {s = s ! subj.num ! subj.person ! subj.gend};

    interrogative : S_ -> S = \s ->       
      let subj : NP = s.subj in
      let s : Number => Person => Gender => Str = composeVP True s in
      {s = s ! subj.num ! subj.person ! subj.gend};

    present : VP__ -> VP_ = \vp -> vp ** {tense = Pres};

    past : VP__ -> VP_ = \vp -> present (auxHave vp);

    future : VP__ -> VP_ = \vp -> vp ** {tense = Fut};

    cond : VP__ -> VP_ = \vp -> vp ** {tense = Cond};

    positive : VP_ -> VP = \vp -> vp;

    negative : VP_ -> VP = \vp -> vp ** 
      {postSubj = \\nm, pr => "non" ++ vp.postSubj ! nm ! pr};

    {- Grammatical Functions -}
    mkN' : N -> N' = \n -> n;

    adjoinN'Adj : N' -> Adj -> N' = \n', a -> n' **
      {s = n'.s ++ a.s ! n'.num ! n'.gend};

    adjoinN'CP : N' -> CP -> N' = \n', cp -> n' **
      {s = n'.s ++ cp.s ! n'.num ! n'.person ! n'.gend};

    adjoinN'PP : N' -> PP -> N' = \n', pp -> n' **
      {s = n'.s ++ pp.s ! n'.num ! n'.person};   

    mkNP : D -> N' -> NP = \il, gatto -> 
      {gend = gatto.gend; null = False; num = gatto.num; person = Third;
       possessive = \\_, _ => nonword; pronoun = False; wh = False;
       s = \\_, nm, pr => (il.s ! gatto.abstractOrMass ! gatto.num 
                           ! gatto.gend ! gatto.init) ++ gatto.s};

    npOfProNP : ProNP -> NP = \pronp -> pronp;
    npOfReflexive : Reflexive -> NP = \refl -> refl;
    npOfProperN : ProperN -> NP = \prop -> prop;

    possessive : NP -> N' -> NP = \owner, ownee ->
      {gend = ownee.gend; null = False; num = ownee.num; person = ownee.person;
       possessive = \\_, _ => nonword; pronoun = False; wh = owner.wh;
       s = case owner.pronoun of {
         False => \\c, _, _ => 
           definite.s ! ownee.abstractOrMass ! ownee.num ! ownee.gend ! ownee.init
           ++ ownee.s ++ "di" ++ owner.s ! c ! defaultNumber ! defaultPerson;
         True => \\c, _, _ => 
           definite.s ! ownee.abstractOrMass ! ownee.num ! ownee.gend ! Con
           ++ (owner.possessive ! ownee.num ! ownee.gend) ++ ownee.s
           }};

    mkPP : P -> NP -> PP = \p, np ->
      {s = \\nm, pr => p.s ++ np.s ! Dis ! nm ! pr};

    mkV' : V -> ArgStructure -> V' = \v, args -> args ** {aux = False; head = v};

    adjoinV'PP : V' -> PP -> V' = \v', pp -> v' **
      {postVerb = \\nm, pr, gn => v'.postVerb ! nm ! pr ! gn ++ pp.s ! nm ! pr};

    auxBe : VP__ -> VP__ = \vp -> vp **
      {aux = True; head = stare; 
       postVerb = \\nm, pr, gn => vp.head.presPart 
                                  ++ vp.postVerb ! nm ! pr ! gn};

    auxHave : VP__ -> VP__ = \vp -> vp **
      {aux = True; head = case vp.head.aux of {Avere => avere; Essere => essere};
       postVerb = case <vp.head.aux, vp.aux, vp.obj.pronoun> of {
        <Avere, True, _> | <Avere, _, False> => 
          \\nm, pr, gn => vp.head.pastPart ! Sg ! Masc 
                           ++ vp.postVerb ! nm ! pr ! gn;
        <Avere, False, True> => 
          \\nm, pr, gn => vp.head.pastPart ! vp.obj.num ! vp.obj.gend
                          ++ vp.postVerb ! nm ! pr ! gn;
        <Essere, _> => 
          \\nm, pr, gn => vp.head.pastPart ! nm ! gn 
                          ++ vp.postVerb ! nm ! pr ! gn}};

    mkVP__ : V' -> VP__ = \v' -> v';

    mkS_ : VP -> S_ = \vp ->
      case vp.wh of {
        False => vp;
        True => vp ** {postVerb = \\_, _, _ => nonword}};

    mkCP : VP -> CP = \vp ->
      case vp.wh of {
        False => {s = \\_, _, _ => nonword};
        True => 
          let subj : NP = vp.subj in
          let s : Number => Person => Gender => Str = composeVP False vp in 
          case subj.null of {
            False => {s = \\_, _, _ => s ! subj.num ! subj.person ! subj.gend};                      
            True => {s = s}
          }
      };

    {- Utility Functions -}
    composeVP : (invert : Bool) -> VP -> Number => Person => Gender => Str =
        \invert, vp ->
      case invert of {
        False => \\nm, pr, gn => 
          vp.preSubj ! nm ! pr ++ vp.subj.s ! Nom ! nm ! pr
          ++ vp.postSubj ! nm ! pr ++ vp.head.conj ! vp.tense ! nm ! pr
          ++ vp.postVerb ! nm ! pr ! gn;
        True => \\nm, pr, gn =>
          vp.preSubj ! nm ! pr ++ vp.postSubj ! nm ! pr 
          ++ vp.head.conj ! vp.tense ! nm ! pr ++ vp.postVerb ! nm ! pr ! gn
          ++ vp.subj.s ! Nom ! nm ! pr
      };
}   
