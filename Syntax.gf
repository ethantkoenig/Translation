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

    ArgStructure : Type;

    {- FUNCTIONS -}

    mkNP : D -> N' -> NP;
    mkN' : N -> N';

    mkVP__ : V' -> VP__;
    mkV' : V -> ArgStructure -> V';

    mkArg_ : NP -> ArgStructure;
    mkArg_NP : NP -> NP -> ArgStructure;

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

}
  
