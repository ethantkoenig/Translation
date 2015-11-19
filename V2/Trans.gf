--# -path=.:../trans:alltenses

abstract Trans = {
  flags startcat = AbsVP;
  cat {- Abs stands for Abstract -}
    {- ARGUMENTS -}
    AbsArgType;
    AbsArgStructure AbsArgType;

    {- GRAMMATICAL CATEGORIES -}

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

    -- AbsAdjP;
    -- AbsAdj;

  fun
    {- GRAMMATICAL RULES -}
      MakeNP : AbsD -> AbsN' -> AbsNP;
      -- AjnN' : AbsN' -> AbsAdj -> AbsN';
      MakeN' : AbsN -> AbsN';
      MakeVP__ : AbsV' -> AbsVP__;
      MakeV' : (a: AbsArgType) -> AbsV a -> AbsArgStructure a -> AbsV';
      -- MakeAdjP : AbsAdj -> AbsAdjP;

    {- ARGUMENT TYPES -}
      Intrans : AbsArgType;
      Trans : AbsArgType;
      -- Arg_AdjP : ArgType;  
  
      IntransArg : AbsNP -> AbsArgStructure Intrans;
      TransArg : AbsNP -> AbsNP -> AbsArgStructure Trans;
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
      the, a : AbsD;

      {- Nouns -}
      boy, hunger, name, student : AbsN_;

      {- Verbs -}
      sleep : AbsV Intrans;
      see, meet : AbsV Trans;
      -- AuxHave, AuxBe : AbsAux;
}
