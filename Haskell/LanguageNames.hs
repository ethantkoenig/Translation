module LanguageNames where

import Data.List (find)

{- lcp = longest common prefix -}
lcp :: String -> String -> String
lcp [] ys = ""
lcp xs [] = ""
lcp (x:xs) (y:ys)
  | x == y = x:(lcp xs ys)
  | otherwise = ""

{- lcp of all element of list -}
lcpOfList :: [String] -> String
lcpOfList [] = ""
lcpOfList (x:xs) = foldl lcp x xs


{- selectBySuffix l suffix returns the element x in l such that (show x) = 
 - (lcpOfList l) + suffix. Returns Nothing if no such x exists. If multiple 
 - such x exists, nondeterministically picks one -}
selectBySuffix :: Show a => [a] -> String -> Maybe a
selectBySuffix l suffix = 
  let prefix = lcpOfList (map show l) in
  find (\x -> show x == prefix ++ suffix) l
