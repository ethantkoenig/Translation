module Main where

import PGF
import System.Environment (getArgs)

import LanguageNames
import Trans
import qualified TextEng (tokenize, untokenize)
import qualified TextIta (tokenize, untokenize)
import qualified TreeEng (normalizeS, unnormalizeS)
import qualified TreeIta (normalizeS, unnormalizeS)


{- Command line arguments: <PFG file> <from language> <to language> -}
main :: IO ()
main = do
  pfgFile:from:to:_ <- getArgs
  grammar <- readPGF pfgFile
  interact (translate grammar from to)


{- (translate grammar sourceLang targetLang source) returns the translation of
 - source from sourceLang to targetLang. Returns "NO PARSE\n" if source not
 - parsed. Raises error if sourceLang or targetLang not recognized -}
translate :: PGF -> String -> String -> String -> String
translate grammar from to utterance =
  let langs = languages grammar in
  let fromLang = case selectBySuffix langs from of
                   Just l -> l
                   Nothing -> error (from ++ " is not a valid langauge")
  in
  let toLang = case selectBySuffix langs to of
                 Just l -> l
                 Nothing -> error (to ++ " is not a valid language")
  in
  let (tokenize, normalize) = case from of
                    "Eng" -> (TextEng.tokenize, TreeEng.normalizeS)
                    "Ita" -> (TextIta.tokenize, TreeIta.normalizeS)
                    _ -> error (from ++ " is not a valid langauge")
  in
  let (untokenize, unnormalize) = case to of
                      "Eng" -> (TextEng.untokenize, TreeEng.unnormalizeS)
                      "Ita" -> (TextIta.untokenize, TreeIta.unnormalizeS)
                      _ -> error (to ++ " is not a valid language")
  in
  case parse grammar fromLang (startCat grammar) $ tokenize utterance of
    [] -> "NO PARSE\n"
    trees -> unlines $ map (untokenize . linearize grammar toLang 
                              . gf . unnormalize . normalize . fg) trees

