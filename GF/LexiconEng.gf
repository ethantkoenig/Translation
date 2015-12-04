instance LexiconEng of Lexicon = 
    open LexemeEng, Prelude, TypesEng, UtilsEng in {
  oper
    fast = mkAdj "fast";
    happy = mkAdj "happy";
    hungry = mkAdj "hungry";
    tall = mkAdj "tall";

    boy = mkN_ Masc "boy";
    dog = mkN_ "dog";
    elephant = mkN_ "elephant";
    hunger = mkN_ True "hunger";
    map  =mkN_ "map";
    name = mkN_ "name";
    picture = mkN_ "picture";
    promise = mkN_ "promise";
    student = mkN_ Masc "student";
    woman = mkN_ False Fem "woman" "women";

    alice = mkProperN Fem "Alice";
    bob = mkProperN Masc "Bob";
    emma = mkProperN Fem "Emma";
    joe = mkProperN Masc "Joe";

    under = mkP "under";
    withh = mkP "with";

    beAdj = beVerb;
    beNP = beVerb;
    callSomeone = mkV "call";
    callSomeoneSomething = mkV "call";
    do = mkV "do" "done" "did";
    have = mkV "have" "having" "had" "have" "have" "has" "had" "had";
    make = mkV "make" "made";
    meet = mkV "meet" "met";    
    see = mkV "see" "seen" "saw";
    sleep = mkV "sleep" "slept";
    take = mkV "take" "taken" "took";
}
