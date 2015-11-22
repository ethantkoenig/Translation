module Main where

import PGF
import System.Environment (getArgs)

import LanguageNames
import Trans
import qualified TransformIta
import qualified TransformEng

{- Command line arguments: <PFG file> <from language> <to language> -}

main :: IO ()
main = do
  pfgFile:from:to:_ <- getArgs
  grammar <- readPGF pfgFile
  interact (translate grammar from to)


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
  let normalize = case from of
                    "Eng" -> TransformEng.normalizeVP
                    "Ita" -> TransformIta.normalizeVP
                    _ -> error (from ++ " is not a valid langauge")
  in
  let unnormalize = case to of
                      "Eng" -> TransformEng.unnormalizeVP
                      "Ita" -> TransformIta.unnormalizeVP
                      _ -> error (from ++ " is not a valid language")
  in
  case parse grammar fromLang (startCat grammar) utterance of
    [] -> "NO PARSE\n"
    trees -> unlines $ map (linearize grammar toLang 
                              . gf . unnormalize . normalize . fg) trees

