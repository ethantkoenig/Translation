instance SyntaxIta of Syntax =
    open MorphIta, Prelude, Utils, UtilsIta in {
  param
    Tense = Pres | Past | Fut | Cond;
    Case = Nom | Acc | Dat | Ref;
  oper
    {- TYPES -}
    Adj : Type = {s : Number => Gender => Str};

    D : Type = {s : Number => Gender => NounInitial => Str};

    N_ : Type = {gend : Gender; init : NounInitial ; s : Number => Str};
    N : Type = N';
    N' : Type = {gend : Gender; num : Number; init : NounInitial; s : Str};
    ProNP : Type = NP;
    {- the possesive field is ignored for non-pronoun NPs -}
    NP : Type = {gend : Gender; num : Number; person : Person;
                 s : Case => Str; isPronoun : Bool;
                 possessive : Number => Gender => Str};

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

    mkArgNP : NP -> NP -> ArgStructure =
      \sb, np -> case np.isPronoun of {
                   False => {subj = sb; preface = ""; postface = np.s ! Acc};
                   True => {subj = sb; preface = np.s ! Acc; postface = ""}
                 };

    mkArgAdj : NP -> Adj -> ArgStructure =
      \sb, ad -> {subj = sb; preface = ""; postface = ad.s ! sb.num ! sb.gend};

    {- LEXICAL FUNCTIONS -}
      {- NOUNS -}
    _constructN_ : (gnd : Gender) -> (uomo, uomini : Str) -> N_ =
      \gnd, uomo, uomini -> {gend = gnd; init = nounInitial uomo;
                             s = table {Sg => uomo; Pl => uomini}};

    mkN_ = overload {
      mkN_ : (gatto : Str) -> N_ =
        \gatto -> _constructN_ (inferGender gatto) gatto (pluralize gatto);

      mkN_ : (gnd : Gender) -> (gatto : Str) -> N_ =
        \gnd, gatto -> _constructN_ gnd gatto (pluralize gatto);

      mkN_ : (gnd : Gender) -> (uomo, uomini : Str) -> N_ = _constructN_;
    };

    _mkProNP : (gend : Gender) -> (num : Number) -> (person : Person)
               -> (lui, lo, gli, si, suo, sua, suoi, sue : Str) -> ProNP =
      \gend, num, person, lui, lo, gli, si, suo, sua, suoi, sue ->
        {gend = gend; num = num; person = person; isPronoun = True;
         s = table {Nom => lui; Acc => lo; Dat => gli; Ref => si};
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
                         Cond => condConj; Past => \\_, _ => ""}};

    mkV = overload {
      mkV : (aux : Aux) -> (mangiare : Str) -> V =
        \aux, mangiare -> let pres : Str = presParticiple mangiare in
                        let past : Str = pastParticiple mangiare in
                        let presConj : Number => Person => Str = presConjugate mangiare in
                        let stm : Str = stem mangiare in
                        _constructV aux mangiare pres past presConj stm;

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

    singular : N_ -> N =
      \gatto -> {gend = gatto.gend; init = gatto.init;
                 num = Sg; s = gatto.s ! Sg};

    plural : N_ -> N =
      \gatto -> {gend = gatto.gend; init = gatto.init;
                 num = Pl; s = gatto.s ! Pl};

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
             {s = subj.s ! Nom ++ vp.preface
                  ++ vp.head.conj ! vp.tense ! subj.num ! subj.person
                  ++ vp.postface};

    negative : VP_ -> VP =
      \vp -> let subj : NP = vp.subj in
             {s = subj.s ! Nom ++ "non" ++ vp.preface
                  ++ vp.head.conj ! vp.tense ! subj.num ! subj.person
                  ++ vp.postface};

    {- GRAMMATICAL FUNCTIONS -}
    mkN' : N -> N' = \n -> n;

    -- TODO handle preceding adjectives
    adjN' : N' -> Adj -> N' =
      \n, a -> {gend = n.gend; init = n.init; num = n.num;
                s = n.s ++ a.s ! n.num ! n.gend};

    mkNP : D -> N' -> NP =
      \il, gatto -> {gend = gatto.gend; num = gatto.num; person = Third;
                     s = \\_ => (il.s ! gatto.num ! gatto.gend ! gatto.init) ++ gatto.s;
                     isPronoun = False; possessive = \\_, _ => nonword};

    npOfProNP : ProNP -> NP = \pronp -> pronp;

    possessive : NP -> N' -> NP =
      \owner, ownee ->
        {gend = ownee.gend; num = ownee.num; person = Third;
         s = case owner.isPronoun of {
               False => \\c => (definite.s ! ownee.num ! ownee.gend ! ownee.init)
                               ++ ownee.s ++ "di" ++ owner.s ! c;
               True => \\c => (definite.s ! ownee.num ! ownee.gend ! Con)
                              ++ (owner.possessive ! ownee.num ! ownee.gend)
                              ++ ownee.s
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

    definite : D = {s = table {
                        Sg => table {
                                Masc => table {Con => "il"; Vow => "l'"; Complex => "lo"};
                                Fem => table {Con | Complex => "la"; Vow => "l'"}};
                        Pl => table {
                                Masc => table {Con => "i"; Vow | Complex => "gli"};
                                Fem => table {_ => "le"}}}};

    indefinite : D = {s = table {
                        Sg => table {
                                Masc => table {Con => "un"; Vow => "un'"; Complex => "uno"};
                                Fem => table {Con | Complex => "una"; Vow => "un'"}};
                        Pl => table { -- TODO plural indefinite case
                                Masc => table {Con => "dei"; Vow | Complex => "degli"};
                                Fem => table {_ => "delle"}}}};

    voidD : D = {s = \\_, _, _ => ""};

    i : ProNP = _mkProNP Masc Sg First "" "mi" "mi" "mi" "mio" "mia" "miei" "mie";
    you : ProNP = _mkProNP Masc Sg Second "" "ti" "ti" "ti" "tuo" "tua" "tuoi" "tue";
    he : ProNP = _mkProNP Masc Sg Third "" "lo" "gli" "si" "suo" "sua" "suoi" "sue";
    she : ProNP = _mkProNP Fem Sg Third "" "la" "le" "si" "suo" "sua" "suoi" "sue";
    we : ProNP = _mkProNP Masc Pl First "" "ci" "ci" "ci" "nostro" "nostra" "nostri" "nostre";
    yall : ProNP = _mkProNP Masc Pl Second "" "vi" "vi" "vi" "vostro" "vostra" "vostri" "vostre";
    they : ProNP = _mkProNP Masc Pl Third "" "li" "loro" "si" "loro" "loro" "loro" "loro";

    essere : V = mkV Essere "essere" "essendo" "stato" "sono" "sei" "e'"
                              "siamo" "siete" "sono" "sa";

    avere : V = mkV Avere "avere" "avendo" "avuto" "ho" "hai" "ha" "abbiamo"
                            "avete" "hanno" "av";

    stare : V = mkV Essere "stare" "stando" "stato" "sto" "stai" "sta" "stiamo"
                           "state" "stanno" "sta";

}   
