module TextIta where

import Data.List (unwords, words)
import Data.Map (fromList, lookup, Map)

{- Each entry (x, (y, z)) in the first map signifies that if x appears in an
 - untokenized string, it should be replaced with y z during tokenization.
 - Similarly, the entry ((y, z), x) in the second map signifies that if y z
 - appears in a tokenized string, it should be replaced with x during 
 - untokenization -}
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


{- tokenizes a list of words -}
tokenizeAux :: [String] -> [String]
tokenizeAux (x:xs) =
  let (decontract, _) = contractions in
  case Data.Map.lookup x decontract of 
    Nothing -> x:(tokenizeAux xs)
    Just (x1, x2) -> x1:x2:(tokenizeAux xs)

tokenizeAux x = x -- base case   


{- tokenizes a string from input -}
tokenize :: String -> String
tokenize = unwords . tokenizeAux . words


{- untokenizes a list of words -}
untokenizeAux :: [String] -> [String]
untokenizeAux (x1:x2:xs) =
  let (_, contract) = contractions in
  case Data.Map.lookup (x1, x2) contract of
    Nothing -> x1:(untokenizeAux (x2:xs))
    Just y -> untokenizeAux (y:xs)

untokenizeAux x = x  -- base case
 

{- untokenizes a string for output -}
untokenize :: String -> String
untokenize = unwords . untokenizeAux . words
