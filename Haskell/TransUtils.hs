module TransUtils where

import Prelude
import Trans

{- transforms -}

transformS :: (GAbsVP -> GAbsVP) -> GAbsS -> GAbsS
transformS f (GMakeS vp) = GMakeS (f vp)

transformCP :: (GAbsVP -> GAbsVP) -> GAbsCP -> GAbsCP
transformCP f (GMakeCP vp) = GMakeCP (f vp)


transformVP :: (GAbsVP_ -> GAbsVP_) -> GAbsVP -> GAbsVP
transformVP f (GPositive vp_) = GPositive (f vp_)
transformVP f (GNegative vp_) = GNegative (f vp_)

transformVP_ :: (GAbsVP__ -> GAbsVP__) -> GAbsVP_ -> GAbsVP_
transformVP_ f (GPresent vp__) = GPresent (f vp__)
transformVP_ f (GPast vp__) = GPast (f vp__)
transformVP_ f (GCond vp__) = GCond (f vp__)
transformVP_ f (GFuture vp__) = GFuture (f vp__)


transformVP__ :: (GAbsV' -> GAbsV') -> GAbsVP__ -> GAbsVP__
transformVP__ f (GMakeVP__ v') = GMakeVP__ (f v')

transformArgs :: (GAbsNP -> GAbsNP) -> (GAbsAdj -> GAbsAdj)
                   -> GAbsArgStructure -> GAbsArgStructure
transformArgs f g (GMakeArgVoid np) = GMakeArgVoid (f np)
transformArgs f g (GMakeArgNP np1 np2) = GMakeArgNP (f np1) (f np2)
transformArgs f g (GMakeArgAdj np adj) = GMakeArgAdj (f np) (g adj)
transformArgs f g (GMakeArgNPNP np1 np2 np3) = GMakeArgNPNP (f np1) (f np2) (f np3)

transformNP :: (GAbsN' -> GAbsN') -> GAbsNP -> GAbsNP
transformNP f (GMakeNP det n') = GMakeNP det (f n')
transformNP _ np = np -- base case

transformN' :: (GAbsCP -> GAbsCP) -> GAbsN' -> GAbsN'
transformN' f (GAdjoinN'CP n' cp) = GAdjoinN'CP n' (f cp)
transformN' _ n' = n' -- base case


{- extractions -}

n_OfDirObj :: GAbsArgStructure -> Maybe GAbsN_
n_OfDirObj (GMakeArgNP _ obj) = n_OfNP obj
n_OfDirObj (GMakeArgVoid _) = Nothing
n_OfDirObj (GMakeArgAdj _ _) = Nothing

n_OfNP :: GAbsNP -> Maybe GAbsN_
n_OfNP (GMakeNP _ n') = Just $ n_OfN' n'
n_OfNP (GPossessive _ n') = Just $ n_OfN' n'
n_OfNP (GNPofProNP _) = Nothing
n_OfNP (GNPofReflexive _) = Nothing
n_OfNP (GNullNP) = Nothing

n_OfN' :: GAbsN' -> GAbsN_
n_OfN' (GMakeN' n) = n_OfN n
n_OfN' (GAdjoinN'CP n' _) = n_OfN' n'

n_OfN :: GAbsN -> GAbsN_
n_OfN (GSingular n_ ) = n_
n_OfN (GPlural n_) = n_
