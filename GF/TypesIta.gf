instance TypesIta of Types = open Prelude, Utils, UtilsIta in {
  oper
    Adj : Type = {s : Number => Gender => Str};


    {- preSubj : text before Subj
     - postSubj : text between Subj and verb
     - postVerb : text after verb
     - [Number => Person =>] in postSubj/postVerb accounts for possibility of
     - reflexives in object positions -}
    ArgStructure : Type =  {preSubj : Number => Person => Str;
                            postSubj : Number => Person => Str;
                            postVerb : Number => Person => Gender => Str;
                            subj : NP; wh : Bool};

    CP : Type = {s : Number => Person => Gender => Str};

    {- D.s : (abstractOrMass : Bool) => ... => Str -}
    D : Type = {s : Bool => Number => Gender => NounInitial => Str};

    N_ : Type = {abstractOrMass : Bool; gend : Gender; init : NounInitial;
                 s : Number => Str};
    N : Type = {abstractOrMass : Bool; gend : Gender; init : NounInitial;
                num : Number; person : Person; s : Str};
    N' : Type = N;
    {- (Number => Person =>) in s accounts for reflexive pronouns -}
    NP : Type = {gend : Gender; null : Bool; num : Number; person : Person; 
                 possessive : Number => Gender => Str; pronoun : Bool;
                 s : Case => Number => Person => Str; wh : Bool};

    ProNP : Type = NP;
    ProperN : Type = NP;
    Reflexive : Type = NP;

    S_ : Type = VP;
    S : Type = {s : Str};

    V : Type = {aux : Aux; inf : Str; presPart : Str;
                pastPart : Number => Gender => Str;
                conj : Tense => Number => Person => Str};
    V' : Type = {head : V; preSubj : Number => Person => Str; 
                 postSubj : Number => Person => Str; 
                 postVerb : Number => Person => Gender => Str; 
                 subj : NP; wh : Bool};
    VP__ : Type = V';
    VP_ : Type = VP;
    VP : Type = {head : V; preSubj : Number => Person => Str;
                  postSubj : Number => Person => Str; 
                  postVerb : Number => Person => Gender => Str; subj : NP;
                  tense : Tense; wh : Bool};
}
