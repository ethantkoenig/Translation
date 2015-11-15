instance LexTransIta of LexTrans =
    open SyntaxIta, ParadigmsIta in {
  oper
    fast_A = mkA "veloce"; 
    tall_A = mkA "alto";

    boy_N = mkN "ragazzo";
    name_N = mkN "nome";
    student_N = mkN "studente";
    woman_N = mkN "donna";
    
    meet_V2 = mkV2 (mkV "incontrare");
    see_V2 = mkV2 (mkV "vedere");
}
