--# -path=.:../trans:alltenses

interface LexTrans = open Syntax in {
  oper
    fast_A : A;
    tall_A : A;

    boy_N : N;
    name_N : N;
    student_N : N;  
    woman_N : N;
  
    see_V2 : V2;
    meet_V2 : V2;
}
