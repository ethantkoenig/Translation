instance SyntaxIta of Syntax =
    open MorphIta, Prelude, Utils, UtilsIta in {
  param
    Tense = Pres | Past | Fut | Cond;
    Case = Nom | Acc | Dat;
  oper
    {- TYPES -}
    Adj : Type = {s : Number => Gender => Str};

    {- Bool represents whether the N' is abstractOrMass -}
    D : Type = {s : Bool => Number => Gender => NounInitial => Str};

    N_ : Type = {abstractOrMass : Bool; gend : Gender; init : NounInitial ; s : Number => Str};
    N : Type = N';
    N' : Type = {abstractOrMass : Bool; gend : Gender; num : Number; init : NounInitial; s : Str};
    ProNP : Type = NP;
    Reflexive : Type = NP;
    {- the possesive field is ignored for non-pronoun NPs
     - the (Number => Person) in the type of s are to account for 
     - reflexive pronouns, where they should be the Number and Person of the 
     - subject NP. For all other NPs, any values can be given -}
    NP : Type = {gend : Gender; num : Number; person : Person;
                 s : Case => Number => Person => Str;
                 isPronoun : Bool; possessive : Number => Gender => Str}; -- TODO better way of handling possessive

    V : Type = {aux : Aux; inf : Str; presPart : Str;
                pastPart : Number => Gender => Str;
                conj : Tense => Number => Person => Str};
    V' : Type = {head : V; subj : NP; preface : Str; postface : Str};
    VP__ : Type = V';
    VP_ : Type = {tense : Tense; head : V; subj : NP;
                  preface : Str; postface : Str};
    VP : Type = {s : Str};

    ArgStructure : Type = {subj : NP; preface : Str; postface : Str};

    {- ARGUMENT FUNCTIONS -}
    mkArgVoid : NP -> ArgStructure =
      \sb -> {subj = sb; preface = ""; postface = ""};

    mkArgNP : NP -> NP -> ArgStructure = \sb, obj -> 
      case obj.isPronoun of {
        False => {subj = sb; preface = "";
                  postface = obj.s ! Acc ! sb.num ! sb.person};
        True => {subj = sb; preface = obj.s ! Acc ! sb.num ! sb.person;
                 postface = ""}};

    mkArgAdj : NP -> Adj -> ArgStructure =
      \sb, ad -> {subj = sb; preface = ""; postface = ad.s ! sb.num ! sb.gend};

    {- LEXICAL FUNCTIONS -}
      {- NOUNS -}
    _constructN_ : (abstractOrMass : Bool) -> (gnd : Gender)
                   -> (uomo, uomini : Str) -> N_ =
      \abstractOrMass, gnd, uomo, uomini -> 
        {abstractOrMass = abstractOrMass; gend = gnd; init = nounInitial uomo;
         s = table {Sg => uomo; Pl => uomini}};

    mkN_ = overload {
      mkN_ : (gatto : Str) -> N_ =
        \gatto -> _constructN_ False (inferGender gatto) gatto (pluralize gatto);

      mkN_ : (abstractOrMass : Bool) -> (gatto : Str) -> N_ =
        \abstractOrMass, gatto -> _constructN_ abstractOrMass (inferGender gatto)
                                               gatto (pluralize gatto);

      mkN_ : (abstractOrMass : Bool) -> (gnd : Gender) -> (gatto : Str) -> N_ =
        \abstractOrMass, gnd, gatto -> _constructN_ abstractOrMass gnd gatto
                                                    (pluralize gatto);

      mkN_ : (abstractOrMass : Bool) -> (gnd : Gender) 
             -> (uomo, uomini : Str) -> N_ = _constructN_;
    };

    _mkProNP : (gend : Gender) -> (num : Number) -> (person : Person)
               -> (lui, lo, gli, si, suo, sua, suoi, sue : Str) -> ProNP = -- TODO useless argument si
      \gend, num, person, lui, lo, gli, si, suo, sua, suoi, sue ->
        {gend = gend; num = num; person = person; isPronoun = True;
         s = table {Nom => \\_, _ => lui; Acc => \\_, _ => lo; Dat => \\_, _ => gli};
         isPronoun = True;
         possessive = table {Sg => table {Masc => suo; Fem => sua};
                             Pl => table {Masc => suoi; Fem => sue}}};

      {- VERBS -}
    _constructV : (aux : Aux) -> (avere, avendo, avuto : Str)
              -> (presConj : Number => Person => Str) -> (av : Str) -> V =
        \aux, avere, avendo, avuto, presConj, av ->
          let futConj : Number => Person => Str = futureConjugate av in
          let condConj : Number => Person => Str = condConjugate av in
          {aux = aux;
           inf = avere; presPart = avendo; pastPart = pastParticiples aux avuto;
           conj = table {Pres => presConj; Fut => futConj;
                         Cond => condConj; Past => \\_, _ => nonword}};

    mkV = overload {
      mkV : (aux : Aux) -> (mangiare : Str) -> V =
        \aux, mangiare -> let pres : Str = presParticiple mangiare in
                          let past : Str = pastParticiple mangiare in
                          let presConj : Number => Person => Str = presConjugate mangiare in
                          let stm : Str = stem mangiare in
                          _constructV aux mangiare pres past presConj stm;

      mkV : (aux : Aux) -> (prendere, preso : Str) -> V =
        \aux, prendere, preso ->
          let presPart : Str = presParticiple prendere in
          let presConj : Number => Person => Str = presConjugate prendere in
          let stm : Str = stem prendere in
          _constructV aux prendere presPart preso presConj stm;

      mkV : (aux : Aux) -> (avere, avendo, avuto, ho, hai,
                            ha, abbiamo, avete, hanno, av : Str) -> V =
        \aux, avere, avendo, avuto, ho, hai, ha, abbiamo, avete, hanno, av ->
          let presConj : Number => Person => Str =
            table {Sg => table {First => ho; Second => hai; Third => ha};
                   Pl => table {First => abbiamo; Second => avete; Third => hanno}} in
          _constructV aux avere avendo avuto presConj av;
    };


    mkAdj : (rapido : Str) -> Adj =
      \rapido -> {s = adjectiveForms rapido};


    {- FEATURE FUNCTIONS -}


    {-
    nonreflexive : ProNP -> NP = \pr -> pr;

    reflexive : ProNP -> NP =
      \pr -> {gend = pr.gend; num = pr.num; person = pr.person;
              s = table {Nom => nonword; Acc => pr.s ! Ref; c => pr.s ! c}};
    -}

    reflexive : Reflexive =
      {gend = Masc; num = Sg; person = Third; 
       isPronoun = True; possessive = \\_, _ => nonword;
       s = table {
             Acc => table {
               Sg => table {First => "mi"; Second => "ti"; Third => "si"};
               Pl => table {First => "ci"; Second => "vi"; Third => "si"}};
             Nom | Dat => \\_, _ => nonword}};

    singular : N_ -> N =
      \gatto -> {abstractOrMass = gatto.abstractOrMass; gend = gatto.gend;
                 init = gatto.init; num = Sg; s = gatto.s ! Sg};

    plural : N_ -> N =
      \gatto -> {abstractOrMass = gatto.abstractOrMass; gend = gatto.gend;
                 init = gatto.init; num = Pl; s = gatto.s ! Pl};

    present : VP__ -> VP_ =
      \vp -> {tense = Pres; subj = vp.subj; preface = vp.preface;
              head = vp.head; postface = vp.postface};

    past : VP__ -> VP_ =
      \vp -> {tense = Pres; subj = vp.subj; preface = vp.preface;
              head = case vp.head.aux of {Avere => avere; Essere => essere};
              postface = vp.head.pastPart ! vp.subj.num ! vp.subj.gend ++ vp.postface};

    future : VP__ -> VP_ =
      \vp -> {tense = Fut; subj = vp.subj; preface = vp.preface;
              head = vp.head; postface = vp.postface};

    cond : VP__ -> VP_ =
      \vp -> {tense = Cond; subj = vp.subj; preface = vp.preface;
              head = vp.head; postface = vp.postface};

    positive : VP_ -> VP =
      \vp -> let subj : NP = vp.subj in
             {s = subj.s ! Nom ! subj.num ! subj.person ++ vp.preface -- TODO deafult values
                  ++ vp.head.conj ! vp.tense ! subj.num ! subj.person
                  ++ vp.postface};

    negative : VP_ -> VP =
      \vp -> let subj : NP = vp.subj in
             {s = subj.s ! Nom ! subj.num ! subj.person ++ "non" ++ vp.preface
                  ++ vp.head.conj ! vp.tense ! subj.num ! subj.person
                  ++ vp.postface};

    {- GRAMMATICAL FUNCTIONS -}
    mkN' : N -> N' = \n -> n;

    -- TODO handle preceding adjectives
    adjN' : N' -> Adj -> N' =
      \n, a -> {abstractOrMass = n.abstractOrMass; gend = n.gend; init = n.init;
                num = n.num; s = n.s ++ a.s ! n.num ! n.gend};

    mkNP : D -> N' -> NP = \il, gatto -> 
      {gend = gatto.gend; num = gatto.num; person = Third;
       s = \\_, _, _ => (il.s ! gatto.abstractOrMass ! gatto.num 
                                 ! gatto.gend ! gatto.init) ++ gatto.s;
       isPronoun = False; possessive = \\_, _ => nonword};

    npOfProNP : ProNP -> NP = \pronp -> pronp;

    npOfReflexive : Reflexive -> NP = \refl -> refl;

    possessive : NP -> N' -> NP = \owner, ownee ->
      {gend = ownee.gend; num = ownee.num; person = Third;
       s = case owner.isPronoun of {
         False => \\c, _, _ => 
           definite.s ! ownee.abstractOrMass ! ownee.num ! ownee.gend ! ownee.init
           ++ ownee.s ++ "di" ++ owner.s ! c ! owner.num ! owner.person; -- TODO use default talbe arguments for clarity
         True => \\c, _, _ => 
           definite.s ! ownee.abstractOrMass ! ownee.num ! ownee.gend ! Con
           ++ (owner.possessive ! ownee.num ! ownee.gend) ++ ownee.s
           };
       isPronoun = False; possessive = \\_, _ => nonword};

    mkV' : V -> ArgStructure -> V' =
      \v, args -> {head = v; subj = args.subj;
                   preface = args.preface; postface = args.postface};

    auxBe : VP__ -> V' =
      \vp -> {head = stare; subj = vp.subj; preface = vp.preface;
              postface = vp.head.presPart ++ vp.postface};

    auxHave : VP__ -> V' =
      \vp -> {head = case vp.head.aux of {Avere => avere; Essere => essere};
              subj = vp.subj; preface = vp.preface;
              postface = vp.head.pastPart ! vp.subj.num ! vp.subj.gend ++ vp.postface};

    mkVP__ : V' -> VP__ = \v' -> v';

    {- FUNCTIONAL WORDS -}

    definite : D = 
      {s = \\_ => table {
            Sg => table {
                    Masc => table {Con => "il"; Vow => "l'"; Complex => "lo"};
                    Fem => table {Con | Complex => "la"; Vow => "l'"}};
            Pl => table {
                    Masc => table {Con => "i"; Vow | Complex => "gli"};
                    Fem => table {_ => "le"}}}};

    indefinite : D = 
      {s = \\_ => table {
            Sg => table {
                    Masc => table {Con => "un"; Vow => "un'"; Complex => "uno"};
                    Fem => table {Con | Complex => "una"; Vow => "un'"}};
            Pl => \\_, _ => nonword}};

    voidD : D = 
      {s = table {
             False => table {Sg => \\_, _ => nonword; Pl => \\_, _ => ""};
             True => \\_, _, _ => ""}};

    

    i : ProNP = _mkProNP Masc Sg First "" "mi" "mi" "mi" "mio" "mia" "miei" "mie";
    you : ProNP = _mkProNP Masc Sg Second "" "ti" "ti" "ti" "tuo" "tua" "tuoi" "tue";
    he : ProNP = _mkProNP Masc Sg Third "" "lo" "gli" "si" "suo" "sua" "suoi" "sue";
    she : ProNP = _mkProNP Fem Sg Third "" "la" "le" "si" "suo" "sua" "suoi" "sue";
    we : ProNP = _mkProNP Masc Pl First "" "ci" "ci" "ci" "nostro" "nostra" "nostri" "nostre";
    yall : ProNP = _mkProNP Masc Pl Second "" "vi" "vi" "vi" "vostro" "vostra" "vostri" "vostre";
    they : ProNP = _mkProNP Masc Pl Third "" "li" "loro" "si" "loro" "loro" "loro" "loro";

    proNPofNP : ProNP -> NP = \np -> 
      case np.num of {
        Sg => case np.person of {
                First => i; Second => you;
                Third => case np.gend of { Masc => he; Fem => she}};
        Pl => case np.person of {
                First => we; Second => yall; Third => they}};

    essere : V = mkV Essere "essere" "essendo" "stato" "sono" "sei" "e'"
                              "siamo" "siete" "sono" "sa";

    avere : V = mkV Avere "avere" "avendo" "avuto" "ho" "hai" "ha" "abbiamo"
                            "avete" "hanno" "av";

    stare : V = mkV Essere "stare" "stando" "stato" "sto" "stai" "sta" "stiamo"
                           "state" "stanno" "sta";

}   
