resource MorphIta = {
  param
    Number = Sg | Pl;
    Person = First | Second | Third;
    Gender = Masc | Fem;
    {- Complex includes impure s, self-geminating consonants, complex clusters -}
    NounInitial = Con | Vow | Complex;
    Participle = Avere | Essere;
  oper
    {- FUNCTIONS FOR NOUNS -}
    inferGender : (gatto : Str) -> Gender =
      \gatto -> case gatto of {
                  _ + "a" => Fem;
                  _ + "ione" => Fem;
                  _ => Masc
                };
    
    nounInitial : (gatto : Str) -> NounInitial =
      \gatto -> case gatto of {
                  "s" + ("c" | "h" | "p" | "t") + _
                  | "z" + _
                  | "gn" + _
                  | "ps" + _ => Complex;
                  ("a" | "e" | "i" | "o" | "u") + _ => Vow;
                  _ => Con
                };

    pluralize : (gatto : Str) -> Str =
      \gatto -> case gatto of {
                  gatt + "ca" => gatt + "che";
                  gatt + "co" => gatt + "chi";
                  gatt + "ga" => gatt + "ghe";
                  gatt + "go" => gatt + "ghi";
                  gatt + "a"=> gatt + "e";
                  gatt + ("e" | "o") => gatt + "i";
                  _ => gatto
                };

    {- FUNCTIONS FOR VERBS -}
    
    getRoot : (manigare : Str) -> Str =
      \mangiare -> case mangiare of {
                     mangi + ("are" | "ere" | "ire") => mangi;
                     _ => "" {- shouldn't happen -}
                   };

    presParticiple : (mangiare : Str) -> Str =
      \mangiare -> case mangiare of {
                     mangi + "are" => mangi + "ando";
                     mangi + ("ere" | "ire") => mangi + "endo";
                     _ => ""
                   };

    pastParticiple : (mangiare : Str) -> Str =
      \mangiare -> case mangiare of {
                     mangi + "are" => mangi + "ato";
                     mangi + "ere" => mangi + "uto";
                     mangi + "ire" => mangi + "ito";
                     _ => ""};

    pastParticiples : (p : Participle) -> (mangiato : Str) -> Number => Gender => Str =
      \p, mangiato -> case p of {
                        Avere => \\_, _ => mangiato;
                        Essere => let mangiat : Str = 
                                    case mangiato of {
                                      mangiat + ? => mangiat;
                                      _ => ""} in
                                  table {Sg => table {Masc => mangiat + "o";
                                                      Fem => mangiat + "a"};
                                         Pl => table {Masc => mangiat + "i";
                                                      Fem => mangiat + "e"}}};
   
    genericConjugate : (firstSg, secondSg, thirdSg, firstPl, secondPl, thirdPl : Str -> Str)
                -> (abitare : Str) -> Number => Person => Str =
      \firstSg, secondSg, thirdSg, firstPl, secondPl, thirdPl, abitare ->
        let abit : Str = getRoot abitare in
        table {Sg => table {First => firstSg abit;
                            Second => secondSg abit; 
                            Third => thirdSg abit};
               Pl => table {First => firstPl abit;
                            Second => secondPl abit;
                            Third => thirdPl abit}};

    areConjugate : (abitare : Str) -> Number => Person => Str =
      \abitare -> genericConjugate (\abit -> abit + "o")
                                   (\abit -> case abit of {
                                               _ + "i" => abit;
                                               _ + ("c" | "g") => abit + "hi";
                                               _ => abit + "i"})
                                   (\abit -> abit + "a")
                                   (\abit -> case abit of {
                                               _ + "i" => abit + "amo";
                                               _ + ("c" | "g") => abit + "hiamo";
                                               _ => abit + "iamo"})
                                   (\abit -> abit + "ate")
                                   (\abit -> abit + "ano")
                                   abitare;

    ereConjugate : (cadere : Str) -> Number => Person => Str =
      \cadere -> genericConjugate (\cad -> cad + "o")
                                  (\cad -> case cad of {
                                             _ + "i" => cad;
                                             _ => cad + "i"})
                                  (\cad -> cad + "e")
                                  (\cad -> case cad of {
                                             _ + "i" => cad + "amo";
                                             _ => cad + "iamo"})
                                  (\cad -> cad + "ete")
                                  (\cad -> cad + "ono")
                                  cadere;
                                      
    ireConjugate : (dormire : Str) -> Number => Person => Str =
      \dormire -> genericConjugate (\dorm -> dorm + "o")
                                   (\dorm -> dorm + "i")
                                   (\dorm -> dorm + "e")
                                   (\dorm -> dorm + "iamo")
                                   (\dorm -> dorm + "ite")
                                   (\dorm -> dorm + "ono")
                                   dormire;

    conjugate : (abitare : Str) -> Number => Person => Str =
      \abitare -> case abitare of {
                    _ + "are" => areConjugate abitare;
                    _ + "ere" => ereConjugate abitare;
                    _ + "ire" => ireConjugate abitare;
                    _ => \\_, _ => "" {- this shouldn't happen -}
                  };
}
