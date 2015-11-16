resource MorphIta = {
  param
    Number = Sg | Pl;
    Person = First | Second | Third;
    Gender = Masc | Fem;
    {- Complex includes impure s, self-geminating consonants, complex clusters -}
    NounInitial = Con | Vow | Complex;
    Aux = Avere | Essere;
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

    pastParticiples : (aux : Aux) -> (mangiato : Str) -> Number => Gender => Str =
      \aux, mangiato -> case aux of {
                          Avere => \\_, _ => mangiato;
                          Essere => let mangiat : Str = 
                                      case mangiato of {
                                        mangiat + ? => mangiat;
                                        _ => ""} in
                                    table {Sg => table {Masc => mangiat + "o";
                                                        Fem => mangiat + "a"};
                                           Pl => table {Masc => mangiat + "i";
                                                        Fem => mangiat + "e"}}};

    stem : (mangiare : Str) -> Str =
      \mangiare -> case mangiare of {
                     mangi + "are" => mangi + "e";
                     mangia + "re" => mangia;
                     _ => ""};
   
    genericPresConjugate : (firstSg, secondSg, thirdSg, firstPl, secondPl, thirdPl : Str -> Str)
                       -> (abitare : Str) -> Number => Person => Str =
      \firstSg, secondSg, thirdSg, firstPl, secondPl, thirdPl, abitare ->
        let abit : Str = getRoot abitare in
        table {Sg => table {First => firstSg abit;
                            Second => secondSg abit; 
                            Third => thirdSg abit};
               Pl => table {First => firstPl abit;
                            Second => secondPl abit;
                            Third => thirdPl abit}};

    arePresConjugate : (abitare : Str) -> Number => Person => Str =
      \abitare -> genericPresConjugate (\abit -> abit + "o")
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

    erePresConjugate : (credere : Str) -> Number => Person => Str =
      \credere -> genericPresConjugate (\cred -> cred + "o")
                                       (\cred -> case cred of {
                                                  _ + "i" => cred;
                                                  _ => cred + "i"})
                                       (\cred -> cred + "e")
                                       (\cred -> case cred of {
                                                  _ + "i" => cred + "amo";
                                                  _ => cred + "iamo"})
                                       (\cred -> cred + "ete")
                                       (\cred -> cred + "ono")
                                       credere;
                                      
    irePresConjugate : (dormire : Str) -> Number => Person => Str =
      \dormire -> genericPresConjugate (\dorm -> dorm + "o")
                                       (\dorm -> dorm + "i")
                                       (\dorm -> dorm + "e")
                                       (\dorm -> dorm + "iamo")
                                       (\dorm -> dorm + "ite")
                                       (\dorm -> dorm + "ono")
                                       dormire;

    presConjugate : (abitare : Str) -> Number => Person => Str =
      \abitare -> case abitare of {
                    _ + "are" => arePresConjugate abitare;
                    _ + "ere" => erePresConjugate abitare;
                    _ + "ire" => irePresConjugate abitare;
                    _ => \\_, _ => "" {- this shouldn't happen -}
                  };


    futureConjugate : (mangie : Str) -> Number => Person => Str =
      \mangie -> table {
                   Sg => table { First => mangie + "ro'";
                                 Second => mangie + "rai";
                                 Third => mangie + "ra'"};
                   Pl => table { First => mangie + "remo";
                                 Second => mangie + "rete";
                                 Third => mangie + "ranno"}};

    condConjugate : (mangie : Str) -> Number => Person => Str =
      \mangie -> table {
                   Sg => table { First => mangie + "rei";
                                 Second => mangie + "resti";
                                 Third => mangie + "rebbe"};
                   Pl => table { First => mangie + "remmo";
                                 Second => mangie + "reste";
                                 Third => mangie + "rebbero"}};
}
