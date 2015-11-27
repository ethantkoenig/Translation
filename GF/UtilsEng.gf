resource UtilsEng = {
  param
    Case = Nom | Acc | Pos;
    Gender = Masc | Fem | Neut;
    Tense = Pres | Past;
  oper
    {- for situations where some records of a field do not matter -}
    defaultGender : Gender = Masc;
}
