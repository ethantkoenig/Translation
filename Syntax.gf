interface Syntax = {
  oper
    {- TYPES -}
    N_ : Type;
    N : Type;
    N' : Type;
    NP : Type;

    D : Type;

    V : Type;
    V' : Type;
    VP__ : Type;
    VP_ : Type;
    VP : Type;

    Adj : Type;

    ArgStructure : Type;

    {- FUNCTIONS -}

    {- Lexical functions are intentionally omitted because they vary from
     - language to language -}
    mkNP : D -> N' -> NP;
    mkN' : N -> N';
    adjN' : N' -> Adj -> N';

    mkVP__ : V' -> VP__;
    mkV' : V -> ArgStructure -> V';

    mkArgVoid : NP -> ArgStructure;
    mkArgNP : NP -> NP -> ArgStructure;
    mkArgAdj : NP -> Adj -> ArgStructure;

    singular, plural : N_ -> N;
    present, past, cond, future : VP__ -> VP_;
    positive, negative : VP_ -> VP;

    auxBe, auxHave : VP__ -> V';

    {- FUNCTIONAL WORDS -}
    indefinite, definite, voidD : D;
    definite : D;
    voidD : D;

    i, you, he, she, we, yall, they : NP;

}  
