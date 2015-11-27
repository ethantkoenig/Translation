module Main where

import PGF
import System.Environment (getArgs)

import LanguageNames
import Trans
import qualified TextEng (toInput, toOutput)
import qualified TextIta (toInput, toOutput)
import qualified TreeEng (normalizeS, unnormalizeS)
import qualified TreeIta (normalizeS, unnormalizeS)


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
  let (toInput, normalize) = case from of
                    "Eng" -> (TextEng.toInput, TreeEng.normalizeS)
                    "Ita" -> (TextIta.toInput, TreeIta.normalizeS)
                    _ -> error (from ++ " is not a valid langauge")
  in
  let (toOutput, unnormalize) = case to of
                      "Eng" -> (TextEng.toOutput, TreeEng.unnormalizeS)
                      "Ita" -> (TextIta.toOutput, TreeIta.unnormalizeS)
                      _ -> error (to ++ " is not a valid language")
  in
  case parse grammar fromLang (startCat grammar) $ toInput utterance of
    [] -> "NO PARSE\n"
    trees -> unlines $ map (toOutput . linearize grammar toLang 
                              . gf . unnormalize . normalize . fg) trees

