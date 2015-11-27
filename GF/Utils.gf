resource Utils = open Prelude in {
  param
    Number = Sg | Pl;
    Person = First | Second | Third;
    Polarity = Positive | Negative;
  oper
    {- the "nonword" is useful for situations where we want to disallow 
     - certain scenarios, such as reflexive case in subject position -}
    nonword : Str = "whatistheairspeedvelocityofanunladenswallow";

    {- for situtations where certain fields of a record do not matter -}
    defaultNumber : Number = Sg;
    defaultPerson : Person = Third;
    defaultPolarity : Polarity = Positive;

    and : Bool -> Bool -> Bool = \x, y -> case <x, y> of {
                                            <True, True> => True;
                                            _ => False};

    or : Bool -> Bool -> Bool = \x, y -> case <x, y> of {
                                            <False, False> => False;
                                            _ => True};

    {- whether at least two of x, y, z are True -}
    two : Bool -> Bool -> Bool -> Bool = \x, y, z ->
      case <x, y, z> of {
        <True, True, _> => True;
        <True, _, True> => True;
        <_, True, True> => True;
        _ => False
      };
}
