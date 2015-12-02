interface Syntax = {
  oper
    -- TODO order and organize

    mkCP : VP -> CP;   

    mkNP : D -> N' -> NP;
    possessive : NP -> N' -> NP;
    npOfProNP : ProNP -> NP;
    npOfReflexive : Reflexive -> NP;
    npOfProperN : ProperN -> NP;

    mkN' : N -> N';
    adjoinN'Adj : N' -> Adj -> N';
    adjoinN'CP : N' -> CP -> N';
    adjoinN'PP : N' -> PP -> N';

    mkPP : P -> NP -> PP;

    mkS_ : VP -> S_; 

    mkVP__ : V' -> VP__;
    mkV' : V -> ArgStructure -> V';
    adjoinV'PP : V' -> PP -> V';

    mkArgVoid : NP -> ArgStructure;
    mkArgNP : NP -> NP -> ArgStructure;
    mkArgAdj : NP -> Adj -> ArgStructure;
    mkArgNPNP : NP -> NP -> NP -> ArgStructure;

    singular, plural : N_ -> N;
    declarative, interrogative : S_ -> S;
    present, past, cond, future : VP__ -> VP_;
    positive, negative : VP_ -> VP;

    auxBe, auxHave : VP__ -> VP__;

}  
