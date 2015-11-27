interface Syntax = {
  oper
    -- TODO order and organize

    mkNP : D -> N' -> NP;
    possessive : NP -> N' -> NP;
    npOfProNP : ProNP -> NP;
    npOfReflexive : Reflexive -> NP;
    npOfProperN : ProperN -> NP;

    mkN' : N -> N';
    adjoinN'Adj : N' -> Adj -> N';
    adjoinN'CP : N' -> CP -> N';

    mkS : VP -> S; 
    mkCP : VP -> CP;   

    mkVP__ : V' -> VP__;
    mkV' : V -> ArgStructure -> V';

    mkArgVoid : NP -> ArgStructure;
    mkArgNP : NP -> NP -> ArgStructure;
    mkArgAdj : NP -> Adj -> ArgStructure;
    mkArgNPNP : NP -> NP -> NP -> ArgStructure;

    singular, plural : N_ -> N;
    present, past, cond, future : VP__ -> VP_;
    positive, negative : VP_ -> VP;

    auxBe, auxHave : VP__ -> V';

}  
