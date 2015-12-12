--# -path=.:../trans:alltenses

abstract Trans = {
  flags startcat = AbsS;
  cat {- Abs stands for Abstract -}
    {- ARGUMENTS -}
    AbsArgType;
    AbsArgStructure AbsArgType;

    {- GRAMMATICAL CATEGORIES -}
    AbsAdj;

    AbsCP;

    AbsD;

    AbsNP;
    AbsProNP;
    AbsReflexive;
    AbsProperN;
    AbsN';
    AbsN;
      AbsN_; {- missing Number -}

    AbsPP;
    AbsP;

    AbsS_; {- Declarative vs. Interrogative -}
    AbsS;

    AbsVP; 
      AbsVP_; {- missing Polarity -}
      AbsVP__; {- missing Polarity, Tense -}
    AbsV';
    AbsV AbsArgType;

  fun
    {- GRAMMATICAL RULES -}
      MakeCP : AbsVP -> AbsCP;

      MakeNP : AbsD -> AbsN' -> AbsNP;
      NPofProNP : AbsProNP -> AbsNP;
      NPofReflexive : AbsReflexive -> AbsNP;
      NPofProperN : AbsProperN -> AbsNP;
      Possessive : AbsNP -> AbsN' -> AbsNP;
      AdjoinN'Adj : AbsN' -> AbsAdj -> AbsN';
      AdjoinN'CP : AbsN' -> AbsCP -> AbsN';
      AdjoinN'PP : AbsN' -> AbsPP -> AbsN';
      MakeN' : AbsN -> AbsN';

      MakePP : AbsP -> AbsNP -> AbsPP;

      MakeS_ : AbsVP -> AbsS_;

      MakeVP__ : AbsV' -> AbsVP__;
      MakeV' : (a : AbsArgType) -> AbsV a -> AbsArgStructure a -> AbsV';
      AdjoinV'PP : AbsV' -> AbsPP -> AbsV';

    {- ARGUMENT TYPES -}
      ArgVoid, ArgNP, ArgAdj, ArgNPNP : AbsArgType;
  
      MakeArgVoid : AbsNP -> AbsArgStructure ArgVoid;
      MakeArgNP : AbsNP -> AbsNP -> AbsArgStructure ArgNP;
      MakeArgAdj : AbsNP -> AbsAdj -> AbsArgStructure ArgAdj;
      MakeArgNPNP : AbsNP -> AbsNP -> AbsNP -> AbsArgStructure ArgNPNP;


    {- FEATURE FILLING RULES -}
      Self : AbsReflexive; 
      NullNP : AbsNP;

      Singular, Plural : AbsN_ -> AbsN;
  
      Declarative, Interrogative : AbsS_ -> AbsS;

      Positive, Negative : AbsVP_ -> AbsVP;
      Present, Past, Future, Cond : AbsVP__ -> AbsVP_;
    
      AuxBe, AuxHave : AbsVP__ -> AbsVP__;

    {- LEXICAL RULES -}
      {- Adjectives -}
      Fast, Happy, Hungry, Tall : AbsAdj;

      {- Determiners -}
      A, The, VoidD : AbsD;

      {- Nouns -}
      Boy, Dog, Elephant, Hunger, Map, Name,
      Picture, Promise, Student, Woman       : AbsN_;

      {- Pronouns -}
      I, You, He, She, We, Yall, They : AbsProNP;

      {- Proper Names -}
      Alice, Bob, Emma, Joe : AbsProperN;

      {- Prepositions -}
      Under, With : AbsP;

      {- Verbs -}
      Sleep : AbsV ArgVoid;
      BeNP, CallSomeone, Do, Have, Make, Meet, Take, See : AbsV ArgNP;
      BeAdj : AbsV ArgAdj;
      CallSomeoneSomething : AbsV ArgNPNP;
}
