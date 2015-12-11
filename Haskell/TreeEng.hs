module TreeEng where

import Trans
import TransUtils

{- V' OPERATIONS -}

normalizeV' :: GAbsV' -> GAbsV'
normalizeV' (GAdjoinV'PP v' pp) = 
  GAdjoinV'PP (normalizeV' v') (normalizePP pp)

-- X takes [picture] -> X does [picture]
normalizeV' (GMakeV' GArgNP GTake args) =
  let args' = normalizeArgs args in
  case n_OfDirObj args' of 
    Just GPicture -> GMakeV' GArgNP GDo args'
    _ -> GMakeV' GArgNP GTake args'

-- base case
normalizeV' (GMakeV' argType verb args) = 
  GMakeV' argType verb (normalizeArgs args)



unnormalizeV' :: GAbsV' -> GAbsV'
unnormalizeV' (GAdjoinV'PP v' pp) = 
  GAdjoinV'PP (unnormalizeV' v') (unnormalizePP pp)

-- X does [picture] -> X takes picture
unnormalizeV' (GMakeV' GArgNP GDo args) =
  let args' = unnormalizeArgs args in
  case n_OfDirObj args of
    Just GPicture -> GMakeV' GArgNP GTake args'
    _ -> GMakeV' GArgNP GDo args'

-- base case
unnormalizeV' (GMakeV' argType verb args) = 
  GMakeV' argType verb (unnormalizeArgs args)


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

unnormalizeArgs :: GAbsArgStructure -> GAbsArgStructure
unnormalizeArgs = transformArgs unnormalizeNP

unnormalizeNP :: GAbsNP -> GAbsNP
unnormalizeNP = transformNP unnormalizeN'

unnormalizeN' :: GAbsN' -> GAbsN'
unnormalizeN' = transformN' unnormalizeCP unnormalizePP

unnormalizePP :: GAbsPP -> GAbsPP
unnormalizePP = transformPP unnormalizeNP
