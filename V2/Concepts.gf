resource Concepts = {
  param
    DetConcept = A | The; -- TODO do we need/want this?
    NounConcept = Boy | Student | Hunger | Name;
    -- AdjConcept = Hungry | Tall;
    VerbConcept = Meet | Sleep | See;
  -- oper DetConcept : Type = DetConcept_;
  oper
    {- Arbitrary concepts of each class. Useful for situtations where the
     - concept of a word does not matter -}
    ArbitraryDet = A;
    ArbitraryNoun = Boy;
    ArbitraryVerb = Meet;  
}
