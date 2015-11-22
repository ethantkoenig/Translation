resource Utils = {
  param
    -- Bool = True | False;
    Number = Sg | Pl;
    Person = First | Second | Third;
    Polarity = Pos | Neg;
  oper
    {- the "nonword" is useful for situations where we want to disallow 
     - certain scenarios, such as reflexive case in subject position -}
    nonword : Str = "whatistheairspeedvelocityofanunladenswallow";
}
