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

    singular : N_ -> N;
    plural : N_ -> N;
    present : VP__ -> VP_;
    past : VP__ -> VP_;
    future : VP__ -> VP_;
    cond : VP__ -> VP_;
    positive : VP_ -> VP;
    negative : VP_ -> VP;

    auxBe : VP__ -> V';
    auxHave : VP__ -> V';

    {- FUNCTIONAL WORDS -}
    indefinite : D;
    definite : D;
    voidD : D;

}  
