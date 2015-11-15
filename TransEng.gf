--# -path=.:../trans:alltenses

concrete TransEng of Trans = open ResEng in {
  param
    ArgType = In | Tr;
  lincat
    AbsArgType = {at : ArgType};
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
    AbsAux = Aux;
  lin
    {- GRAMMATICAL RULES -}
    MakeS = mkS;
    MakeNP = mkNP;
    MakeN' = mkN';
    MakeVP__ = mkVP__;
    MakeV' _ v args = mkV' v args;
    AddAux = addAux;
    
    {- ARGUMENT TYPES -}
    Intrans = {at = In};
    Trans = {at = Tr};

    IntransArg = mkArg_;
    TransArg = mkArg_NP;

    {- FEATURE FILLING RULES -}
    Singular = singular;
    Plural = plural;
    Positive = positive;
    Negative = negative;
    Present = present;
    Past = past;    

    {- LEXICAL RULES -}
    A = a;
    The = the;

    Ball = mkN_ "ball";
    Boy = mkN_ "boy";
    Name = mkN_ "name";
    Student = mkN_ "student";  
    Woman = mkN_ "woman" "women";

    Sleep = mkV "sleep";
    See = mkV "see" "seeing" "seen" "see" "see" "sees" "saw" "saw";
    Meet = mkV "meet" "met";

    AuxHave = have;
    AuxBe = be;
}
  
