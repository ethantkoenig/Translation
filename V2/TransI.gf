incomplete concrete TransI of Trans = 
    open Concepts, Syntax, Lexicon in {
  param
    ArgType = In | Tr;
  lincat
    AbsArgType = {a : ArgType};
    AbsArgStructure = ArgStructure;
  
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
    MakeVP__ = mkVP__;
    MakeV' _ v args = mkV' v args;

    Intrans = {a = In};
    Trans = {a = Tr};

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

    IntransArg = mkArg_;
    TransArg = mkArg_NP;

    a = detLexicon ! A;
    the = detLexicon ! The;
  
    boy = nounLexicon ! Boy;
    hunger = nounLexicon ! Hunger;
    name = nounLexicon ! Name;
    student = nounLexicon ! Student;

    sleep = verbLexicon ! Sleep;
    see = verbLexicon ! See;
    meet = verbLexicon ! Meet;
}
