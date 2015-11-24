instance LexiconEng of Lexicon = 
    open Prelude, SyntaxEng in {
  oper
    fast = mkAdj "fast";
    hungry = mkAdj "hungry";
    tall = mkAdj "tall";

    boy = mkN_ "boy";
    dog = mkN_ "dog";
    hunger = mkN_ True "hunger";
    name = mkN_ "name";
    picture = mkN_ "picture";
    student = mkN_ "student";
    woman = mkN_ False "woman" "women";

    -- TODO should eventually remove 
    -- be = mkV "be" "being" "been" "am" "are" "is" "was" "were";
    be = beVerb;
    do = mkV "do" "done" "did";
    have = mkV "have" "having" "had" "have" "have" "has" "had" "had";
    meet = mkV "meet" "met";    
    see = mkV "see" "seen" "saw";
    sleep = mkV "sleep" "slept";
    take = mkV "take" "taken" "took";
}
