instance SyntaxIta of Syntax =
    open LexemeIta, {- MorphIta, -} Prelude, TypesIta, Utils, UtilsIta in {
  oper
    
    {- ARGUMENT FUNCTIONS -}
    _nonArgStructure : (sb : NP) -> ArgStructure = \sb ->
      {null = True; preface = \\_, _ => nonword;
       postface = \\_, _, _ => nonword; subj = sb};

    mkArgVoid : NP -> ArgStructure = \sb -> 
     {null = sb.null; preface = \\_, _ => ""; postface = \\_, _, _ => "";
      subj = sb};

    mkArgNP : NP -> NP -> ArgStructure = \sb, obj -> 
      case and sb.null obj.null of {
        False => 
          let null : Bool = or sb.null obj.null in
          case obj.isPronoun of {
            False => {null = null; preface = \\_, _ => "";
                      postface = \\nm, pr, gn => obj.s ! Acc ! nm ! pr;
                      subj = sb};
            True => {null = null; preface = obj.s ! Acc;
                     postface = \\_, _, _ => ""; subj = sb}};
        True => _nonArgStructure sb};

    mkArgAdj : NP -> Adj -> ArgStructure =
      \sb, ad -> {null = sb.null; preface = \\_, _ => ""; 
                  postface = \\nm, pr, gn => ad.s ! nm ! gn; subj = sb};

    mkArgNPNP : NP -> NP -> NP -> ArgStructure = \sb, obj1, obj2 -> 
      case two sb.null obj1.null obj2.null of {
        False => 
          let null : Bool = or sb.null (or obj1.null obj2.null) in
          case obj1.isPronoun of { -- TODO handle obj2 pronoun
            False => {null = null; preface = \\_, _ => "";
                      postface = \\nm, pr, gn => obj1.s ! Acc ! nm ! pr 
                                                 ++ obj2.s ! Acc ! nm ! pr;
                      subj = sb};
            True => {null = null; preface = obj1.s ! Acc;
                     postface = \\nm, pr, gn => obj2.s ! Acc ! nm ! pr;
                     subj = sb}};
        True => _nonArgStructure sb};
  

    singular : N_ -> N = \gatto -> 
      {abstractOrMass = gatto.abstractOrMass; gend = gatto.gend;
       init = gatto.init; num = Sg; person = Third; s = gatto.s ! Sg};

    plural : N_ -> N = \gatto -> 
      {abstractOrMass = gatto.abstractOrMass; gend = gatto.gend;
       init = gatto.init; num = Pl; person = Third; s = gatto.s ! Pl};

    present : VP__ -> VP_ = \vp -> 
      {head = vp.head; null = vp.null; preface = vp.preface;
       postface = vp.postface; subj = vp.subj; tense = Pres};

    past : VP__ -> VP_ = \vp -> 
      {head = case vp.head.aux of {Avere => avere; Essere => essere};
       null = vp.null; preface = vp.preface;
       postface = \\nm, pr, gn => vp.head.pastPart ! nm ! gn ++ vp.postface ! nm ! pr ! gn;
       subj = vp.subj; tense = Pres};

    future : VP__ -> VP_ = \vp -> 
      {head = vp.head; null = vp.null; preface = vp.preface;
       postface = vp.postface; subj = vp.subj; tense = Fut};

    cond : VP__ -> VP_ = \vp -> 
      {head = vp.head; null = vp.null; preface = vp.preface;
       postface = vp.postface; subj = vp.subj; tense = Cond};

    positive : VP_ -> VP = \vp -> 
      {null = vp.null;
       s = \\nm, pr, gn => vp.subj.s ! Nom ! nm ! pr ++ vp.preface ! nm ! pr
                              ++ vp.head.conj ! vp.tense ! nm ! pr
                              ++ vp.postface ! nm ! pr ! gn;
       subj = vp.subj};

    negative : VP_ -> VP = \vp -> 
      {null = vp.null;
       s = \\nm, pr, gn => vp.subj.s ! Nom ! nm ! pr  ++ "non" 
                              ++ vp.preface ! nm ! pr
                              ++ vp.head.conj ! vp.tense ! nm ! pr
                              ++ vp.postface ! nm ! pr ! gn;
       subj = vp.subj};

    {- GRAMMATICAL FUNCTIONS -}
    mkN' : N -> N' = \n -> n;

    -- TODO handle preceding adjectives
    adjoinN'Adj : N' -> Adj -> N' = \n', a -> 
      {abstractOrMass = n'.abstractOrMass; gend = n'.gend; init = n'.init;
       num = n'.num; person = n'.person; s = n'.s ++ a.s ! n'.num ! n'.gend};

    adjoinN'CP : N' -> CP -> N' = \n', cp ->
      {abstractOrMass = n'.abstractOrMass; gend = n'.gend; init = n'.init;
       num = n'.num; person = n'.person;
       s = n'.s ++ "che" ++ cp.s ! n'.num ! n'.person ! n'.gend};   

    mkNP : D -> N' -> NP = \il, gatto -> 
      {gend = gatto.gend; isPronoun = False; null = False; num = gatto.num;
       person = Third; possessive = \\_, _ => nonword;
       s = \\_, nm, pr => (il.s ! gatto.abstractOrMass ! gatto.num 
                           ! gatto.gend ! gatto.init) ++ gatto.s};

    npOfProNP : ProNP -> NP = \pronp -> pronp;
    npOfReflexive : Reflexive -> NP = \refl -> refl;
    npOfProperN : ProperN -> NP = \prop -> prop;

    possessive : NP -> N' -> NP = \owner, ownee -> -- TODO handle "di cui"
      {gend = ownee.gend; null = False; num = ownee.num; person = ownee.person;
       s = case owner.isPronoun of {
         False => \\c, _, _ => 
           definite.s ! ownee.abstractOrMass ! ownee.num ! ownee.gend ! ownee.init
           ++ ownee.s ++ "di" ++ owner.s ! c ! defaultNumber ! defaultPerson;
         True => \\c, _, _ => 
           definite.s ! ownee.abstractOrMass ! ownee.num ! ownee.gend ! Con
           ++ (owner.possessive ! ownee.num ! ownee.gend) ++ ownee.s
           };
       isPronoun = False; possessive = \\_, _ => nonword};

    mkV' : V -> ArgStructure -> V' = \v, args -> 
      {head = v; null = args.null; preface = args.preface;
       postface = args.postface; subj = args.subj};

    auxBe : VP__ -> V' = \vp ->
      {head = stare; null = vp.null; preface = vp.preface;
       postface = \\nm, pr, gn => vp.head.presPart ++ vp.postface ! nm ! pr ! gn;
       subj = vp.subj};

    auxHave : VP__ -> V' = \vp -> 
      {head = case vp.head.aux of {Avere => avere; Essere => essere};
       null = vp.null; preface = vp.preface;
       postface = \\nm, pr, gn => vp.head.pastPart ! nm ! gn ++ vp.postface ! nm ! pr ! gn;
       subj = vp.subj};

    mkVP__ : V' -> VP__ = \v' -> v';

    mkS : VP -> S = \vp ->
      case vp.null of {
        False => let subj : NP = vp.subj in
                 {s = vp.s ! subj.num ! subj.person ! subj.gend};
        True => {s = nonword}};

    mkCP : VP -> CP = \vp ->
      case vp.null of {
        False => {null = False; s = \\_, _, _ => nonword; subj = vp.subj};
        True => vp};

    {- FUNCTIONAL WORDS -}


}   
