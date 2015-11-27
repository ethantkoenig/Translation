instance TypesIta of Types = open Prelude, Utils, UtilsIta in {
  oper
    Adj : Type = {s : Number => Gender => Str};

    {- [Number => Person =>] in preface/postface accounts for possibility of
     - reflexives in object positions -}
    ArgStructure : Type = {null : Bool; preface : Number => Person => Str;
                           postface : Number => Person => Gender => Str; subj : NP};

    CP : Type = VP;

    {- D.s : (abstractOrMass : Bool) => ... => Str -}
    D : Type = {s : Bool => Number => Gender => NounInitial => Str};

    N_ : Type = {abstractOrMass : Bool; gend : Gender; init : NounInitial;
                 s : Number => Str};
    N : Type = {abstractOrMass : Bool; gend : Gender; init : NounInitial;
                num : Number; person : Person; s : Str};
    N' : Type = N;
    {- [Number => Person =>] in s accounts for reflexive pronouns -}
    NP : Type = {gend : Gender; isPronoun : Bool; null : Bool; num : Number;
                 person : Person; possessive : Number => Gender => Str;
                 s : Case => Number => Person => Str};

    ProNP : Type = NP;
    ProperN : Type = NP;
    Reflexive : Type = NP;

    S : Type = {s : Str};

    V : Type = {aux : Aux; inf : Str; presPart : Str;
                pastPart : Number => Gender => Str;
                conj : Tense => Number => Person => Str};
    V' : Type = {head : V; null : Bool; preface : Number => Person => Str; 
                 postface : Number => Person => Gender => Str; subj : NP};
    VP__ : Type = V';
    VP_ : Type = {head : V; null : Bool; preface : Number => Person => Str; 
                  postface : Number => Person => Gender => Str; subj : NP; tense : Tense};
    VP : Type = {null : Bool; s : Number => Person => Gender => Str; subj : NP};
}
