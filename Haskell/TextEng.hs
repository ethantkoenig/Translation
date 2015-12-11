module TextEng where


{- if s is a possessive, return root (i.e. "dog's" -> Just "dog"). 
 - Otherwise Nothing -}
possessiveRoot :: String -> Maybe String
possessiveRoot s =
  case reverse s of
  's':'\'':rest -> Just $ reverse rest
  '\'':rest -> Just $ reverse rest
  _ -> Nothing


{- tokenizes a list of words -}
tokenizeAux :: [String] -> [String]
tokenizeAux (x:xs) =
  case possessiveRoot x of
    Just root -> root:"\'s":(tokenizeAux xs)
    Nothing -> x:(tokenizeAux xs)

tokenizeAux x = x -- base case


{- tokenizes a string from input -}
tokenize :: String -> String
tokenize = unwords . tokenizeAux . words


{- untokenizes a list of words -}
untokenizeAux :: [String] -> [String]
untokenizeAux (root:"\'s":xs)
  | last root == 's' = (root ++ "\'"):(untokenizeAux xs)
  | otherwise = (root ++ "\'s"):(untokenizeAux xs)

untokenizeAux (x:xs) = x:(untokenizeAux xs)
untokenizeAux x = x


{- untokenizes a string for output -}
untokenize :: String -> String
untokenize = unwords . untokenizeAux . words
