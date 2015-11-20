incomplete concrete TransI of Trans = 
    open Syntax, Lexicon in {
  param
    ArgType = ArVoid | ArNP | ArAdj;
  lincat
    AbsArgType = {a : ArgType};
    AbsArgStructure = ArgStructure;
  
    AbsAdj = Adj;
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
  lin
    MakeNP = mkNP;
    MakeN' = mkN';
    AdjoinN' = adjN';
    MakeVP__ = mkVP__;
    MakeV' _ v args = mkV' v args;

    ArgVoid = {a = ArVoid};
    ArgNP = {a = ArNP};
    ArgAdj = {a = ArAdj};

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

    MakeArgVoid = mkArgVoid;
    MakeArgNP = mkArgNP;
    MakeArgAdj = mkArgAdj;

    Fast = fast;
    Hungry = hungry;
    Tall = tall;

    A = indefinite;
    The = definite;
    VoidD = voidD;
  
    Boy = boy;
    Hunger = hunger;
    Name = name;
    Student = student;

    Be = be;
    Have = have;
    Meet = meet;
    See = see;
    Sleep = sleep;
}
