resource UtilsEng = {
  param
    Case = Nom | Acc | Pos;
    {- the Gender param is to ensure that the correct reflexive pronoun of a
     - third-person, singular NP is chosen (himself, herself, itself) -}
    Gender = Masc | Fem | Neut;
    NounInitial = Con | Vow;
    Tense = Pres | Past;
  oper
    {- for situations where some records of a field do not matter -}
    defaultGender : Gender = Masc;
}
