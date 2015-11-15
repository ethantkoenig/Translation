--# -path=.:../trans:alltenses

incomplete concrete TransI of Trans =
    open {-Common,-} Syntax, LexTrans in {
  lincat 
    AbsS = S;
    AbsNP = NP;
    AbsVP = VP;
    AbsD = Det;
    AbsNb = CN;
    AbsN = N;
    AbsV = V2;
    AbsAdj = Syntax.A;

  lin
    MakeNegS np vp = mkS negativePol (mkCl np vp);
    MakePosS np vp = mkS positivePol (mkCl np vp);
    MakeNP d nb = mkNP d nb;
    MakeNb n = mkCN n;
    AdjoinNb nb a = mkCN a nb;
    MakeVP v np = mkVP v np;

    A = a_Det;
    The = the_Det;

    Fast = fast_A;
    Tall = tall_A;

    Boy = boy_N;
    Name = name_N;
    Student = student_N;
    Woman = woman_N;
    
    See = see_V2;
    Meet = meet_V2;
}
