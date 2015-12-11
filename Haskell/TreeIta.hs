module TreeIta where


import Trans
import TransUtils

{- V' OPERATIONS -}

normalizeV' :: GAbsV' -> GAbsV'
normalizeV' (GAdjoinV'PP v' pp) = 
  GAdjoinV'PP (normalizeV' v') (normalizePP pp)

-- X ha fame -> X e' affamato
normalizeV' (GMakeV' GArgNP GHave 
              (GMakeArgNP subj (GMakeNP GVoidD (GMakeN' (GSingular GHunger))))) =
  let subj' = normalizeNP subj in
  GMakeV' GArgAdj GBeAdj (GMakeArgAdj subj' GHungry)

-- X si chiama Y -> il nome di X e' Y
normalizeV' (GMakeV' GArgNPNP GCallSomeoneSomething
              (GMakeArgNPNP subj (GNPofReflexive GSelf) name)) =
  let subj' = normalizeNP subj in
  let name' = normalizeNP name in
  GMakeV' GArgNP GBeNP 
    $ GMakeArgNP (GPossessive subj' (GMakeN' (GSingular GName))) name'

-- base case
normalizeV' (GMakeV' argType verb args) = 
  GMakeV' argType verb (normalizeArgs args)



unnormalizeV' :: GAbsV' -> GAbsV'
unnormalizeV' (GAdjoinV'PP v' pp) = 
  GAdjoinV'PP (unnormalizeV' v') (unnormalizePP pp)

-- X e' affamato -> X ha fame
unnormalizeV' (GMakeV' GArgAdj GBeAdj (GMakeArgAdj subj GHungry)) =
  let subj' = unnormalizeNP subj in
  let hunger = GMakeNP GVoidD $ GMakeN' $ GSingular GHunger in
  GMakeV' GArgNP GHave $ GMakeArgNP subj' hunger

-- il nome di X e' Y -> X si chiama Y
unnormalizeV' (GMakeV' GArgNP GBeNP  
                (GMakeArgNP (GPossessive subj (GMakeN' (GSingular GName))) name)) =
  let subj' = unnormalizeNP subj in
  let name' = unnormalizeNP name in
  GMakeV' GArgNPNP GCallSomeoneSomething
    (GMakeArgNPNP subj' (GNPofReflexive GSelf) name')

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

