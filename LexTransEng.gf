--# -path=.:../trans:alltenses

instance LexTransEng of LexTrans = 
    open SyntaxEng, ParadigmsEng in {
  oper
    fast_A = mkA "fast";
    tall_A = mkA "tall";

    boy_N = mkN "boy";
    name_N = mkN "name";
    student_N = mkN "student";
    woman_N = mkN "woman" "women";

    meet_V2 = mkV2 (mkV "meet" "met" "met");
    see_V2 = mkV2 (mkV "see" "saw" "seen");
}
