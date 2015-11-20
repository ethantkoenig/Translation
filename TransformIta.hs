module TransformIta where

import PGF hiding (Tree)
import qualified PGF

import Trans


{- NORMALIZE -}
normalizeVP :: GAbsVP -> GAbsVP
normalizeVP (GPositive vp_) = GPositive (normalizeVP_ vp_)
normalizeVP (GNegative vp_) = GNegative (normalizeVP_ vp_)


normalizeVP_ :: GAbsVP_ -> GAbsVP_
normalizeVP_ (GPresent (GMakeVP__ v')) = GPresent (GMakeVP__ (normalizeV' v'))
normalizeVP_ (GPast (GMakeVP__ v')) = GPast (GMakeVP__ (normalizeV' v'))
normalizeVP_ (GCond (GMakeVP__ v')) = GCond (GMakeVP__ (normalizeV' v'))
normalizeVP_ (GFuture (GMakeVP__ v')) = GFuture (GMakeVP__ (normalizeV' v'))


normalizeV' :: GAbsV' -> GAbsV'
normalizeV' (GAuxBe (GMakeVP__ v')) = GAuxBe (GMakeVP__ (normalizeV' v'))
normalizeV' (GAuxHave (GMakeVP__ v')) = GAuxHave (GMakeVP__ (normalizeV' v'))

normalizeV' (GMakeV' GArgNP GHave 
                     (GMakeArgNP subj 
                                 (GMakeNP GVoidD 
                                          (GMakeN' (GSingular GHunger))))) =
  GMakeV' GArgAdj GBe (GMakeArgAdj subj GHungry)

normalizeV' v = v -- base case


{- UNNORMALIZE -}
unnormalizeVP :: GAbsVP -> GAbsVP
unnormalizeVP (GPositive vp_) = GPositive (unnormalizeVP_ vp_)
unnormalizeVP (GNegative vp_) = GNegative (unnormalizeVP_ vp_)


unnormalizeVP_ :: GAbsVP_ -> GAbsVP_
unnormalizeVP_ (GPresent (GMakeVP__ v')) = GPresent (GMakeVP__ (unnormalizeV' v'))
unnormalizeVP_ (GPast (GMakeVP__ v')) = GPast (GMakeVP__ (unnormalizeV' v'))
unnormalizeVP_ (GCond (GMakeVP__ v')) = GCond (GMakeVP__ (unnormalizeV' v'))
unnormalizeVP_ (GFuture (GMakeVP__ v')) = GFuture (GMakeVP__ (unnormalizeV' v'))


unnormalizeV' :: GAbsV' -> GAbsV'
unnormalizeV' (GAuxBe (GMakeVP__ v')) = GAuxBe (GMakeVP__ (unnormalizeV' v'))
unnormalizeV' (GAuxHave (GMakeVP__ v')) = GAuxHave (GMakeVP__ (unnormalizeV' v'))

unnormalizeV' (GMakeV' GArgAdj GBe (GMakeArgAdj subj GHungry)) =
  (GMakeV' GArgNP GHave 
                       (GMakeArgNP subj 
                                   (GMakeNP GVoidD 
                                            (GMakeN' (GSingular GHunger)))))

unnormalizeV' v = v -- base case
    


