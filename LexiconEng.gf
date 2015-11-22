instance LexiconEng of Lexicon = 
    open SyntaxEng in {
  oper
    fast = mkAdj "fast";
    hungry = mkAdj "hungry";
    tall = mkAdj "tall";

    boy = mkN_ "boy";
    dog = mkN_ "dog";
    hunger = mkN_ "hunger";
    name = mkN_ "name";
    student = mkN_ "student";
    woman = mkN_ "woman" "women";

    -- be = mkV "be" "being" "been" "am" "are" "is" "was" "were";
    be = be';
    have = mkV "have" "having" "had" "have" "have" "has" "had" "had";
    meet = mkV "meet" "met";    
    see = mkV "see" "seeing" "seen" "see" "see" "sees" "saw" "saw";
    sleep = mkV "sleep" "slept";


}
