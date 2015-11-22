resource MorphEng = {
  oper
    {- INFLECTIONAL FUNCTIONS -}
    append_s : Str -> Str =
      \dog -> case dog of {
                _ + ("a" | "e" | "i" | "o" | "u") + "o" => dog + "s";
                _ + ("s" | "x" | "sh" | "o") =>  dog + "es";
                _ + ("a" | "e" | "o" | "u" ) + "y" => dog + "s";
                cr + "y" => cr + "ies";
                _ => dog + "s"
              };

    append_ed : Str -> Str =
      \walk -> case walk of {
                cr + "y" => cr + "ied";
                 _ + "e" => walk + "d";
                 _ => (duplFinal walk) + "ed"
               };

    append_ing : Str -> Str =
      \walk -> case walk of {
               _ + "ee" => walk + "ing";
               d + "ie" => d + "ying";
               us + "e" => us + "ing";
               _ => (duplFinal walk) + "ing"
               };

    addPossessive : Str -> Str = 
      \dog -> case dog of {
                _ + "s" => dog + "'";
                _ => dog + "'s"
              };

    {- from ParadigmsEng.gf -}
    duplFinal : Str -> Str = \w -> case w of {
      _ + ("a" | "e" | "o") + ("a" | "e" | "i" | "o" | "u") + ? => w ; -- waited, needed
      _ + ("a" | "e" | "i" | "o" | "u") + 
        c@("b"|"d"|"g"|"m"|"n"|"p"|"r"|"t") => w + c ; -- omitted, manned
      _ => w
      } ;

}
