module TransformEng where

-- import PGF hiding (Tree)
-- import qualified PGF

import Trans
import TransUtils


{- NORMALIZE -}
normalizeVP :: GAbsVP -> GAbsVP
normalizeVP = transformVP normalizeVP_

normalizeVP_ :: GAbsVP_ -> GAbsVP_
normalizeVP_ = transformVP_ normalizeVP__

normalizeVP__ :: GAbsVP__ -> GAbsVP__
normalizeVP__ = transformVP__ normalizeV'


normalizeV' :: GAbsV' -> GAbsV'
normalizeV' (GAuxBe vp__) = GAuxBe (normalizeVP__ vp__)
normalizeV' (GAuxHave vp__) = GAuxHave (normalizeVP__ vp__)

normalizeV' (GMakeV' GArgNP GTake args) =
  case n_OfDirObj args of 
    Just GPicture -> (GMakeV' GArgNP GDo args)
    _ -> (GMakeV' GArgNP GTake args)

normalizeV' v = v -- base case


{- UNNORMALIZE -}
unnormalizeVP :: GAbsVP -> GAbsVP
unnormalizeVP = transformVP unnormalizeVP_

unnormalizeVP_ :: GAbsVP_ -> GAbsVP_
unnormalizeVP_ = transformVP_ unnormalizeVP__

unnormalizeVP__ :: GAbsVP__ -> GAbsVP__
unnormalizeVP__ = transformVP__ unnormalizeV'

unnormalizeV' :: GAbsV' -> GAbsV'
unnormalizeV' (GAuxBe vp__) = GAuxBe (unnormalizeVP__ vp__)
unnormalizeV' (GAuxHave vp__) = GAuxHave (unnormalizeVP__ vp__)

unnormalizeV' (GMakeV' GArgNP GDo args) =
  case n_OfDirObj args of
    Just GPicture -> (GMakeV' GArgNP GTake args)
    _ -> (GMakeV' GArgNP GDo args)

unnormalizeV' v = v -- base case
