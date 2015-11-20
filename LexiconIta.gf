instance LexiconIta of Lexicon =
    open Concepts, SyntaxIta, MorphIta {-- TODO don't want to open MorphIta here -} in {
  oper
    fast = mkAdj "veloce";
    hungry = mkAdj "affamato";
    tall = mkAdj "alto";

    boy = mkN_ "ragazzo";
    hunger = mkN_ Fem "fame";
    name = mkN_ "nome";
    student = mkN_ "studente";

    -- TODO un-ASCII-ify
    be = mkV Essere "essere" "essendo" "stato" "sono" "sei" "e'"
                    "siamo" "siete" "sono" "sa";
    have = mkV Avere "avere" "avendo" "avuto" "ho" "hai" "ha" 
                     "abbiamo" "avete" "hanno" "av";
    meet = mkV Avere "incontrare";
    see = mkV Avere "vedere";
    sleep = mkV Avere "dormire";
}
