instance TypesEng of Types = open Prelude, Utils, UtilsEng in {
  oper
    Adj : Type = {s : Str};


    {- preface : text before the subject
     - postface : text after the verb
     - [Number => Person => Gender =>] in postface accounts for possibilty of
     - reflexives in object position -}
    ArgStructure : Type = {wh : Bool; subj : NP;
                           preface : Number => Person => Gender => Str; 
                           postface : Number => Person => Gender => Str}; 

    CP : Type = VP;

    {- D.s : (abstractOrMass : Bool) => (num : Number) => Str -}
    D : Type = {s : Bool => Number => Str};

    N_ : Type = {abstractOrMass : Bool; gend : Gender; s : Number => Str};
    {- N.s : (isPossessive : Bool) => Str -}
    N : Type = {abstractOrMass : Bool; gend : Gender; num : Number; 
                person : Person; s : Str};
    N' : Type = N;
    {- null - whether NP is the "null WH" - e.g. the boy that [__] slept
     - wh - whether NP is the "WH" features - e.g. the boy [whose dog] we see -}
    NP : Type = {gend : Gender; null : Bool; num : Number; person : Person;
                 s : Case => Number => Person => Gender => Str; wh : Bool};

    ProNP : Type = NP;
    ProperN : Type = NP;
    Reflexive : Type = NP;

    S : Type = {s : Str};

    V : Type = {aux : Bool; conj : Tense => Number => Person => Str;
                inf : Str; presPart : Str; pastPart : Str};
    {- preface : text before the verb
     - postface : text after verb
     - wh : whether an argument to the verb is +WH -}
    V' : Type = {head : V; preface : Number => Person => Gender => Str;
                 postface : Number => Person => Gender => Str; subj : NP;
                 wh : Bool};
    VP__ : Type = V';
    VP_ : Type = {head : V; preface : Number => Person => Gender => Str;
                  postface : Number => Person => Gender => Str;
                  subj : NP; tense : Tense; wh : Bool};
    VP : Type = {s : Number => Person => Gender => Str; subj : NP; wh : Bool};
}
