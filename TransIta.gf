concrete TransIta of Trans = open ResIta, MorphIta in { -- TODO ideally would not open MorphIta
  param 
    ArgType = In | Tr;
  lincat
    AbsArgType = {a : ArgType};
    AbsArgStructure = ArgStructure;

    AbsS = S;
    AbsNP = NP;
    AbsD = D;
    AbsN' = N';
    AbsN = N;
    AbsN_ = N_;
    AbsVP = VP;
    AbsVP_ = VP_;
    AbsVP__ = VP__;
    AbsV' = V';
    AbsV = V;
    -- AbsAux = Aux;   

  lin
    {- GRAMMATICAL RULES -}
    MakeS = mkS;
    MakeNP = mkNP;
    MakeN' = mkN';
    MakeVP__ = mkVP__;
    MakeV' _ v args = mkV' v args;
    -- AddAux = addAux;

    {- ARGUMENT TYPES -}
    Intrans = {a = In};
    Trans = {a = Tr};

    IntransArg = mkArg_;
    TransArg = mkArg_NP;

    {- FEATURE FILLING RULES -}
    Singular = singular;
    Plural = plural;
    Positive = positive;
    Negative = negative;
    Present = present;
    Past = past; 
    Future = future;
    Cond = cond;
    AuxBe = auxBe;
    AuxHave = auxHave;

    {- LEXICAL RULES -}
    A = indDet;
    The = defDet;

    Ball = mkN_ "palla";
    Boy = mkN_ "ragazzo";
    Name = mkN_ "name";
    Student = mkN_ "studente";
    Woman = mkN_ "donna";

    Sleep = mkV Avere "dormire";
    See = mkV Avere "vedere";
    Meet = mkV Avere "incontrare";

}
