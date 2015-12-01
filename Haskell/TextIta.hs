module TextIta where

import Data.List (unwords, words)
import Data.Map (fromList, lookup, Map)

{- Each entry (x, (y, z)) in the first map signifies that if x appears in the 
 - input, it should be replaced with y z. Similarly, the entry ((y, z), x) in
 - the second map signifies that if y z appears in the output, it should be
 - replaced with x -}
contractions :: (Map String (String, String), Map (String, String) String)
contractions = 
  let rules = [("del", ("di", "il")),
               ("dello", ("di", "lo")),
               ("dell'", ("di", "l'")),    
               ("della", ("di", "la")),
               ("dei", ("di", "i")),
               ("degli", ("di", "gli")),
               ("delle", ("di", "le"))] in
  let decontract = fromList rules in
  let contract = fromList $ map (\(x, y) -> (y, x)) rules in
  (decontract, contract)


 
toInputAux :: [String] -> [String]
toInputAux (x:xs) =
  let (decontract, _) = contractions in
  case Data.Map.lookup x decontract of 
    Nothing -> x:(toInputAux xs)
    Just (x1, x2) -> x1:x2:(toInputAux xs)

toInputAux x = x -- base case   


toInput :: String -> String
toInput = unwords . toInputAux . words


toOutputAux :: [String] -> [String]
toOutputAux (x1:x2:xs) =
  let (_, contract) = contractions in
  case Data.Map.lookup (x1, x2) contract of
    Nothing -> x1:(toOutputAux (x2:xs))
    Just y -> toOutputAux (y:xs)

toOutputAux x = x  -- base case
 

toOutput :: String -> String
toOutput = unwords . toOutputAux . words
