module TextEng where


{- if s is a possessive, return root (i.e. "dog's" -> Just "dog"). 
 - Otherwise Nothing -}
possessiveRoot :: String -> Maybe String
possessiveRoot s =
  case reverse s of
  's':'\'':rest -> Just $ reverse rest
  '\'':rest -> Just $ reverse rest
  _ -> Nothing



toInputAux :: [String] -> [String]
toInputAux (x:xs) =
  case possessiveRoot x of
    Just root -> root:"\'s":(toInputAux xs)
    Nothing -> x:(toInputAux xs)

toInputAux x = x -- base case


toInput :: String -> String
toInput = unwords . toInputAux . words


toOutputAux :: [String] -> [String]
toOutputAux (root:"\'s":xs)
  | last root == 's' = (root ++ "\'"):(toOutputAux xs)
  | otherwise = (root ++ "\'s"):(toOutputAux xs)

toOutputAux (x:xs) = x:(toOutputAux xs)
toOutputAux x = x


toOutput :: String -> String
toOutput = unwords . toOutputAux . words
