instance TypesEng of Types = open Prelude, Utils, UtilsEng in {
  oper
    Adj : Type = {s : Str};

    {- [Number => Person => Gender =>] in postface accounts for possibilty of
     - reflexives in object position -}
    ArgStructure : Type = {null : Bool; subj : NP; 
                           postface : Number => Person => Gender => Str}; 

    CP : Type = VP;

    {- D.s : (abstractOrMass : Bool) => (num : Number) => Str -}
    D : Type = {s : Bool => Number => Str};

    N_ : Type = {abstractOrMass : Bool; gend : Gender; s : Number => Str};
    {- N.s : (isPossessive : Bool) => Str -}
    N : Type = {abstractOrMass : Bool; gend : Gender; num : Number; 
                person : Person; s : Str};
    N' : Type = N;
    NP : Type = {gend : Gender; null : Bool; num : Number; person : Person;
                 s : Case => Number => Person => Gender => Str};

    ProNP : Type = NP;
    ProperN : Type = NP;
    Reflexive : Type = NP;

    S : Type = {s : Str};

    V : Type = {aux : Bool; conj : Tense => Number => Person => Str;
                inf : Str; presPart : Str; pastPart : Str};
    V' : Type = {head : V; null : Bool; 
                 preface : Number => Person => Gender => Str;
                 postface : Number => Person => Gender => Str; subj : NP};
    VP__ : Type = V';
    VP_ : Type = {head : V; null : Bool; 
                  preface : Number => Person => Gender => Str;
                  postface : Number => Person => Gender => Str;
                  subj : NP; tense : Tense};
    VP : Type = {null : Bool; s : Number => Person => Gender => Str; subj : NP};
}
