instance LexiconIta of Lexicon =
    open LexemeIta, Prelude, TypesIta, Utils, UtilsIta in {
  oper
    fast = mkAdj "veloce";
    happy = mkAdj "felice";
    hungry = mkAdj "affamato";
    tall = mkAdj "alto";

    boy = mkN_ "ragazzo";
    dog = mkN_ "cane";
    hunger = mkN_ True Fem "fame";
    map = mkN_ "mappa";
    name = mkN_ "nome";
    promise = mkN_ "promessa";
    picture = mkN_ False Fem "foto" "foto";
    student = mkN_ "studente";
    woman = mkN_ "donna";

    alice = mkProperN Fem "Alice";
    bob = mkProperN Masc "Bob";
    eve = mkProperN Fem "Eve";
    joe = mkProperN Masc "Joe";

    -- TODO un-ASCII-ify
    be = mkV Essere "essere" "essendo" "stato" "sono" "sei" "e'"
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
