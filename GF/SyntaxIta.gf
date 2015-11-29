instance SyntaxIta of Syntax =
    open LexemeIta, {- MorphIta, -} Prelude, TypesIta, Utils, UtilsIta in {
  oper
   
    {- ArgStructures -}
    _nonArgStructure : (sb : NP) -> ArgStructure = \sb ->
      {preSubject = \\_, _ => nonword; postSubject = \\_, _ => nonword;
       postVerb = \\_, _, _ => nonword; subj = sb; wh = True};

    mkArgVoid : NP -> ArgStructure = \sb -> 
     {null = sb.null; preSubject = \\_, _ => ""; postSubject = \\_, _ => "";
      postVerb = \\_, _, _ => ""; subj = sb; wh = sb.wh};

    mkArgNP : NP -> NP -> ArgStructure = \sb, obj -> 
      case <sb.wh, obj.wh, obj.isPronoun> of {
        <_, False, False> => 
          {preSubject = \\_, _ => ""; postSubject = \\_, _ => "";
           postVerb = \\nm, pr, gn => obj.s ! Acc ! nm ! pr;
           subj = sb; wh = sb.wh};
        <_, False, True>  =>
          {preSubject = \\_, _ => ""; postSubject = obj.s ! Acc;
           postVerb = \\_, _, _ => ""; subj = sb; wh = sb.wh};
        <False, True, _> =>
          {preSubject = obj.s ! Acc; postSubject = \\_, _ => "";
           postVerb = \\_, _, _ => ""; subj = sb; wh = True};
        _ => _nonArgStructure sb
    };

    mkArgAdj : NP -> Adj -> ArgStructure = \sb, ad -> 
      {preSubject = \\_, _ => ""; postSubject = \\_, _ => ""; 
       postVerb = \\nm, pr, gn => ad.s ! nm ! gn; 
       subj = sb; wh = sb.wh};

    mkArgNPNP : NP -> NP -> NP -> ArgStructure = \sb, obj1, obj2 -> 
      case <sb.wh, obj1.wh, obj1.isPronoun, obj2.wh> of { -- does not handle obj2 pronouns (yet)
        <_, False, False, False> =>
          {preSubject = \\_, _ => ""; postSubject = \\_, _ => "";
           postVerb = \\nm, pr, gn => obj1.s ! Acc ! nm ! pr
                                      ++ obj2.s ! Acc ! nm ! pr;
           subj = sb; wh = sb.wh};
        <False, False, False, True> =>
          {preSubject = obj2.s ! Acc; postSubject = \\_, _ => "";
           postVerb = \\nm, pr, gn => obj1.s ! Acc ! nm ! pr;
           subj = sb; wh = True};
        <_, False, True, False> => 
          {preSubject = \\_, _ => ""; postSubject = obj1.s ! Acc;
           postVerb = \\nm, pr, gn => obj2.s ! Acc ! nm ! pr;
           subj = sb; wh = sb.wh};
        <False, False, True, True> => 
          {preSubject = obj2.s ! Acc; postSubject = obj1.s ! Acc;
           postVerb = \\_, _, _ => ""; subj = sb; wh = True};
        <False, True, _, False> =>
          {preSubject = obj1.s ! Acc; postSubject = \\_, _ => "";
           postVerb = \\nm, pr, gn => obj2.s ! Acc ! nm ! pr;
           subj = sb; wh = True};
        _ => _nonArgStructure sb
      };


    singular : N_ -> N = \gatto -> 
      {abstractOrMass = gatto.abstractOrMass; gend = gatto.gend;
       init = gatto.init; num = Sg; person = Third; s = gatto.s ! Sg};

    plural : N_ -> N = \gatto -> 
      {abstractOrMass = gatto.abstractOrMass; gend = gatto.gend;
       init = gatto.init; num = Pl; person = Third; s = gatto.s ! Pl};

    present : VP__ -> VP_ = \vp -> 
      {head = vp.head; preSubject = vp.preSubject; postSubject = vp.postSubject;
       postVerb = vp.postVerb; subj = vp.subj; tense = Pres; wh = vp.wh};

    past : VP__ -> VP_ = \vp -> 
      {head = case vp.head.aux of {Avere => avere; Essere => essere};
       preSubject = vp.preSubject; postSubject = vp.postSubject;
       postVerb = \\nm, pr, gn => vp.head.pastPart ! nm ! gn 
                                  ++ vp.postVerb ! nm ! pr ! gn;
       subj = vp.subj; tense = Pres; wh = vp.wh};

    future : VP__ -> VP_ = \vp -> 
      {head = vp.head; preSubject = vp.preSubject; postSubject = vp.postSubject;
       postVerb = vp.postVerb; subj = vp.subj; tense = Fut; wh = vp.wh};

    cond : VP__ -> VP_ = \vp -> 
      {head = vp.head; preSubject = vp.preSubject; postSubject = vp.postSubject;
       postVerb = vp.postVerb; subj = vp.subj; tense = Cond; wh = vp.wh};

    positive : VP_ -> VP = \vp -> 
      {s = \\nm, pr, gn => vp.preSubject ! nm ! pr 
                           ++ vp.subj.s ! Nom ! nm ! pr 
                           ++ vp.postSubject ! nm ! pr
                           ++ vp.head.conj ! vp.tense ! nm ! pr
                           ++ vp.postVerb ! nm ! pr ! gn;
       subj = vp.subj; wh = vp.wh};

    negative : VP_ -> VP = \vp -> 
      {s = \\nm, pr, gn => vp.preSubject ! nm ! pr
                           ++ vp.subj.s ! Nom ! nm ! pr  ++ "non" 
                           ++ vp.postSubject ! nm ! pr
                           ++ vp.head.conj ! vp.tense ! nm ! pr
                           ++ vp.postVerb ! nm ! pr ! gn;
       subj = vp.subj; wh = vp.wh};

    {- GRAMMATICAL FUNCTIONS -}
    mkN' : N -> N' = \n -> n;

    -- TODO handle preceding adjectives
    adjoinN'Adj : N' -> Adj -> N' = \n', a -> 
      {abstractOrMass = n'.abstractOrMass; gend = n'.gend; init = n'.init;
       num = n'.num; person = n'.person; s = n'.s ++ a.s ! n'.num ! n'.gend};

    adjoinN'CP : N' -> CP -> N' = \n', cp ->
      {abstractOrMass = n'.abstractOrMass; gend = n'.gend; init = n'.init;
       num = n'.num; person = n'.person;
       s = n'.s ++ cp.s ! n'.num ! n'.person ! n'.gend};   

    mkNP : D -> N' -> NP = \il, gatto -> 
      {gend = gatto.gend; isPronoun = False; null = False; num = gatto.num;
       person = Third; possessive = \\_, _ => nonword; wh = False;
       s = \\_, nm, pr => (il.s ! gatto.abstractOrMass ! gatto.num 
                           ! gatto.gend ! gatto.init) ++ gatto.s};

    npOfProNP : ProNP -> NP = \pronp -> pronp;
    npOfReflexive : Reflexive -> NP = \refl -> refl;
    npOfProperN : ProperN -> NP = \prop -> prop;

    possessive : NP -> N' -> NP = \owner, ownee -> -- TODO handle "di cui"
      {gend = ownee.gend; null = False; num = ownee.num; person = ownee.person;
       isPronoun = False; possessive = \\_, _ => nonword; wh = owner.wh;
       s = case owner.isPronoun of {
         False => \\c, _, _ => 
           definite.s ! ownee.abstractOrMass ! ownee.num ! ownee.gend ! ownee.init
           ++ ownee.s ++ "di" ++ owner.s ! c ! defaultNumber ! defaultPerson;
         True => \\c, _, _ => 
           definite.s ! ownee.abstractOrMass ! ownee.num ! ownee.gend ! Con
           ++ (owner.possessive ! ownee.num ! ownee.gend) ++ ownee.s
           }};

    mkV' : V -> ArgStructure -> V' = \v, args -> 
      {head = v; preSubject = args.preSubject; postSubject = args.postSubject;
       postVerb = args.postVerb; subj = args.subj; wh = args.wh};

    auxBe : VP__ -> V' = \vp ->
      {head = stare; preSubject = vp.preSubject; postSubject = vp.postSubject;
       postVerb = \\nm, pr, gn => vp.head.presPart ++ vp.postVerb ! nm ! pr ! gn;
       subj = vp.subj; wh = vp.wh};

    auxHave : VP__ -> V' = \vp -> 
      {head = case vp.head.aux of {Avere => avere; Essere => essere};
       preSubject = vp.preSubject; postSubject = vp.postSubject;
       postVerb = \\nm, pr, gn => vp.head.pastPart ! nm ! gn 
                                  ++ vp.postVerb ! nm ! pr ! gn;
       subj = vp.subj; wh = vp.wh};

    mkVP__ : V' -> VP__ = \v' -> v';

    mkS : VP -> S = \vp ->
      case vp.wh of {
        False => let subj : NP = vp.subj in
                 {s = vp.s ! subj.num ! subj.person ! subj.gend};
        True => {s = nonword}};

    mkCP : VP -> CP = \vp ->
      case vp.wh of {
        False => {s = \\_, _, _ => nonword; subj = vp.subj; wh = False};
        True => 
          let subj : NP = vp.subj in
          case subj.null of {
            False => {subj = subj; wh = True; 
                      s = \\_, _, _ => vp.s ! subj.num ! subj.person ! subj.gend};                      
            True => vp
          }
      };


    {- FUNCTIONAL WORDS -}


}   
