--# -path=.:../trans:alltenses

abstract Trans = {
  flags startcat = AbsS;
  cat {- Abs stands for Abstract -}
    {- ARGUMENTS -}
    AbsArgType;
    AbsArgStructure AbsArgType;

    {- GRAMMATICAL CATEGORIES -}

    AbsS;

    AbsNP;
    AbsD;
    AbsN';
    AbsN;
      AbsN_; {- Number -}

    AbsVP; 
      AbsVP_; {- Polarity -}
      AbsVP__; {- Tense -}
    AbsV';
    AbsV AbsArgType;
    -- AbsAux;

    -- AbsAdjP;
    -- AbsAdj;

  fun
    {- GRAMMATICAL RULES -}
      MakeS : AbsNP -> AbsVP -> AbsS;
      MakeNP : AbsD -> AbsN' -> AbsNP;
      -- AjnN' : AbsN' -> AbsAdj -> AbsN';
      MakeN' : AbsN -> AbsN';
      MakeVP__ : AbsV' -> AbsVP__;
      MakeV' : (a: AbsArgType) -> AbsV a -> AbsArgStructure a -> AbsV';
      -- AddAux : AbsAux -> AbsVP__ -> AbsV'; -- TODO name
      -- MakeAdjP : AbsAdj -> AbsAdjP;

    {- ARGUMENT TYPES -}
      Intrans : AbsArgType;
      Trans : AbsArgType;
      -- Arg_AdjP : ArgType;  
  
      IntransArg : AbsArgStructure Intrans;
      TransArg : AbsNP -> AbsArgStructure Trans;
      -- MakeArg_AdjP : AbsAdjP -> ArgStructure Arg_AdjP

    {- FEATURE FILLING RULES -}
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
      -- Fast, Tall : AbsAdj;

      {- Determiners -}
      The, A : AbsD;

      {- Nouns -}
      Ball, Boy, Name, Student, Woman : AbsN_;

      {- Verbs -}
      Sleep : AbsV Intrans;
      See, Meet : AbsV Trans;
      -- AuxHave, AuxBe : AbsAux;
}
