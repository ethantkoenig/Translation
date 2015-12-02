module TreeEng where

-- import PGF hiding (Tree)
-- import qualified PGF

import Trans
import TransUtils


{- NORMALIZE -}
normalizeS :: GAbsS -> GAbsS
normalizeS = transformS normalizeS_

normalizeS_ :: GAbsS_ -> GAbsS_
normalizeS_ =transformS_ normalizeVP

normalizeCP :: GAbsCP -> GAbsCP
normalizeCP = transformCP normalizeVP

normalizeVP :: GAbsVP -> GAbsVP
normalizeVP = transformVP normalizeVP_

normalizeVP_ :: GAbsVP_ -> GAbsVP_
normalizeVP_ = transformVP_ normalizeVP__

normalizeVP__ :: GAbsVP__ -> GAbsVP__
normalizeVP__ = transformVP__ normalizeV'

normalizeV' :: GAbsV' -> GAbsV'
normalizeV' (GAdjoinV'PP v' pp) = GAdjoinV'PP (normalizeV' v') (normalizePP pp)
normalizeV' (GMakeV' GArgNP GTake args) =
  case n_OfDirObj args of 
    Just GPicture -> (GMakeV' GArgNP GDo (normalizeArgs args))
    _ -> (GMakeV' GArgNP GTake (normalizeArgs args))

normalizeV' (GMakeV' argType verb args) = GMakeV' argType verb (normalizeArgs args)

normalizeArgs :: GAbsArgStructure -> GAbsArgStructure
normalizeArgs = transformArgs normalizeNP

normalizeNP :: GAbsNP -> GAbsNP
normalizeNP = transformNP normalizeN'

normalizeN' :: GAbsN' -> GAbsN'
normalizeN' = transformN' normalizeCP normalizePP

normalizePP :: GAbsPP -> GAbsPP
normalizePP = transformPP normalizeNP


{- UNNORMALIZE -}
unnormalizeS :: GAbsS -> GAbsS
unnormalizeS = transformS unnormalizeS_

unnormalizeS_ :: GAbsS_ -> GAbsS_
unnormalizeS_ = transformS_ unnormalizeVP

unnormalizeCP :: GAbsCP -> GAbsCP
unnormalizeCP = transformCP unnormalizeVP

unnormalizeVP :: GAbsVP -> GAbsVP
unnormalizeVP = transformVP unnormalizeVP_

unnormalizeVP_ :: GAbsVP_ -> GAbsVP_
unnormalizeVP_ = transformVP_ unnormalizeVP__

unnormalizeVP__ :: GAbsVP__ -> GAbsVP__
unnormalizeVP__ = transformVP__ unnormalizeV'

unnormalizeV' :: GAbsV' -> GAbsV'
unnormalizeV' (GAdjoinV'PP v' pp) = GAdjoinV'PP (unnormalizeV' v') (unnormalizePP pp)
unnormalizeV' (GMakeV' GArgNP GDo args) =
  case n_OfDirObj args of
    Just GPicture -> (GMakeV' GArgNP GTake args)
    _ -> (GMakeV' GArgNP GDo args)

unnormalizeV' (GMakeV' argType verb args) = GMakeV' argType verb (unnormalizeArgs args)

unnormalizeArgs :: GAbsArgStructure -> GAbsArgStructure
unnormalizeArgs = transformArgs unnormalizeNP

unnormalizeNP :: GAbsNP -> GAbsNP
unnormalizeNP = transformNP unnormalizeN'

unnormalizeN' :: GAbsN' -> GAbsN'
unnormalizeN' = transformN' unnormalizeCP unnormalizePP

unnormalizePP :: GAbsPP -> GAbsPP
unnormalizePP = transformPP unnormalizeNP
