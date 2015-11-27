--# -path=.:../trans:alltenses

abstract Trans = {
  flags startcat = AbsS;
  cat {- Abs stands for Abstract -}
    {- ARGUMENTS -}
    AbsArgType;
    AbsArgStructure AbsArgType;

    {- GRAMMATICAL CATEGORIES -}
    AbsCP;

    AbsD;

    AbsNP;
    AbsProNP;
    AbsReflexive;
    AbsProperN;
    AbsN';
    AbsN;
      AbsN_; {- Number -}

    AbsS;

    AbsVP; 
      AbsVP_; {- Polarity -}
      AbsVP__; {- Tense -}
    AbsV';
    AbsV AbsArgType;

    -- AbsAdjP;
    AbsAdj;

  fun
    {- GRAMMATICAL RULES -}
      MakeNP : AbsD -> AbsN' -> AbsNP;
      NPofProNP : AbsProNP -> AbsNP;
      NPofReflexive : AbsReflexive -> AbsNP;
      NPofProperN : AbsProperN -> AbsNP;
      Possessive : AbsNP -> AbsN' -> AbsNP;
      AdjoinN'Adj : AbsN' -> AbsAdj -> AbsN';
      AdjoinN'CP : AbsN' -> AbsCP -> AbsN';
      MakeN' : AbsN -> AbsN';
      MakeVP__ : AbsV' -> AbsVP__;
      MakeV' : (a: AbsArgType) -> AbsV a -> AbsArgStructure a -> AbsV';
      -- MakeAdjP : AbsAdj -> AbsAdjP;
  
      MakeS : AbsVP -> AbsS;
      MakeCP : AbsVP -> AbsCP;

    {- ARGUMENT TYPES -}
      ArgVoid : AbsArgType;
      ArgNP : AbsArgType;
      ArgAdj : AbsArgType;  
      ArgNPNP : AbsArgType;
  
      MakeArgVoid : AbsNP -> AbsArgStructure ArgVoid;
      MakeArgNP : AbsNP -> AbsNP -> AbsArgStructure ArgNP;
      MakeArgAdj : AbsNP -> AbsAdj -> AbsArgStructure ArgAdj;
      MakeArgNPNP : AbsNP -> AbsNP -> AbsNP -> AbsArgStructure ArgNPNP;


    {- FEATURE FILLING RULES -}
      Self : AbsReflexive; 
      NullNP : AbsNP;

      Singular : AbsN_ -> AbsN;
      Plural : AbsN_ -> AbsN;
      Positive : AbsVP_ -> AbsVP;
      Negative : AbsVP_ -> AbsVP;
      Present : AbsVP__ -> AbsVP_;
      Past : AbsVP__ -> AbsVP_;
      Future : AbsVP__ -> AbsVP_;
      Cond : AbsVP__ -> AbsVP_;
    
      AuxBe : AbsVP__ -> AbsV';
      AuxHave : AbsVP__ -> AbsV';

    {- LEXICAL RULES -}
      {- Adjectives -}
      Fast, Hungry, Tall : AbsAdj;

      {- Determiners -}
      A, The, VoidD : AbsD;

      {- Nouns -}
      Boy, Dog, Hunger, Name, Picture, Student, Woman : AbsN_;

      I, You, He, She, We, Yall, They : AbsProNP;
      Alice, Bob, Eve, Joe : AbsProperN;

      {- Verbs -}
      Sleep : AbsV ArgVoid;
      BeNP, CallSomeone, Do, Have, Meet, Take, See : AbsV ArgNP;
      BeAdj : AbsV ArgAdj;
      CallSomeoneSomething : AbsV ArgNPNP;
}
