instance LexiconIta of Lexicon =
    open LexemeIta, Prelude, TypesIta, Utils, UtilsIta in {
  flags coding = utf8;
  oper
    fast = mkAdj "veloce";
    happy = mkAdj "felice";
    hungry = mkAdj "affamato";
    tall = mkAdj "alto";

    boy = mkN_ "ragazzo";
    dog = mkN_ "cane";
    elephant = mkN_ "elefante";
    hunger = mkN_ True Fem "fame";
    map = mkN_ "mappa";
    name = mkN_ "nome";
    promise = mkN_ "promessa";
    picture = mkN_ False Fem "foto" "foto";
    student = mkN_ "studente";
    woman = mkN_ "donna";

    alice = mkProperN Fem "Alice";
    bob = mkProperN Masc "Bob";
    emma = mkProperN Fem "Emma";
    {- As much as I would like to write Giuseppe, I use the English version to
     - ensure a more fair comparison with other systems which do not translate
     - names -}
    joe = mkProperN Masc "Joe";

    under = mkP "sotto";
    withh = mkP "con";

    be = mkV Essere "essere" "essendo" "stato" "sono" "sei" "è"
                    "siamo" "siete" "sono" "sa";
    beAdj = be;
    beNP = be;
    callSomeone = mkV Avere "chiamare";
    callSomeoneSomething = mkV Avere "chiamare";
    do = mkV Avere "fare" "facendo" "fatto" "faccio" "fai" "fa" "facciamo"
                   "fate" "fanno" "fa";
    have = mkV Avere "avere" "avendo" "avuto" "ho" "hai" "ha" 
                     "abbiamo" "avete" "hanno" "av";
    make = do;
    meet = mkV Avere "incontrare";
    see = mkV Avere "vedere" "vedendo" "visto" "vedo" "vedi" "vede" "vediamo"
                    "vedete" "vedono" "ved";
    sleep = mkV Avere "dormire";
    take = mkV Avere "prendere" "preso";
}
