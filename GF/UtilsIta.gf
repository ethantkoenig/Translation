resource UtilsIta = {
  param
    Aux = Avere | Essere;
    Case = Nom | Acc | Dis;
    Gender = Masc | Fem;
    {- Complex includes impure s, self-geminating consonants, complex clusters -}
    NounInitial = Con | Vow | Complex;
    Tense = Pres | Past | Fut | Cond;
  oper
    {- for situations where some records of a field do not matter -}
    defaultGender : Gender = Masc;

}
